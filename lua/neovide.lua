if vim.g.neovide then
  vim.g.neovide_input_ime = false

  if vim.uv.os_uname().sysname == "Darwin" then
    vim.opt.guifont =
      "Iosevka,Noto Color Emoji,Symbols Nerd Font Mono,Powerline Extra Symbols,codicon,Noto Sans Symbols,Noto Sans Symbols2,Font Awesome 6 Free:h15:#e-subpixelantialias:#h-none"
    vim.g.neovide_input_macos_alt_is_meta = true

    vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
    vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
    vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<D-v>", "<C-R>+") -- Paste insert mode
    vim.keymap.set("t", "<D-v>", "<C-R>+") -- Paste terminal mode
    vim.keymap.set("t", "<D-v>", function() -- Paste terminal mode
      return '<C-\\><C-N>"+pi'
    end, { expr = true })
  else
    vim.opt.guifont =
      "Iosevka,Noto_Color_Emoji,Symbols_Nerd_Font_Mono,Powerline_Extra_Symbols,codicon,Noto_Sans_Symbols,Noto_Sans_Symbols2,Font_Awesome_6_Free:h12"

    vim.keymap.set("n", "<C-S-v>", '"+P') -- Paste normal mode
    vim.keymap.set("v", "<C-S-v>", '"+P') -- Paste visual mode
    vim.keymap.set("c", "<C-S-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<C-S-v>", "<C-R>+") -- Paste insert mode
    vim.keymap.set("t", "<C-S-v>", function() -- Paste terminal mode
      return '<C-\\><C-N>"+pi'
    end, { expr = true })
  end
end
