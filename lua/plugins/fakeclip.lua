-- https://github.com/kana/vim-fakeclip
return {
  "kana/vim-fakeclip",
  event = "VeryLazy",
  cond = function()
    return not vim.fn.empty(vim.env.WAYLAND_DISPLAY)
  end,
  config = function()
    vim.g.fakeclip_provide_clipboard_key_mappings = true
  end,
}
