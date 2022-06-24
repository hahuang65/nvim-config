local ls = require"luasnip"
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.s
local sn = ls.snippet_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmta

local function split_path(path)
  local parts = vim.split(path, "[./]", false)
  return parts[#parts] or ""
end

local function endif()
  -- This function represents a snippet choice for
  -- 1) `end`ing
  -- 2) `else...end`ing
  -- 3) `elseif...then...end`ing
  -- an `if statement. If using the `elseif`, the `end` can recursively call itself
  -- such that another `elseif...then...end` or `else...end` can be used.
  return sn(nil, {
    c(1, {
      t("end"),
      sn(nil, fmt(
        [[
          else
            <>
          end
        ]],
        {
          i(1)
        }
      )),
      sn(nil, fmt(
        [[
          elseif <1> then
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
  s("req",
    fmt([[local <> = require('<>')]], { f(function(import_name)
      return split_path(import_name[1][1])
    end, { 1 }), i(1) })
  ),

  s("func",
    fmt(
      [[
      <1> <2>(<3>)
        <4>
      end
      ]],
      {
        c(1, {
          t("function"),
          t("local function")
        }),
        i(2, "name"),
        i(3),
        i(4)
      }
    )
  ),

  s("if",
    fmt(
      [[
        if <1> then
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

  s("use",
    fmt(
      [[use <>]],
      {
        c(1, {
          sn(1, fmt(
            [[
              { '<>' }
            ]],
            {
              i(1)
            }
          )),
          sn(1, fmt(
            [[
              { '<>',
                config = function() require'plugin/<>' end
              }
            ]],
            {
              i(1),
              f(function(name)
                return split_path(name[1][1])
              end, { 1 }),
            }
          ))
        })
      }
    )
  )
}
