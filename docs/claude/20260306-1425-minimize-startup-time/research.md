# Research: Neovim Startup Time Optimization

## Overview

The Neovim configuration at `~/.dotfiles/nvim` uses lazy.nvim as the plugin manager with 72 total plugins. Current startup time is **~184ms** (measured via `--startuptime`). The configuration follows a modular structure with plugins split into individual files under `lua/plugins/`.

## Startup Timeline (from `--startuptime`)

| Phase | Clock (ms) | Duration (ms) | Notes |
|-------|-----------|---------------|-------|
| NVIM STARTING | 0 | - | |
| Early init + locale | 1.0 | 1.0 | |
| Init lua interpreter | 2.2 | 0.4 | |
| Expanding arguments | 4.9 | 2.7 | |
| Default mappings | 6.2 | 1.1 | |
| User config modules | 6.2 - 18.0 | ~12 | options, keymaps, statuscolumn, etc. |
| lazy.nvim bootstrap | 18.0 - 24.8 | ~7 | require('lazy') + internals |
| lazy.nvim plugin load | 24.8 - 170.3 | **~145** | **THE BOTTLENECK** |
| Runtime plugins | 170.3 - 182.0 | ~12 | Neovim built-in runtime |
| NVIM STARTED | 184.1 | - | Total |

## Architecture

### Init Flow (`init.lua`)

```
init.lua
  |- vim.g.mapleader = " "
  |- safeRequire("netrw")        -- ~0.3ms
  |- safeRequire("options")      -- ~5.8ms (triggers vim.lsp require chain!)
  |- safeRequire("filetype")     -- ~0.2ms
  |- safeRequire("neovide")      -- ~0.2ms
  |- safeRequire("statuscolumn") -- ~1.7ms (requires signs -> vim.diagnostic)
  |- safeRequire("terminal")     -- ~0.2ms
  |- safeRequire("keymaps")      -- ~0.6ms (requires util)
  |- lazy.nvim bootstrap
  |- PATH manipulation (mise shims)
  |- require("lazy").setup("plugins")  -- ~145ms
  |- syntax enable
  |- filetype plugin on
```

### Key Files

| File | Role | Startup Impact |
|------|------|----------------|
| `init.lua` | Entry point | Orchestrator |
| `lua/options.lua` | Vim options | **5.8ms** - triggers `vim.lsp` require chain via `vim.lsp.set_log_level` |
| `lua/signs.lua` | Sign definitions | 1.4ms - requires `vim.diagnostic` |
| `lua/statuscolumn.lua` | Custom statuscolumn | 1.7ms - requires signs |
| `lua/keymaps.lua` | Key mappings | 0.6ms - requires util |
| `lua/common.lua` | Shared constants | 0.2ms |
| `lua/tools.lua` | Tool registry (LSPs, formatters, linters) | 0.3ms |

## Eagerly-Loaded Plugins (No Lazy Trigger)

These plugins load at startup regardless of whether they're needed. This is the primary optimization target.

| Plugin | Load Time (ms) | Why Eager? |
|--------|----------------|------------|
| **blink.cmp** | ~16 | No event/cmd/keys trigger |
| **mason.nvim** (+ lspconfig, tool-installer) | ~11.4 | No event trigger |
| **claudecode.nvim** | ~8.6 | No event trigger; starts WebSocket server |
| **amp.nvim** | ~7.4 | `lazy = false`; starts TCP server |
| **nvim-treesitter** (+ context, endwise, textobjects) | ~5.5 | `lazy = false` |
| **catppuccin** | ~4.0 | No event trigger (colorscheme) |
| **fidget.nvim** | ~2.9 | No event trigger |
| **oil.nvim** | ~1.6 | No event trigger |
| **opencode.nvim** | ~1.1 | No event trigger |
| **snacks.nvim** (+ mini.icons, nvim-web-devicons) | ~1.0 | `lazy = false, priority = 1000` |
| **hover.nvim** | ~0.9 | No event trigger |
| **nvim-bqf** | ~0.4 | No event trigger |
| **direnv.vim** | ~0.7 | No event trigger |
| **molten.nvim** | - | Has `init` + `keys` but no lazy trigger on main spec |

**Total eager plugin time: ~62ms** (of ~145ms plugin phase)

## Detailed Analysis of Heavy Hitters

