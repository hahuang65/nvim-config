-- https://github.com/hoob3rt/lualine.nvim
-- https://gist.githubusercontent.com/hoob3rt/b200435a765ca18f09f83580a606b878/raw/d99388470ed5ddb1da32a0bd3bccd4a69eb15429/evil_lualine.lua

local lualine = require 'lualine'

-- Tokyo Night Storm
local colors = {
  bg       = '#414868',
  fg       = '#a9b1d6',
  yellow   = '#e0af68',
  cyan     = '#7dcfff',
  darkblue = '#2ac3de',
  green    = '#73daca',
  orange   = '#ff9e64',
  magenta  = '#bb9af7',
  blue     = '#7aa2f7',
  red      = '#f7768e'
}

local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = {c = {fg = colors.fg, bg = colors.bg}},
      inactive = {c = {fg = colors.fg, bg = colors.bg}}
    }
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {}
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_v = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {}
  },
  extensions = { 'fugitive', 'nvim-tree', 'quickfix' }
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  -- mode component
  function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.magenta,
      Rv = colors.magenta,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red
    }
    vim.api.nvim_command(
        'hi! LualineMode guifg=' .. mode_color[vim.fn.mode()] .. " guibg=" ..
            colors.bg)
    return ''
  end,
  color = "LualineMode"
}

ins_left {
  -- filesize component
  function()
    local function format_file_size(file)
      local size = vim.fn.getfsize(file)
      if size <= 0 then return '' end
      local sufixes = {'b', 'k', 'M', 'G'}
      local i = 1
      while size > 1024 do
        size = size / 1024
        i = i + 1
      end
      return string.format('%.1f%s', size, sufixes[i])
    end
    local file = vim.fn.expand('%:p')
    if string.len(file) == 0 then return '' end
    return format_file_size(file)
  end,
  condition = conditions.buffer_not_empty
}

ins_left {
  function()
    local function file_icon(filename, extension)
      local ok,devicons = pcall(require,'nvim-web-devicons')
      if not ok then print('No icon plugin found. Please install \'kyazdani42/nvim-web-devicons\'') return '' end
      icon = devicons.get_icon(filename, extension)
      return icon
    end
    return file_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e'))
  end,
  condition = conditions.buffer_not_empty,
  color = {fg = colors.magenta, gui = 'bold'},
  right_padding = 0
}

ins_left {
  function()
    if vim.b.term_title then
      return vim.b.term_title
    else
      local filename = vim.fn.expand('%:t')
      if vim.fn.empty(filename) == 1 then return '' end

      local readonly = ''

      if vim.bo.filetype == 'help' then
        readonly = ''
      elseif vim.bo.readonly == true then
        readonly = ' ' .. icon
      else
        readonly = ''
      end

      if string.len(readonly) ~= 0 then
        return filename .. readonly
      end

      if vim.bo.modifiable then
        if vim.bo.modified then
          return filename .. ' ' .. ''
        end
      end
      return filename

    end
  end,
  condition = conditions.buffer_not_empty,
  color = {fg = colors.magenta, gui = 'bold'},
}

ins_left {'location'}

ins_left {'progress', color = {fg = colors.fg, gui = 'bold'}}

ins_left {
  'diagnostics',
  sources = {'nvim_lsp'},
  symbols = {error = ' ', warn = ' ', info = ' '},
  color_error = colors.red,
  color_warn = colors.yellow,
  color_info = colors.cyan
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {function() return '%=' end}

ins_left {
  -- Lsp server name .
  function()
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then return "" end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return ""
  end,
  icon = ' ',
  color = {fg = colors.yellow, gui = 'bold'}
}

-- Add components to right sections
ins_right {
  'o:encoding', -- option component same as &encoding in viml
  upper = true, -- I'm not sure why it's upper case either ;)
  condition = conditions.hide_in_width,
  color = {fg = colors.green, gui = 'bold'}
}

ins_right {
  'fileformat',
  upper = true,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = {fg = colors.green, gui = 'bold'}
}

ins_right {
  'branch',
  icon = '',
  condition = conditions.check_git_workspace,
  color = {fg = colors.magenta, gui = 'bold'}
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = {added = ' ', modified = '柳 ', removed = ' '},
  color_added = colors.green,
  color_modified = colors.orange,
  color_removed = colors.red,
  condition = conditions.hide_in_width
}

-- Now don't forget to initialize lualine
lualine.setup(config)