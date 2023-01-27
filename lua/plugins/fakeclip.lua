-- https://github.com/kana/vim-fakeclip
return {
  "kana/vim-fakeclip",
  config = function()
    vim.g.fakeclip_provide_clipboard_key_mappings = not vim.fn.empty(vim.env.WAYLAND_DISPLAY)
  end,
}