### 1. claudecode.nvim (~8.6ms + server startup)

**File**: `lua/plugins/claudecode.lua`

Starts a WebSocket server on load (`claudecode.server.init`, `claudecode.server.tcp`). Requires 15+ modules at startup including `claudecode.diff`, `claudecode.selection`, all tool modules, and `snacks.terminal`.

**Problem**: Server starts even when Claude Code CLI isn't running. The `config` function does heavy work: setting up autocmds, defining/deleting keymaps.

**Optimization potential**: HIGH. Could be loaded on `cmd = "ClaudeCode*"` or `keys` only, or deferred with `event = "VeryLazy"`.

### 2. amp.nvim (~7.4ms)

**File**: `lua/plugins/amp.lua`

`lazy = false` with `auto_start = true`. Starts a TCP server immediately. Requires `amp.server.*` modules (~4.8ms just for server utils/frame/client/tcp).

**Problem**: Server starts even when Amp CLI isn't running.

**Optimization potential**: HIGH. Could use `event = "VeryLazy"` or `cmd` trigger.

### 3. mason.nvim (~11.4ms combined)

**File**: `lua/plugins/mason.lua`

Loads mason core (~3ms), mason-registry (~3.5ms), mason-lspconfig (~0.5ms), mason-tool-installer (~0.5ms), plus deep dependency chain (installer, compiler, linker, package management).

**Problem**: Mason is only needed when installing/managing tools, not during normal editing. Yet it loads eagerly with no lazy trigger.

**Optimization potential**: HIGH. Could use `cmd = { "Mason", "MasonInstall", "MasonUpdate" }` or `event = "VeryLazy"`.

### 4. blink.cmp (~16ms)

**File**: `lua/plugins/cmp.lua`

Loads the full completion engine at startup: config modules, fuzzy matching, source management. Includes binary download checks.

**Problem**: No lazy trigger at all. Completion is only needed when editing.

**Optimization potential**: MEDIUM-HIGH. Could use `event = "InsertEnter"` or `event = { "InsertEnter", "CmdlineEnter" }`. However, it's a dependency of `nvim-lspconfig` (for capabilities), so care is needed.

### 5. catppuccin (~4ms + ~20ms compilation)

**File**: `lua/plugins/catppuccin.lua`

Has `compile = { enabled = true }` but still loads 30+ integration modules at startup. The compilation feature should cache highlights, but `--startuptime` shows it loading many `catppuccin.groups.integrations.*` modules (lines 316-349 in startup log, spanning ~20ms).

**Problem**: Loads all integration highlight groups even if those plugins aren't active. Compilation may not be effectively caching.

**Optimization potential**: MEDIUM. Set `priority = 1000` explicitly and use `lazy = false` (which it implicitly already does). The real fix is ensuring compilation cache is working and reducing integration list to only used plugins.

### 6. nvim-treesitter (~5.5ms)

**File**: `lua/plugins/treesitter.lua`

`lazy = false`. Registers 35 parsers, sets up textobjects with extensive keymaps, loads `nvim-treesitter-textobjects.repeatable_move` eagerly.

**Problem**: Mostly necessary at startup for folding and syntax. However, registering keymaps for textobjects could be deferred.

**Optimization potential**: LOW. Treesitter is fundamental. The `repeatable_move` require and keymap registration in `register_keymaps()` could be wrapped in `vim.schedule` to defer slightly.

### 7. options.lua (5.8ms)

**File**: `lua/options.lua`

Line 100: `vim.lsp.set_log_level("error")` triggers the entire `vim.lsp` module chain (~5.2ms):
- `vim.lsp.log` (0.4ms)
- `vim.lsp.protocol` (0.9ms)
- `vim.lsp.util` (1.1ms)
- `vim.lsp.sync` (0.5ms)
- `vim.lsp._changetracking` (1.0ms)
- `vim.lsp.rpc` (0.7ms)

**Problem**: A single configuration line causes ~5ms of unnecessary module loading.

**Optimization potential**: HIGH. Move `vim.lsp.set_log_level` to `LspAttach` autocmd or the LSP config function.

### 8. fidget.nvim (~2.9ms)

**File**: `lua/plugins/fidget.lua`

Loads with just `opts = {}` but no lazy trigger. Requires 12+ fidget modules (spinner, progress, notification, etc.).

