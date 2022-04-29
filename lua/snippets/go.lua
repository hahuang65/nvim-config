local ls = require"luasnip"
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.s
local sn = ls.snippet_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function arglist()
  return sn(nil, {
    sn(1, {
      i(1, "arg"),
      t(" "),
      i(2, "type")
    }),
    c(2, {
      t(""),
      sn(1, {
        t(", "),
        d(1, arglist, {})
      })
    }),
  })
end

local function endif()
  -- This function provides choices to end an `if` clause.
  -- It can simply end the `if` clause as-is,
  -- end it with an `else`,
  -- or end it with an `else if`.
  -- It is recursive in that, if `else if` is chosen,
  -- it can continue to provide ending clause choices.
  return sn(nil, {
    c(1, {
      t("}"),
      sn(nil, {
        t("} else {"),
        t({"", "\t"}),
        i(1),
        t({"", "}"})
      }),
      sn(nil, {
        t("} else if "),
        i(1),
        t({" {", "\t"}),
        i(2),
        t({"", ""}),
        d(3, endif, {})
      })
    })
  })
end

return {
  s("err",
    fmt(
      [[
        if {} != nil {{
          {}
        }}
      ]],
      {
        i(1, "err"),
        i(0)
      }
    )
  ),

  s("for",
    fmt(
      [[
        for {}
      ]],
      {
        c(1, {
          sn(1, {
            i(1, "index"),
            c(2, {
              sn(1, {
                t(", "),
                i(1, "element"),
              }),
              t("")
            }),
            t(" := range "),
            i(3, "collection"),
            t({" {", "\t"}),
            i(4),
            t({"", "}"})
          }),
          sn(1, {
            i(1, "i"),
            t(" := "),
            i(2, "1"),
            t("; "),
            rep(1),
            c(3, {
              t(" < "),
              t(" <= "),
              t(" > "),
              t(" >= ")
            }),
            i(4, "j"),
            t("; "),
            rep(1),
            c(5, {
              t("++"),
              t("--"),
            }),
            t({" {", "\t"}),
            i(6),
            t({"", "}"})
          })
        })
      }
    )
  ),

  s("func",
    fmt(
      [[
        func {}({}){}{{
          {}
        }}

      ]],
      {
        c(1, {
          i(1, "name"),
          sn(1, {
            t("("),
            i(1, "t"),
            t(" "),
            i(2, "type"),
            t(") "),
            i(3, "name")
          })
        }),
        c(2, {
          d(1, arglist, {}),
          t("")
        }),
        c(3, {
          sn(1, {
            t(" "),
            i(1, "return_type"),
            t(" ")
          }),
          t(" ")
        }),
        i(0)
      }
    )
  ),

  s("if",
    fmt(
      [[
        if {} {{
          {}
        {}
      ]],
      {
        i(1),
        i(2),
        d(3, endif, {})
      }
    )
  )
}
