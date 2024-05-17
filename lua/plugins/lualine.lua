-- https://github.com/hoob3rt/lualine.nvim
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local util = require("util")
    local C = require("catppuccin.palettes").get_palette()

    -- Catppuccin
    local colors = {
      bg = C.mantle,
      fg = C.text,
      yellow = C.yellow,
      cyan = C.sapphire,
      darkblue = C.lavender,
      green = C.green,
      orange = C.peach,
      magenta = C.mauve,
      blue = C.blue,
      red = C.red,
      inactive = C.surface1,
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Config
    local config = {
      options = {
        globalstatus = true, -- Enable laststatus=3
        -- Disable sections and component separators
        component_separators = "",
        section_separators = "",
        theme = {
          -- We are going to use lualine_c an lualine_x as left and
          -- right section. Both are highlighted by c theme .  So we
          -- are just setting default looks o statusline
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "fugitive", "lazy", "nvim-dap-ui" },
    }

    local function deep_copy(original)
      local copy = {}
      for k, v in pairs(original) do
        if type(v) == "table" then
          v = deep_copy(v)
        end
        copy[k] = v
      end
      return copy
    end

    local function with_inactive_colors(component)
      component = deep_copy(component)

      if component["color"] and component["color"]["fg"] then
        component["color"]["fg"] = colors.inactive
      end

      local icons = {
        "color_error",
        "color_warn",
        "color_info",
        "color_added",
        "color_modified",
        "color_removed",
      }

      -- This doesn't quite work. You can see the colors set correctly, but I'm guessing that the load order of the code overwrites it at runtime?
      for _, icon in ipairs(icons) do
        if component[icon] then
          component[icon] = colors.inactive
        end
      end

      return component
    end

    local function insert_component(component, position)
      table.insert(position, component)
    end

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
      insert_component(component, config.sections.lualine_c)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
      insert_component(component, config.sections.lualine_x)
    end

    -- Inserts a component in lualine_c at left section, including for inactive buffers
    local function ins_left_with_inactive(component)
      ins_left(component)
      insert_component(with_inactive_colors(component), config.inactive_sections.lualine_c)
    end

    -- Inserts a component in lualine_x at right section, including for inactive buffers
    local function ins_right_with_inactive(component)
      ins_right(component)
      insert_component(with_inactive_colors(component), config.inactive_sections.lualine_x)
    end

    ins_left({
      -- mode component
      function()
        -- auto change color according to neovims mode
        local mode_color = {
          n = colors.red,
          i = colors.green,
          v = colors.blue,
          [""] = colors.blue,
          V = colors.blue,
          c = colors.magenta,
          no = colors.red,
          s = colors.orange,
          S = colors.orange,
          [""] = colors.orange,
          ic = colors.yellow,
          R = colors.magenta,
          Rv = colors.magenta,
          cv = colors.red,
          ce = colors.red,
          r = colors.cyan,
          rm = colors.cyan,
          ["r?"] = colors.cyan,
          ["!"] = colors.red,
          t = colors.red,
        }
        vim.api.nvim_command("hi! LualineMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
        return ""
      end,
      color = "LualineMode",
    })

    ins_left({
      -- filesize component
      function()
        local function format_file_size(file)
          local size = vim.fn.getfsize(file)
          if size <= 0 then
            return ""
          end
          local sufixes = { "b", "k", "M", "G" }
          local i = 1
          while size > 1024 do
            size = size / 1024
            i = i + 1
          end
          return string.format("%.1f%s", size, sufixes[i])
        end

        local file = vim.fn.expand("%:p")
        if string.len(file) == 0 then
          return ""
        end
        return format_file_size(file)
      end,
      condition = conditions.buffer_not_empty,
    })

    ins_left_with_inactive({
      function()
        local filename = vim.fn.expand("%:t")
        local extension = vim.fn.expand("%:e")
        return util.filetype_icon(filename, extension)
      end,
      condition = conditions.buffer_not_empty,
      color = { fg = colors.magenta, gui = "bold" },
      right_padding = 0,
    })

    ins_left_with_inactive({
      function()
        return util.filename()
      end,
      condition = conditions.buffer_not_empty,
      color = { fg = colors.magenta, gui = "bold" },
    })

    ins_left({ "location" })

    ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

    ins_left_with_inactive({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " " },
      color_error = colors.red,
      color_warn = colors.yellow,
      color_info = colors.cyan,
    })

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left({
      function()
        return "%="
      end,
    })

    ins_left({
      -- Lsp server name .
      function()
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return ""
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        return ""
      end,
      icon = " ",
      color = { fg = colors.yellow, gui = "bold" },
    })

    -- Add components to right sections
    ins_right({
      "o:encoding", -- option component same as &encoding in viml
      upper = true,
      condition = conditions.hide_in_width,
      color = { fg = colors.green, gui = "bold" },
    })

    ins_right({
      "fileformat",
      upper = true,
      icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
      color = { fg = colors.green, gui = "bold" },
    })

    ins_right({
      "branch",
      icon = "",
      condition = conditions.check_git_workspace,
      color = { fg = colors.magenta, gui = "bold" },
    })

    ins_right_with_inactive({
      "diff",
      symbols = { added = " ", modified = "柳 ", removed = " " },
      color_added = colors.green,
      color_modified = colors.orange,
      color_removed = colors.red,
      condition = conditions.hide_in_width,
    })

    -- Now don't forget to initialize lualine
    lualine.setup(config)
  end,
}
