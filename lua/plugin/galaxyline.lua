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
      local mt = {__index = function () return colors.blue end}
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
        setmetatable(mode_color, mt)
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
    provider = function()
      if vim.b.term_title then
        return vim.b.term_title .. ' '
      else
        return require('galaxyline.provider_fileinfo').get_current_file_name()
      end
    end,
    condition = condition.buffer_not_empty,
    highlight = {colors.magenta,colors.bg,'bold'}
  }
}

gls.left[6] = {
  LineInfo = {
    provider = function()
      local line = vim.fn.line('.')
      local column = vim.fn.col('.')
      return string.format("%d:%d ", line, column)
    end,
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}

gls.left[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green,colors.bg},
  }
}

gls.left[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange,colors.bg},
  }
}

gls.left[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red,colors.bg},
  }
}

gls.right[1] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg},
    separator = ' ',
    separator_highlight = {'NONE',colors.bg}
  }
}

gls.right[2] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow,colors.bg}
  }
}

gls.right[3] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.cyan,colors.bg}
  }
}

gls.right[4] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.bg}
  }
}

gls.right[5] = {
  EmptySpace = {
    provider = function()
      return " "
    end,
    highlight = {colors.fg,colors.bg}
  }
}

gls.right[6] = {
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

gls.right[7] = {
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

gls.right[8] = {
  FileEncode = {
    provider = 'FileEncode',
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

gls.right[9] = {
  FileFormat = {
    provider = 'FileFormat',
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

gls.right[10] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.violet,colors.bg,'bold'}
  }
}
 
gls.right[11] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {colors.violet,colors.bg,'bold'}
  }
}

gls.right[12] = {
  EmptySpace = {
    provider = function()
      return " "
    end,
    highlight = {colors.fg,colors.bg}
  }
}
