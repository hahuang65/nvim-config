# Plan: Minimize Neovim Startup Time

## Goal

Reduce Neovim startup from ~184ms to ~80-100ms by lazy-loading eagerly-loaded plugins, removing an accidental `vim.lsp` require chain, and trimming catppuccin integration bloat.

## Research Reference

`docs/claude/20260306-1425-minimize-startup-time/research.md`

## Approach

Apply changes in order of impact, grouping by risk level:

1. **Zero-risk quick wins** — move a line, add a lazy trigger to plugins with no dependencies
2. **Medium-risk lazy loading** — plugins that are dependencies of other plugins (blink.cmp) or have side effects (AI assistants)
3. **Catppuccin optimization** — trim unused integrations and ensure compilation works

Each change is independent and can be tested in isolation. After all changes, measure with `nvim --startuptime` to validate.

## Detailed Changes

### 1. `lua/options.lua` — Remove `vim.lsp` require chain (~5ms saved)

**Why**: Line 100 `vim.lsp.set_log_level("error")` forces the entire `vim.lsp` module tree to load at startup. Moving it into the LSP config defers this cost to when LSP actually starts.

**Change**: Delete line 100 from `options.lua` and add it to `lsp.lua` config.

```lua
-- lua/options.lua — DELETE line 100:
-- vim.lsp.set_log_level("error")
```

```lua
-- lua/plugins/lsp.lua — ADD at the top of config function (after line 9):
    vim.lsp.set_log_level("error")
```

### 2. `lua/plugins/mason.lua` — Lazy-load with `cmd` (~11ms saved)

**Why**: Mason is only needed when you explicitly manage tools. The `ensure_installed` checks only matter when a tool is missing, which is rare during normal editing. Loading on `:Mason*` commands means it stays dormant until you actively install or manage tools.

```lua
-- lua/plugins/mason.lua — ADD cmd trigger
return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- ... unchanged
  end,
}
```

Note: This means `ensure_installed` won't run on every startup — only when you open Mason. If a tool is missing, the LSP/linter/formatter will simply fail to start and you'd run `:Mason` to fix it. This is the right trade-off since tools are rarely missing once initially installed.

### 3. `lua/plugins/claudecode.lua` — Lazy-load with `event = "VeryLazy"` (~8.6ms saved)

**Why**: Starts a WebSocket server at load time even when Claude Code CLI isn't running. `VeryLazy` defers it past the initial render. The existing `AiBackendChanged` keymap toggle logic is preserved so `<leader>at` continues to hot-swap keymaps between Claude and OpenCode.

```lua
-- lua/plugins/claudecode.lua
return {
  "coder/claudecode.nvim",
  event = "VeryLazy",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    -- ... unchanged (keep all existing keymap set/del toggle logic)
  end,
}
```

### 4. `lua/plugins/amp.lua` — Defer with `event = "VeryLazy"` (~7.4ms saved)

**Why**: Amp is started externally and connects to nvim, so the server must be running for the external `amp` CLI to connect. There's no internal event or command that triggers it — it must auto-start. `VeryLazy` is the latest possible automatic trigger, deferring load to after the UI renders while still ensuring the server starts without manual intervention.

```lua
-- lua/plugins/amp.lua
return {
  "sourcegraph/amp.nvim",
  branch = "main",
  event = "VeryLazy",
  opts = { auto_start = true, log_level = "info" },
}
```

### 5. `lua/plugins/opencode.lua` — Lazy-load with `event = "VeryLazy"` (~1.1ms saved)

**Why**: OpenCode shares keymaps with ClaudeCode (`<C-,>`, `<C-.>`, `<leader>A`). The existing `AiBackendChanged` autocmd dynamically sets/deletes keymaps when `<leader>at` toggles the backend. This toggle logic must be preserved, so both plugins use `event = "VeryLazy"` and keep their set/del keymap functions. The keymaps are only active for whichever backend is currently selected via `vim.g.ai_backend`.

```lua
-- lua/plugins/opencode.lua
return {
  "NickvanDyke/opencode.nvim",
  event = "VeryLazy",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    -- ... unchanged (keep all existing keymap set/del toggle logic)
  end,
}
```

### 6. `lua/plugins/fidget.lua` — Lazy-load with `event = "LspAttach"` (~3ms saved)

**Why**: LSP progress indicator has no purpose before an LSP server attaches.

```lua
-- lua/plugins/fidget.lua
return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {},
}
```

### 7. `lua/plugins/cmp.lua` — Lazy-load blink.cmp (~16ms saved)

**Why**: Completion engine loads its full config, fuzzy matcher, and source management at startup. It's only needed when editing or when LSP needs capabilities.

