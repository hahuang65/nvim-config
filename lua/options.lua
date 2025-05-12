local opt = vim.opt

-- Editing
opt.backspace = { "indent", "eol", "start" } -- Allows backspace to delete indents, EOLs, and past the start position of entering insert mode
opt.formatoptions = opt.formatoptions + "j" -- Join lines smartly
opt.hidden = true -- Allows hiding a buffer when without writing it to disk

-- Colorscheme
opt.background = "dark" -- Dark-mode
opt.termguicolors = true -- Enables 24-bit colors in the TUI. Uses `gui` highlights instead of `cterm`

-- File formats
opt.encoding = "utf-8"
opt.fileformats = { "unix", "dos", "mac" }

-- Timings
opt.timeoutlen = 500 -- Shorter interval between mapped sequence keypresses, too short breaks comment.nvim's operator pending bindings: https://github.com/numToStr/Comment.nvim/issues/134
opt.updatetime = 50 -- Faster interval between `CursorHold` events

-- Interface
opt.cursorline = true -- Highlight the current line
opt.cursorcolumn = true -- Highlight the current column
opt.lazyredraw = true -- Don't redraw for macros and commands that aren't manually typed
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.showmatch = true -- Briefly flash a matching bracket/parenthesis when cursor moves onto one
opt.mouse = "" -- Disable mouse

-- Per-Project
opt.exrc = true -- Allow local configuration files per project
opt.secure = true -- Disallows autocmd, shell, anda write commands in local configuration files

-- Swapfile
opt.swapfile = false -- Disable swapfiles

-- Indentation
opt.autoindent = true -- Auto-indent lines based on previous lines
opt.expandtab = true -- Use soft-tabs
opt.shiftwidth = 2 -- Spaces per indent
opt.smartindent = true -- Syntax-aware indentation (i.e. matching brackets and parentheses)
opt.smarttab = true -- Use `shiftwidth` when inserting tabs at front of the line
opt.softtabstop = 2 -- Use 2 spaces per tab
opt.tabstop = 2 -- Tab size of 2

-- Line Breaks
opt.textwidth = 0 -- Disable linebreaking by line size
opt.wrap = false -- Do not wrap lines automatically
opt.wrapmargin = 0 -- Disable linebreaking by window borders

-- Search
opt.incsearch = true -- Search-as-you-type
opt.inccommand = "split" -- Show changes of a command as you type
opt.ignorecase = true -- Ignore casing during search, must be set to complement `smartcase`
opt.infercase = true -- `smartcase` for completion results
opt.smartcase = true -- Case sensitivity based on searched text
opt.foldclose = "all" -- Re-close folds when navigating out of them

-- Scrolling
opt.scrolloff = 20 -- Start scrolling the window before the top/bottom margins
opt.sidescrolloff = 20 -- Start scrolling the window before the side margins
opt.sidescroll = 1 -- Scroll in steps of 1 character when at the edge of the window

-- Splits
opt.splitbelow = true -- Split to the bottom instead of the top
opt.splitright = true -- Split to the right instead of left

-- Completion
opt.completeopt = { "menu", "menuone", "noinsert" } -- Show completion even when only 1 result, but do not auto-select first result
opt.shortmess = opt.shortmess + "cI" -- Skip completion pop-up messages

-- Undo
opt.undofile = true -- Enable undo

-- Auto Reload
opt.autoread = true

-- Statusbar and separators
opt.laststatus = 3 -- Global statusbar
opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

-- Statuscolumn
opt.statuscolumn = [[%!v:lua.statuscolumn()]]
opt.signcolumn = "no" -- Disable, as we build our own statuscolumn. Setting this will reserve space that the normal statuscolumn would use.

-- Disable Perl provider
vim.g.loaded_perl_provider = 0
-- Use mise Python
vim.g.python3_host_prog = vim.fn.expand(require("common").shims_dir) .. "/python3"

-- Disable ftplugin mappings
vim.g.no_plugin_maps = 1
vim.lsp.set_log_level("error")
