local function config()
    require("telescope.builtin").find_files({
        prompt_title = "Neovim Config",
        cwd = "$HOME/.dotfiles/nvim/",
    })
end

local function dotfiles()
    require("telescope.builtin").find_files({
        prompt_title = "Dotfiles",
        cwd = "$HOME/.dotfiles/",
    })
end

local function project_files(opts)
  opts = opts or  {}
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

return {
  config = config,
  dotfiles = dotfiles,
  project_files = project_files
}
