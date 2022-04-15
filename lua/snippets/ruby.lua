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
          i(1, "name"),
          sn(1, {
            i(1, "name"),
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
  ),

  s("each",
    fmt(
      [[
        each{}
      ]],
      {
        c(1, {
          sn(1, {
            t("(&:"),
            i(1, "method"),
            t(")")
          }),
          sn(1, {
            t(" { "),
            i(1),
            t(" }")
          }),
          sn(1, {
            t(" { |"),
            i(1, "x"),
            t("| "),
            i(2),
            t(" }"),
          }),
          sn(1, {
            t(" do |"),
            i(1, "x"),
            t("|"),
            t({"", "\t"}),
            i(2),
            t({"", ""}),
            t("end")
          }),
        }),
      }
    )
  ),

  s("map",
    fmt(
      [[
        map{}
      ]],
      {
        c(1, {
          sn(1, {
            t("(&:"),
            i(1, "method"),
            t(")")
          }),
          sn(1, {
            t(" { "),
            i(1),
            t(" }")
          }),
          sn(1, {
            t(" { |"),
            i(1, "x"),
            t("| "),
            i(2),
            t(" }"),
          }),
          sn(1, {
            t(" do |"),
            i(1, "x"),
            t("|"),
            t({"", "\t"}),
            i(2),
            t({"", ""}),
            t("end")
          }),
        }),
      }
    )
  )
}, {
  s("#!", t("#!/usr/bin/env ruby"))
}
