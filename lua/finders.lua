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

local function projects()
  local iter = require("plenary.iterators")
  local path = require("plenary.path")
  local scan = require("plenary.scandir")

  local project_dirs = {
    "~/Documents/Projects",
    "~/Documents/Projects/a5",
    "~/.dotfiles"
  }

  local project_names = {}
  local projects_tbl = {}
  iter.iter(project_dirs)
  :map(function(dir)
    local git_dirs = scan.scan_dir(vim.fn.expand(dir), {
      depth = 2,
      add_dirs = true,
      hidden = true,
      search_pattern = "%.git$"
    })
    return iter.iter(git_dirs)
      :map(function(git_dir) return path:new(git_dir):parent() end)
  end)
  :flatten()
  :for_each(function(dir)
    local shortname = tostring(dir):match("[^/]+/?$")
    table.insert(project_names, shortname)
    projects_tbl[shortname] = dir.filename
  end)


  vim.ui.select(project_names,
    { prompt = "Select Project:" },
    function(proj)
      if proj then
        vim.cmd("cd " .. projects_tbl[proj])
        vim.cmd("lua require('finders').project_files()")
      end
    end
  )
end

return {
  config = config,
  dotfiles = dotfiles,
  projects = projects,
  project_files = project_files
}
