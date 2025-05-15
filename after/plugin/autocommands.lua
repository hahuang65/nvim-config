local util = require("util")

-- Create augroups
vim.api.nvim_create_augroup("active_window", { clear = true })
vim.api.nvim_create_augroup("autoreload", { clear = true })
vim.api.nvim_create_augroup("cleanup", { clear = true })
vim.api.nvim_create_augroup("folds", { clear = true })
vim.api.nvim_create_augroup("neotest", { clear = true })
vim.api.nvim_create_augroup("nvim_config", { clear = true })
vim.api.nvim_create_augroup("telescope", { clear = true })
vim.api.nvim_create_augroup("terminal", { clear = true })
vim.api.nvim_create_augroup("winbar", { clear = true })
vim.api.nvim_create_augroup("yank_highlight", { clear = true })

-- Autoreload current buffer when switching to it
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = "autoreload",
  pattern = { "*" },
  command = "silent! checktime",
})

-- Auto-save/load folds
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = "folds",
  pattern = { "*.*" },
  command = "mkview!",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "folds",
  pattern = { "*.*" },
  command = "silent! loadview",
})

-- Flash the yanked text when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "yank_highlight",
  pattern = { "*" },
  command = "silent! lua vim.highlight.on_yank()",
})

-- Reload nvim config when it changes
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "nvim_config",
  pattern = { "$MYVIMRC" },
  command = "source $MYVIMRC",
})

-- Clear editor clutter for terminal windows
vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal",
  pattern = { "*" },
  command = "setlocal nonumber norelativenumber nocursorline nocursorcolumn signcolumn=no statuscolumn=",
})

-- Map Ctrl-c even when not in insertmode
vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal",
  pattern = { "*" },
  command = "nnoremap <buffer> <C-c> i<C-c>",
})

-- This automatically closes terminals such as `:Git show` as well, which I don't want.
-- vim.api.nvim_create_autocmd("TermClose", {
--   desc = "Autoclose terminal when exiting",
--   group = "terminal",
--   pattern = { "*" },
--   command = "if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif"
-- })

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Clear editor clutter for telescope windows",
  group = "telescope",
  pattern = { "*" },
  callback = function()
    vim.schedule(function() -- Have to schedule, as Telescope doesn't set filetype upon open
      if vim.bo.filetype == "TelescopePrompt" then
        vim.opt_local.cursorline = false
        vim.opt_local.cursorcolumn = false
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end
    end)
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave" }, {
  desc = "Turn off certain UI elements when buffer is inactive",
  group = "active_window",
  pattern = { "*" },
  callback = function()
    local filetype_exclude = {
      "help",
      "lazy",
      "lspinfo",
      "mason",
      "NvimTree",
      "packer",
      "TelescopePrompt",
    }

    local buftype_exclude = {
      "terminal",
    }

    if vim.tbl_contains(filetype_exclude, vim.bo.filetype) or vim.tbl_contains(buftype_exclude, vim.bo.buftype) then
      return
    end

    vim.opt_local.cursorline = false
    vim.opt_local.cursorcolumn = false
    vim.opt_local.relativenumber = false
    vim.opt.statuscolumn = [[%!v:lua.inactive_statuscolumn()]]
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter" }, {
  desc = "Turn on relativenumber when buffer is active",
  group = "active_window",
  pattern = { "*" },
  callback = function()
    local filetype_exclude = {
      "help",
      "lazy",
      "lspinfo",
      "mason",
      "NvimTree",
      "packer",
      "TelescopePrompt",
    }

    local buftype_exclude = {
      "terminal",
    }

    if vim.tbl_contains(filetype_exclude, vim.bo.filetype) or vim.tbl_contains(buftype_exclude, vim.bo.buftype) then
      return
    end

    vim.opt_local.cursorline = true
    vim.opt_local.cursorcolumn = true
    vim.opt_local.relativenumber = true
    vim.opt.statuscolumn = [[%!v:lua.statuscolumn()]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "active_window",
  pattern = { "TelescopePrompt" },
  command = [[set nonumber norelativenumber statuscolumn=]],
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
  desc = "Close an unedited buffer if it's unnamed",
  group = "cleanup",
  pattern = { "*" },
  callback = function()
    if vim.bo.filetype == "" and vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "unload"
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "BufWritePost", "CursorHold", "CursorHoldI" }, {
  desc = "Set winbar to filename, when possible",
  group = "winbar",
  pattern = { "*" },
  callback = function()
    local filetype_exclude = {
      "dashboard",
      "fugitive",
      "gitcommit",
      "help",
      "lspinfo",
      "NvimTree",
      "packer",
      "qf",
      "terminal",
    }

    local filename = util.filename()
    if vim.fn.winheight(0) <= 1 or filename == "[No Name]" or vim.tbl_contains(filetype_exclude, vim.bo.filetype) then
      return
    end

    vim.opt_local.winbar = filename
  end,
})

for _, ft in ipairs({ "output", "attach", "summary" }) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "neotest-" .. ft,
    group = "neotest",
    callback = function(opts)
      vim.keymap.set("n", "q", function()
        pcall(vim.api.nvim_win_close, 0, true)
      end, {
        buffer = opts.buf,
      })
    end,
  })
end
