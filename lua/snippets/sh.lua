local ls = require("luasnip")
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
      sn(
        nil,
        fmt(
          [[
          else
            {1}
          fi
        ]],
          {
            i(1),
          }
        )
      ),
      sn(
        nil,
        fmt(
          [[
          elif {1}; then
            {2}
          {3}
        ]],
          {
            i(1),
            i(2),
            d(3, endif, {}),
          }
        )
      ),
    }),
  })
end

return {
  s(
    "if",
    fmt(
      [[
        if {1}; then
          {2}
        {3}
      ]],
      {
        i(1),
        i(2),
        d(3, endif, {}),
      }
    )
  ),

  s(
    "mapfile",
    fmt([[mapfile -t {1} < <({2})]], {
      i(1, "variable"),
      i(2, "command"),
    })
  ),
}, {
  s("#!", t("#!/usr/bin/env bash")),
}
