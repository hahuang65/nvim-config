local ls = require"luasnip"
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.s
local sn = ls.snippet_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmta

local function arglist()
  -- This function provides an infinite argument list
  -- it supplies a `arg type` which has a choice_node at the end.
  -- The choice defaults to blank, but change be selected to add
  -- another `arg type` after the previous one.
  -- This can be done infinitely.
  return sn(nil, fmt(
    [[
      <1><2>
    ]],
    {
      i(1, "arg type"),
      c(2, {
        t(""),
        sn(1, fmt(
          [[
            , <1>
          ]],
          {
            d(1, arglist, {})
          }
        ))
      })
    }
  ))
end

local function subtest(pos)
  -- FIXME This function has wrong indentation when used in the `test` snippet
  -- which is why line <2> on is indented 1 extra layer
  -- This function provides an infinite list of subtests
  -- Similar to arglist(), it provides a subtest, then optionally
  -- provides another one after.
  return sn(pos, fmt(
    [[
      t.Run("<1>", func(t *testing.T) {
          <2>
        <3>
    ]],
    {
      i(1, "TestName"),
      i(2),
      c(3, {
        t("})"),
        sn(1, fmt(
          [[
            })

            <1>
          ]],
          {
            d(1, subtest, {})
          }
        ))
      })
    }
  ))
end

local function testtable()
  -- FIXME This function has wrong indentation when used in the `test` snippet
  -- which is why all lines after `name string` is indented extra
  return sn(nil, fmt(
    [[
      cases := []struct {
        name string
          <1>
        }{
          {"<2>", <3>},
        }

        for _, c := range cases {
          t.Run(c.name, func(t *testing.T) {
            <4>
          })
        }
    ]],
    {
      i(1, "arg type"),
      i(2, "TestCaseName"),
      i(3),
      i(4)
    })
  )
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
      sn(nil, fmt(
        [[
          } else {
            <1>
          }
        ]],
        {
          i(1)
        }
      )),
      sn(nil, fmt(
        [[
          } else if <1> {
            <2>
          <3>
        ]],
        {
          i(1),
          i(2),
          d(3, endif, {})
        }
      ))
    })
  })
end

return {
  s("err",
    fmt(
      [[
        if <1> != nil {
          <2>
        }
      ]],
      {
        i(1, "err"),
        i(2)
      }
    )
  ),

  s("for",
    fmt(
      [[
        for <1> {
          <2>
        }
      ]],
      {
        c(1, {
          sn(1, fmt(
            [[
              <1>, <2> := range <3>
            ]],
            {
              i(1, "index"),
              i(2, "element"),
              i(3, "collection"),
            }
          )),
          sn(1, fmt(
            [[
              _, <1> := range <2>
            ]],
            {
              i(1, "element"),
              i(2, "collection")
            }
          )),
          sn(1, fmt(
            [[
              <1> := range <2>
            ]],
            {
              i(1, "index"),
              i(2, "collection")
            }
          ))
        }),
        i(2)
      }
    )
  ),

  s("func",
    fmt(
      [[
        func <1>(<2>)<3> {
          <4>
        }

      ]],
      {
        c(1, {
          i(1, "name"),
          sn(1, fmt(--{
            [[
              (<1> <2>) <3>
            ]],
            {
              i(1, "t"),
              i(2, "type"),
              i(3, "name")
            })
          )
        }),
        c(2, {
          d(1, arglist, {}),
          t("")
        }),
        c(3, {
          sn(1, {
            t(" "),
            i(1, "returnType"),
          }),
          t("")
        }),
        i(0)
      }
    )
  ),

  s("if",
    fmt(
      [[
        if <1> {
          <2>
        <3>
      ]],
      {
        i(1),
        i(2),
        d(3, endif, {})
      }
    )
  ),

  s("main",
    fmt(
      [[
        func main() {
          w := <1>
          if err := run(os.Args, w); err != nil {
            fmt.Fprintf(w, "%s\n", err)
            os.Exit(1)
          }
        }

        func run(args []string, w io.Writer) error {
          <2>
        }
      ]],
      {
        i(1, "os.Stdout"),
        i(2)
      }
    )
  ),

  s("teaCmd",
    fmt(
      [[
        func <1>
      ]],
      {
        c(1, {
          sn(1, fmt(
            [[
              <1>() tea.Msg {
                <2>
              }
            ]],
            {
              i(1, "name"),
              i(2),
            }
          )),
          sn(1, fmt(
            [[
              <1>(<2>) tea.Msg {
                return func() tea.Msg {
                  <3>
                }
              }
            ]],
            {
              i(1, "name"),
              d(2, arglist, {}),
              i(3),
            }
          ))
        })
      }
    )
  ),

  s("test",
    fmt(
      [[
        func Test<1>(t *testing.T) {
          <2>
        }
      ]],
      {
        i(1, "Name"),
        c(2, {
          subtest(1),
          i(""),
          d(1, testtable, {})
        })
      }
    )
  )
}