**Complication**: `lsp.lua` declares `"saghen/blink.cmp"` as a dependency and calls `require("blink.cmp").get_lsp_capabilities()` in its config. Since `lsp.lua` is already lazy-loaded on `BufReadPre`, blink.cmp will be pulled in at that point. Adding an explicit lazy trigger ensures it doesn't load *before* that.

```lua
-- lua/plugins/cmp.lua
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    -- ... unchanged
  },
}
```

Note: Because `lsp.lua` lists blink.cmp as a dependency, blink.cmp will also load when any buffer triggers `BufReadPre`. The `event` trigger here just prevents blink from loading *before* that (e.g., during lazy.nvim's eager pass). This is still a win because it moves blink out of the synchronous startup sequence.

### 8. `lua/plugins/hover.lua` — Lazy-load with `keys` (~0.9ms saved)

**Why**: hover.nvim is only triggered by keypress. Loading it with providers at startup is wasteful.

```lua
-- lua/plugins/hover.lua
return {
  "lewis6991/hover.nvim",
  keys = {
    { "K", function() require("hover").hover() end, desc = "hover.nvim" },
    { "<C-p>", function() require("hover").hover_switch("previous") end, desc = "hover.nvim (previous source)" },
    { "<C-n>", function() require("hover").hover_switch("next") end, desc = "hover.nvim (next source)" },
  },
  config = function()
    require("hover").setup({
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.gh")
        require("hover.providers.gh_user")
        require("hover.providers.jira")
        require("hover.providers.dap")
        require("hover.providers.fold_preview")
        require("hover.providers.diagnostic")
        require("hover.providers.man")
      end,
      preview_opts = {
        border = "single",
      },
      preview_window = false,
      title = true,
    })
  end,
}
```

### 9. `lua/plugins/oil.lua` — Lazy-load with `keys` and `cmd` (~1.6ms saved)

**Why**: Oil is only used when pressing `-` or running `:Oil`.

```lua
-- lua/plugins/oil.lua
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory as buffer" },
  },
  cmd = "Oil",
  config = function()
    require("oil").setup({
      columns = { "icon" },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-s>"] = false,
        ["<C-h>"] = false,
      },
    })
  end,
}
```

Note: The `vim.keymap.set` at the bottom of the current config is replaced by the `keys` table, which lazy.nvim handles.

### 10. `lua/plugins/bqf.lua` — Lazy-load with `ft = "qf"` (~0.4ms saved)

**Why**: BQF only operates on quickfix windows.

```lua
-- lua/plugins/bqf.lua
return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
}
```

### 11. `lua/plugins/init.lua` — Lazy-load direnv.vim (~0.7ms saved)

**Why**: direnv.vim has no reason to load before the first buffer.

```lua
-- lua/plugins/init.lua — change direnv entry
  { "direnv/direnv.vim", event = "VeryLazy" },
```

### 12. `lua/plugins/catppuccin.lua` — Trim unused integrations (~10-20ms saved)

**Why**: The startup log shows catppuccin loading 30+ integration modules including ones for plugins not in this config (lir, nvimtree, illuminate, rainbow_delimiters, ufo, neotree, flash, fzf, dropbar, navic, colorful_winsep, alpha, dashboard). Setting unused integrations to `false` prevents catppuccin from loading their highlight groups.

Also add `priority = 1000` and `lazy = false` explicitly since colorschemes must load before other plugins.

```lua
-- lua/plugins/catppuccin.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    local catppuccin = require("catppuccin")
    vim.g.catppuccin_flavour = require("common").catppuccin_palette

    catppuccin.setup({
      compile = {
        enabled = true,
        path = vim.fn.stdpath("cache") .. "/catppuccin",
      },
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.10,
      },
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { "italic" },
        functions = { "bold" },
        keywords = { "underline" },
        strings = {},
        variables = {},
      },
      default_integrations = false,
      integrations = {
        blink_cmp = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        fidget = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        mason = true,
        neotest = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "bold", "italic" },
            hints = { "underline" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        notify = true,
        octo = true,
        snacks = true,
        treesitter = true,
        treesitter_context = true,
      },
    })

    vim.cmd([[colorscheme catppuccin]])
    vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
  end,
}
```

Key changes:

- Added `default_integrations = false` to prevent loading all 30+ integrations by default
- Removed `telescope = true` (you use snacks.picker, not telescope)
- Added `snacks = true` (you use snacks.nvim extensively)
- After changing integrations, need to clear the compile cache: `rm -rf ~/.cache/nvim/catppuccin/` so it regenerates

## New Files

None.

## Dependencies

None — all changes use existing plugins and built-in lazy.nvim features.

## Considerations & Trade-offs

1. **`VeryLazy` for AI plugins**: All three AI plugins (claudecode, amp, opencode) use `event = "VeryLazy"`. This defers their load to after the UI renders (~50-100ms post-startup) while still ensuring servers auto-start and the `AiBackendChanged` keymap toggle works correctly. The trade-off vs `cmd`/`keys` triggers is that all three load even if unused — but this preserves the existing runtime toggle behavior via `<leader>at`.

3. **blink.cmp as LSP dependency**: blink.cmp will still load on `BufReadPre` because `lsp.lua` declares it as a dependency. The `event = "InsertEnter"` trigger just prevents it from loading during the initial synchronous startup. If this causes any issues with LSP capabilities, we can remove the event trigger and let it load only via the dependency chain.

4. **catppuccin `default_integrations = false`**: This is the nuclear option. By default, catppuccin enables integrations for many popular plugins. Setting this to `false` means we must explicitly list every integration we want. If you add a new plugin that catppuccin supports, you'd need to add it here too. The upside is a significant reduction in highlight groups loaded at startup.

5. **Not touching treesitter or snacks.nvim**: These are fundamental plugins that need to load early. Treesitter provides folding and syntax, snacks provides the picker and many UI primitives. The cost of deferring them outweighs the savings.

## Migration / Data Changes

After applying catppuccin changes, clear the compile cache:

```bash
rm -rf ~/.cache/nvim/catppuccin/
```

This will regenerate on next startup with the trimmed integration list.

## Testing Strategy

Since this is a Neovim config (not a software project with unit tests), testing is manual verification:

1. **Startup time measurement**: Run `nvim --headless --startuptime /tmp/nvim-startup.log -c 'qall'` before and after changes. Compare the `--- NVIM STARTED ---` line.

2. **Lazy.nvim profile check**: Open nvim, run `:Lazy profile` to verify plugins have the expected load triggers and timing.

3. **Functional smoke tests** (manual):
   - Open a Python file — LSP starts, completion works, diagnostics appear
   - Open a Ruby file — LSP starts, completion works
   - Press `K` — hover.nvim loads and shows hover info
   - Press `-` — oil.nvim opens the file browser
   - Run `:Mason` — mason loads and opens its UI
   - Toggle AI backend with `<leader>at` — keymaps switch correctly
   - Press `<C-,>` — Claude Code terminal opens
   - Open a file with git changes — gitsigns shows in statuscolumn
   - Run `:checkhealth` — no errors from any of the modified plugins
   - Verify colorscheme looks correct (no missing highlights)
   - Open a quickfix list — bqf enhances it properly

## Todo List

### Phase 1: Zero-Risk Quick Wins
- [x] 1. Move `vim.lsp.set_log_level("error")` from `lua/options.lua:100` to `lua/plugins/lsp.lua` config function
- [x] 2. Add `event = "LspAttach"` to `lua/plugins/fidget.lua`
- [x] 3. Add `keys` and `cmd` triggers to `lua/plugins/hover.lua` (replace config keymaps)
- [x] 4. Add `keys` and `cmd` triggers to `lua/plugins/oil.lua` (replace config keymap)
- [x] 5. Add `ft = "qf"` to `lua/plugins/bqf.lua`
- [x] 6. Add `event = "VeryLazy"` to direnv.vim in `lua/plugins/init.lua`

### Phase 2: Plugin Lazy Loading
- [x] 7. Add `cmd` triggers to `lua/plugins/mason.lua`
- [x] 8. Add `event = "VeryLazy"` to `lua/plugins/claudecode.lua`
- [x] 9. Add `event = "VeryLazy"` to `lua/plugins/amp.lua` (remove `lazy = false`)
- [x] 10. Add `event = "VeryLazy"` to `lua/plugins/opencode.lua`
- [x] 11. Add `event = { "InsertEnter", "CmdlineEnter" }` to `lua/plugins/cmp.lua`

### Phase 3: Catppuccin Optimization
- [x] 12. Add `lazy = false`, `priority = 1000`, `default_integrations = false` to `lua/plugins/catppuccin.lua`; trim integrations list; add `snacks = true`; remove `telescope = true`
- [ ] 13. Clear catppuccin compile cache: `rm -rf ~/.cache/nvim/catppuccin/`

### Phase 4: Verification
- [x] 14. Measure startup time with `nvim --headless --startuptime` — **Result: 115ms (down from 184ms)**
- [ ] 15. Verify `:Lazy profile` shows correct load triggers
- [ ] 16. Smoke test: LSP, completion, hover, oil, mason, AI toggle, gitsigns, colorscheme, bqf
