local util = require("util")

-- Create augroups
vim.api.nvim_create_augroup("active_window", { clear = true })
vim.api.nvim_create_augroup("autoformatting", { clear = true })
vim.api.nvim_create_augroup("autoreload", { clear = true })
vim.api.nvim_create_augroup("cleanup", { clear = true })
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
  command = "setlocal nonumber norelativenumber nocursorline nocursorcolumn signcolumn=no",
})

-- Map Ctrl-c even when not in insertmode
vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal",
  pattern = { "*" },
  command = "nnoremap <buffer> <C-c> i<C-c>",
})

-- Start insertmode when opening a terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal",
  pattern = { "*" },
  callback = function()
    if vim.startswith(vim.api.nvim_buf_get_name(0), "term://") then
      vim.cmd("startinsert")
    end
  end,
})

-- Autoclose terminal when exiting
vim.api.nvim_create_autocmd("TermClose", {
  group = "terminal",
  pattern = { "*" },
  command = [[call nvim_input("<CR>")]],
})

-- Clear editor clutter for telescope windows
vim.api.nvim_create_autocmd("BufEnter", {
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
-- Turn off certain UI elements when buffer is inactive
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave" }, {
  group = "active_window",
  pattern = { "*" },
  callback = function()
    local filetype_exclude = {
      "dashboard",
      "fugitive",
      "help",
      "lazy",
      "lspinfo",
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
  end,
})

-- Turn on relativenumber when buffer is active
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter" }, {
  group = "active_window",
  pattern = { "*" },
  callback = function()
    local filetype_exclude = {
      "dashboard",
      "fugitive",
      "help",
      "lazy",
      "lspinfo",
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
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "active_window",
  pattern = { "TelescopePrompt" },
  command = [[set nonumber norelativenumber]],
})

-- Format buffers before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "autoformatting",
  pattern = { "*" },
  callback = function()
    if string.match(vim.api.nvim_buf_get_name(0), ".+/a5/*") then
      return
    end

    vim.lsp.buf.format()
  end,
})

-- Close an unedited buffer if it's unnamed
vim.api.nvim_create_autocmd({ "BufLeave" }, {
  group = "cleanup",
  pattern = { "*" },
  callback = function()
    if vim.bo.filetype == "" and vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "unload"
    end
  end,
})

-- Set winbar to filename, when possible
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "BufWritePost", "CursorHold", "CursorHoldI" }, {
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
    }

    local filename = util.filename()
    if vim.fn.winheight(0) <= 1 or filename == "[No Name]" or vim.tbl_contains(filetype_exclude, vim.bo.filetype) then
      return
    end

    vim.opt_local.winbar = filename
  end,
})
