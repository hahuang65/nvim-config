if vim.g.neovide then
  vim.opt.guifont =
    "Iosevka,Noto_Color_Emoji,Symbols_Nerd_Font_Mono,Powerline_Extra_Symbols,codicon,Noto_Sans_Symbols,Noto_Sans_Symbols2,Font_Awesome_6_Free:h12"
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.g.neovide_input_ime = false

  if vim.uv.os_uname() == "Darwin" then
    vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
    vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
    vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<D-v>", "<C-R>+") -- Paste insert mode
  else
    vim.keymap.set("n", "<C-v>", '"+P') -- Paste normal mode
    vim.keymap.set("v", "<C-v>", '"+P') -- Paste visual mode
    vim.keymap.set("c", "<C-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<C-v>", "<C-R>+") -- Paste insert mode
  end
end
