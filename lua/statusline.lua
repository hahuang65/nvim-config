local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local gls = gl.section
local lspclient = require('galaxyline.provider_lsp')

local dracula_colors = {
  bg = '#424450',
  fg = '#F8F8F2',
  yellow = '#F1FA8C',
  cyan = '#8BE9FD',
  green = '#50FA7B',
  orange = '#FFB86C',
  violet = '#BD93F9',
  magenta = '#FF79C6',
  blue = '8BE9FD', -- SAME AS CYAN
  red = '#FF5555'
}

local gruvbox_colors = {
  bg = '#504945',
  fg = '#EBDBB2',
  yellow = 'FABD2F',
  cyan = '#8EC07C',
  green = '#B8BB26',
  orange = '#D65D0E',
  violet = '#B16286',
  magenta = '#B16286', -- SAME AS VIOLET
  blue = '#458588',
  red = '#CC241D'
}

local colors = dracula_colors

gls.left[1] = {
  EmptySpace = {
    provider = function()
      return " "
    end,
    highlight = {colors.fg,colors.bg}
  }
}

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        n = colors.green,
        i = colors.red,
        v = colors.blue,
        [''] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.green,
        s = colors.orange,
        S = colors.orange,
        [''] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.magenta,
        ce = colors.magenta,
        r = colors.cyan,
        rm = colors.cyan,
        ['r?'] = colors.cyan,
        ['!']  = colors.red,
        t = colors.red}
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
      return '   '
    end,
    highlight = {colors.red,colors.bg,'bold'},
  },
}

gls.left[3] = {
  FileSize = {
    provider = 'FileSize',
    condition = condition.buffer_not_empty,
    highlight = {colors.fg,colors.bg}
  }
}

gls.left[4] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
  },
}

gls.left[5] = {
  FileName = {
    provider = 'FileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.magenta,colors.bg,'bold'}
  }
}

gls.left[6] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green,colors.bg},
  }
}

gls.left[7] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange,colors.bg},
  }
}

gls.left[8] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red,colors.bg},
  }
}

gls.left[9] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}

gls.mid[1] = {
  ShowTreeSitter = {
    provider = function()
      return vim.api.nvim_call_function('nvim_treesitter#statusline', {
        {
          indicator_size = 200,
          type_patterns = {'function', 'method'},
          separator = ' -> '
        }
      })
    end,
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.orange,colors.bg,'bold'}
  }
}

gls.right[1] = {
  FileEncode = {
    provider = 'FileEncode',
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

gls.right[2] = {
  FileFormat = {
    provider = 'FileFormat',
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

gls.right[3] = {
  LspIcon = {
    provider = function()
      local client_name = lspclient.get_lsp_client()
      if client_name == 'No Active Lsp' then
        return ' '
      end
      return ' '
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.yellow,colors.bg,'bold'}
  }
}

gls.right[4] = {
  LspServer = {
    provider = function()
      local client_name = lspclient.get_lsp_client()
      if client_name == 'No Active Lsp' then
        return 'Off'
      end
      return client_name
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.yellow,colors.bg,'bold'}
  }
}

gls.right[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.violet,colors.bg,'bold'},
  }
}
 
gls.right[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[7] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg}
  }
}

gls.right[8] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow,colors.bg},
  }
}

gls.right[9] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.cyan,colors.bg},
  }
}

gls.right[10] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.bg},
  }
}

gls.right[11] = {
  EmptySpace = {
    provider = function()
      return " "
    end,
    highlight = {colors.fg,colors.bg}
  }
}
