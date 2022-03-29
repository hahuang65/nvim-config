local ls = require"luasnip"
local f = ls.function_node
local s = ls.s

return { -- Available in all filetypes
  s("curtime",
    f(function()
      return os.date "%H:%M:%S"
    end)
  ),

  s("curdate",
    f(function()
      return os.date "%D"
    end)
  )
}
