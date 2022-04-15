local ls = require'luasnip'
local i = ls.insert_node
local s = ls.s
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("def",
    fmt(
      [[
        def {}({}):
            {}


      ]],
      {
        i(1, "name"),
        i(2),
        i(0)
      }
    )
  ),

  s("fixture",
    fmt(
      [[
        @pytest.fixture
        def {}({}):
            {}


      ]],
      {
        i(1, "name"),
        i(2),
        i(0)
      }
    )
  ),

  s("for",
    fmt(
      [[
        for {} in {}:
            {}

      ]],
      {
        i(1, "name"),
        i(2, "collection"),
        i(0)
      }
    )
  ),

  s("test",
    fmt(
      [[
        def test_{}({}):
            {}


      ]],
      {
        i(1, "name"),
        i(2),
        i(0)
      }
    )
  ),

  s("with",
    fmt(
      [[
        with {} as {}:
            {}

      ]],
      {
        i(1, "thing"),
        i(2, "name"),
        i(0)
      }
    )
  ),
}, {
  s("#!", t("#!/usr/bin/env python3"))
}
