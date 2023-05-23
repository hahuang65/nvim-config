-- https://github.com/DNLHC/glance.nvim

return {
  "dnlhc/glance.nvim",
  keys = {
    {
      "gd",
      "<CMD>Glance definitions<CR>",
      desc = "[G]lance at [D]efinition",
    },
    {
      "gr",
      "<CMD>Glance references<CR>",
      desc = "[G]lance at [R]eferences",
    },
    {
      "gy",
      "<CMD>Glance type_definitions<CR>",
      desc = "[G]lance at t[Y]pe definitions",
    },
    {
      "gi",
      "<CMD>Glance implementations<CR>",
      desc = "[G]lance at i[M]plementations",
    },
  },
  config = function()
    local glance = require("glance")
    local actions = glance.actions

    glance.setup({
      mappings = {
        list = {
          ["j"] = actions.next,
          ["k"] = actions.previous,
          ["<Down>"] = false,
          ["<Up>"] = false,
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
          ["<C-u>"] = actions.preview_scroll_win(5),
          ["<C-d>"] = actions.preview_scroll_win(-5),
          ["<C-v>"] = actions.jump_vsplit,
          ["<C-x>"] = actions.jump_split,
          ["t"] = false,
          ["o"] = actions.jump,
          ["<CR>"] = actions.enter_win("preview"), -- Focus preview window
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<C-q>"] = actions.quickfix,
        },
      },
    })
  end,
}
