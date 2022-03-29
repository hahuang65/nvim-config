local ls = require"luasnip"
local f = ls.function_node
local i = ls.insert_node
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("req",
    fmt([[local {} = require('{}')]], { f(function(import_name)
      local parts = vim.split(import_name[1][1], ".", true)
      return parts[#parts] or ""
    end, { 1 }), i(1) })
  )
}
