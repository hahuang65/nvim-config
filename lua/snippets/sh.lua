local ls = require'luasnip'
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.s
local sn = ls.snippet_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local function endif()
  -- This function provides choices to end an `if` clause.
  -- It can simply end the `if` clause as-is,
  -- end it with an `else`,
  -- or end it with an `elif`.
  -- It is recursive in that, if `elif` is chosen,
  -- it can continue to provide ending clause choices.
  return sn(nil, {
    c(1, {
      t("fi"),
      sn(nil, {
        t("else"),
        t({"", "\t"}),
        i(1),
        t({"", "fi"})
      }),
      sn(nil, {
        t("elif "),
        i(1),
        t({"; then", "\t"}),
        i(2),
        t({"", ""}),
        d(3, endif, {})
      })
    })
  })
end

return {
  s("if",
    fmt(
      [[
        if {}; then
          {}
        {}
      ]],
      {
        i(1),
        i(2),
        d(3, endif, {})
      }
    )
  ),
}, {
  s("#!", t("#!/usr/bin/env bash"))
}