**Problem**: LSP progress indicator loading before any LSP is active.

**Optimization potential**: HIGH. Should use `event = "LspAttach"`.

### 9. hover.nvim (~0.9ms)

**File**: `lua/plugins/hover.lua`

Loads 7 providers eagerly in `init` function. No lazy trigger.

**Optimization potential**: MEDIUM. Could use `keys = { { "K", ... }, { "<C-p>", ... }, { "<C-n>", ... } }`.

### 10. oil.nvim (~1.6ms)

**File**: `lua/plugins/oil.lua`

No lazy trigger despite being easily deferrable.

**Optimization potential**: MEDIUM. Could use `cmd = "Oil"` and `keys = { { "-", "<cmd>Oil<CR>" } }`.

### 11. nvim-bqf (~0.4ms)

**File**: `lua/plugins/bqf.lua`

Just `{ "kevinhwang91/nvim-bqf" }` - no configuration, no lazy trigger.

**Optimization potential**: LOW-MEDIUM. Could use `ft = "qf"`.

### 12. direnv.vim (~0.7ms)

**File**: In `lua/plugins/init.lua`

No lazy trigger: `{ "direnv/direnv.vim" }`.

**Optimization potential**: LOW-MEDIUM. Could use `event = "VeryLazy"`.

### 13. Neovim Runtime Overhead

- `matchit.vim`: 3.6ms (built-in, sourced automatically)
- `rplugin.vim`: 2.8ms (for remote plugins like molten-nvim)
- `syntax/synload.vim`: 0.6ms
- Various runtime plugins: ~3ms

**Optimization potential**: LOW. Could disable matchit if not needed (`vim.g.loaded_matchit = 1`), disable remote plugins if molten is rarely used.

## Patterns & Conventions

1. **Plugin organization**: One file per plugin in `lua/plugins/`, except simple plugins in `lua/plugins/init.lua`
2. **Lazy loading triggers used**: `event`, `cmd`, `ft`, `keys` - but inconsistently applied
3. **Dependency declarations**: Used but some are redundant (snacks.nvim declared as dep in multiple places)
4. **AI backends**: Three AI tools loaded simultaneously (amp, claudecode, opencode) despite only one active at a time

## Edge Cases & Gotchas

1. **`options.lua` line 100** triggers the entire `vim.lsp` module tree (~5ms). This is the single most impactful non-plugin startup cost.

2. **Three AI coding assistants** (amp.nvim, claudecode.nvim, opencode.nvim) all load eagerly. Only one is active at a time (controlled by `vim.g.ai_backend`). They start servers/processes that sit idle.

3. **catppuccin compilation** appears to not fully cache - still loads 30+ integration modules. The `compile.path` is set but may need `CatppuccinCompile` to be run after config changes.

4. **snacks.nvim `init` function** calls `require("mini.icons").setup()` and `require("nvim-web-devicons").setup()` synchronously during startup. This costs ~4ms for icon loading.

5. **`signs.lua`** uses `vim.fn.sign_define()` for all signs at require-time, which triggers vim.diagnostic loading (~1.2ms). Could defer to first use.

6. **`statuscolumn.lua`** requires `signs` at module level, creating a chain: init -> statuscolumn -> signs -> vim.diagnostic.

7. **`molten.nvim`** has an `init` function that runs at startup (setting vim.g variables) and its `build = ":UpdateRemotePlugins"` causes rplugin.vim to load (~2.8ms).

## Current State Summary

- **Total startup: ~184ms**
- **Plugin loading: ~145ms** (79% of total)
- **Biggest wins available**:
  1. Lazy-load mason.nvim → save ~11ms
  2. Lazy-load claudecode.nvim → save ~8.6ms
  3. Lazy-load amp.nvim → save ~7.4ms
  4. Move `vim.lsp.set_log_level` → save ~5ms
  5. Lazy-load blink.cmp → save ~16ms (careful with LSP dep)
  6. Lazy-load fidget.nvim → save ~3ms
  7. Fix catppuccin compilation → save ~10-20ms
  8. Lazy-load opencode.nvim → save ~1ms
  9. Lazy-load hover.nvim → save ~0.9ms
  10. Lazy-load oil.nvim → save ~1.6ms
- **Estimated achievable startup**: ~80-100ms (55-65% reduction)
