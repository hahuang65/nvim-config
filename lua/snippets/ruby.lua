local ls = require'luasnip'
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.s
local sn = ls.snippet_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local function arglist()
  return sn(nil, fmt(
    [[
      {1}{2}
    ]],
    {
      i(1, "arg"),
      c(2, {
        t(""),
        sn(1, fmt(
          [[
            , {}
          ]],
          {
            d(1, arglist, {})
          }
        ))
      })
    }
  ))
end

local function do_or_brackets(position)
  return c(position, {
    sn(1, fmt(
      [[
        {{ {} }}
      ]],
      {
        i(1)
      }
    )),
    sn(1, fmt(
      [[
        do
          {}
        end
      ]],
      {
        i(1)
      }
    ))
  })
end


local function block_choice()
  return c(1, {
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
  })
end

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
          sn(1, fmt(
            [[
              {1}({2})
            ]],
            {
              i(1, "name"),
              d(2, arglist, {}),
            }
          ))
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
          sn(1, fmt(
            [[
              |{}|
            ]],
            {
              i(1, "x"),
            }
          )),
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
        block_choice()
      }
    )
  ),

  s("filter",
    fmt(
      [[
        filter{}
      ]],
      {
        block_choice()
      }
    )
  ),

  s("it",
    fmt(
      [[
        it "{1}" do
          {2}
        end
      ]],
      {
        i(1, "describe the test"),
        i(2)
      }
    )
  ),

  s("let",
    fmt(
      [[
        {1}(:{2}) {3}
      ]],
      {
        c(1, {t("let"), t("let!")}),
        i(2, "name"),
        do_or_brackets(3)
      }
    )
  ),

  s("map",
    fmt(
      [[
        map{}
      ]],
      {
        block_choice()
      }
    )
  ),

  s("sort_by",
    fmt(
      [[
        sort_by{}
      ]],
      {
        block_choice()
      }
    )
  ),
}, {
  s("#!", t("#!/usr/bin/env ruby"))
}
