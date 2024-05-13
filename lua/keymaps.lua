local function keymap(modes, lhs, rhs, opts)
  if not opts then
    opts = {}
  end
  opts.unique = true
  vim.keymap.set(modes, lhs, rhs, opts)
end

-- Better than defaults
keymap("n", "J", "mzJ`z", { desc = "Join lines without moving cursor to the end" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll half-page without moving cursor" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll half-page without moving cursor" })
keymap("n", "n", "nzzzv", { desc = "Go to next search result without moving cursor" })
keymap("n", "N", "Nzzzv", { desc = "Go to next search result without moving cursor" })
keymap("v", ">", ">gv", { desc = "Re-highlight after indenting" })
keymap("v", "<", "<gv", { desc = "Re-highlight after indenting" })

-- Editing Improvements
keymap("x", "<leader>p", '"_dP', { desc = "Paste without clobbering default register" })
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without clobbering default register" })
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Folds
keymap({ "n", "v" }, "<Tab>", "za", { desc = "Toggle folds" })
keymap({ "n", "v" }, "zz", "zf", { desc = "Define fold" })

-- Copy/Paste
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap({ "n" }, "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })
keymap("x", "<leader>P", require("util").paste, { desc = "Create [P]aste in paste.sr.ht" })

-- Quickfix
keymap("n", "<leader>q", require("util").toggle_quickfix, { desc = "Toggle [q]uickfix list" })
keymap("n", "]q", ":cnext<CR>", { desc = "Next quickfix entry" })
keymap("n", "[q", ":cprev<CR>", { desc = "Previous quickfix entry" })

-- Macros
keymap("n", "Q", "@qj")
-- Deprecated due to https://github.com/neovim/neovim/pull/26495/commits/f26cc480f5a11cca44256b87684e401c00e87408
-- keymap("x", "Q", ":norm @q<CR>")

-- Window movement
keymap("n", "<C-M-h>", "<C-w>h", { desc = "Switch to window left" })
keymap("n", "<C-M-j>", "<C-w>j", { desc = "Switch to window below" })
keymap("n", "<C-M-k>", "<C-w>k", { desc = "Switch to window above" })
keymap("n", "<C-M-l>", "<C-w>l", { desc = "Switch to window right" })
keymap("n", "<C-M-q>", ":bd<CR>", { desc = "Close buffer" })
keymap("n", "<M-,>", "<C-w>5<", { desc = "Resize window right" })
keymap("n", "<M-.>", "<C-w>5>", { desc = "Resize window left" })
keymap("n", "<M-/>", "<C-w>+", { desc = "Resize window down" })
keymap("n", "<M-'>", "<C-w>-", { desc = "Resize window up" })

-- Terminal
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Go to normal mode" })
keymap("t", "<C-M-h>", "<C-\\><C-n><C-w>h", { desc = "Switch to window left" })
keymap("t", "<C-M-j>", "<C-\\><C-n><C-w>j", { desc = "Switch to window below" })
keymap("t", "<C-M-k>", "<C-\\><C-n><C-w>k", { desc = "Switch to window above" })
keymap("t", "<C-M-l>", "<C-\\><C-n><C-w>l", { desc = "Switch to window right" })

keymap("n", "<M-[>", ":Terminal Console<CR>", { desc = "Open console terminal" })
keymap("t", "<M-[>", "<C-\\><C-n>:Terminal Console<CR>", { desc = "Open console terminal" })
keymap("n", "<M-{>", ":Vterminal Console<CR>", { desc = "Open console terminal (vertical)" })
keymap("t", "<M-{>", "<C-\\><C-n>:Vterminal Console<CR>", { desc = "Open console terminal (vertical)" })

keymap("n", "<M-]>", ":Terminal Server<CR>", { desc = "Open server terminal" })
keymap("t", "<M-]>", "<C-\\><C-n>:Terminal Server<CR>", { desc = "Open server terminal" })
keymap("n", "<M-}>", ":Vterminal Server<CR>", { desc = "Open server terminal (vertical)" })
keymap("t", "<M-}>", "<C-\\><C-n>:Vterminal Server<CR>", { desc = "Open server terminal (vertical)" })

keymap("n", "<M-`>", ":Terminal Terminal<CR>", { desc = "Open terminal" })
keymap("t", "<M-`>", "<C-\\><C-n>:Terminal Terminal<CR>", { desc = "Open terminal (vertical)" })
keymap("n", "<M-~>", ":Vterminal Terminal<CR>", { desc = "Open terminal (vertical)" })
keymap("t", "<M-~>", "<C-\\><C-n>:Vterminal Terminal<CR>", { desc = "Open terminal (vertical)" })

keymap("n", "<leader>cd", function()
  SyncTerminalWorkDir()
end, { desc = "Change the terminal directory to the current Neovim working directory" })

-- Project quick-access
keymap("n", "<leader><leader>", require("finders").project_files, { desc = "Search Project/Files" })
keymap("n", "<leader>ed", require("finders").dotfiles, { desc = "[E]dit [D]otfiles" })
keymap("n", "<leader>ep", require("finders").projects, { desc = "[E]dit [P]rojects" })
keymap("n", "<leader>ev", require("finders").config, { desc = "[E]dit Neo[v]im Config" })

-- Diagnostics
keymap("n", "<leader>D", vim.diagnostic.open_float, { desc = "Open Diagnostic in Float" })

-- Refactoring
keymap("x", "<leader>xf", ":Refactor extract ")
keymap("x", "<leader>xF", ":Refactor extract_to_file ")

keymap("x", "<leader>xv", ":Refactor extract_var ")

keymap({ "n", "x" }, "<leader>iv", ":Refactor inline_var")

keymap("n", "<leader>if", ":Refactor inline_func")

keymap("n", "<leader>xb", ":Refactor extract_block")
keymap("n", "<leader>xB", ":Refactor extract_block_to_file")
