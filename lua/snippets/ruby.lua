local ls = require'luasnip'
local c = ls.choice_node
local i = ls.insert_node
local s = ls.s
local sn = ls.snippet_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("def",
    fmt(
      [[
        def {}
          {}
        end
      ]],
      {
        c(1, {
          i(1, "method_name"),
          sn(1, {
            i(1, "method_name"),
            t("("),
            i(2, "args"),
            t(")")
          })
        }),
        i(0)
      }
    )
  ),

  s("do",
    fmt(
      [[
        do {}
          {}
        end
      ]],
      {
        c(1, {
          sn(1, {
            t("|"),
            i(1, "x"),
            t("|")
          }),
          t("")
        }),
        i(0)
      }
    )
  )
}
