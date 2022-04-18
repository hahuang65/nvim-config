local ls = require"luasnip"
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.s
local sn = ls.snippet_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

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
      sn(nil, {
        t("else"),
        t({"", "\t"}),
        i(1),
        t({"", "end"})
      }),
      sn(nil, {
        t("elseif "),
        i(1),
        t({" then", "\t"}),
        i(2),
        t({"", ""}),
        d(3, endif, {})
      })
    })
  })
end

return {
  s("req",
    fmt([[local {} = require('{}')]], { f(function(import_name)
      return split_path(import_name[1][1])
    end, { 1 }), i(1) })
  ),

  s("func",
    fmt(
      [[
      {} {}({})
        {}
      end
      ]],
      {
        c(1, {
          t("function"),
          t("local function")
        }),
        i(2, "name"),
        i(3),
        i(0)
      }
    )
  ),

  s("if",
    fmt(
      [[
        if {} then
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

  s("use",
    fmt(
      [[use {{{}}}]],
      {
        c(1, {
          sn(1, {
            t(" '"),
            i(1),
            t("' ")
          }),
          sn(1, {
            t(" '"),
            i(1),
            t({"',", "\tconfig = function() require'plugin/"}),
            f(function(name)
              return split_path(name[1][1])
            end, { 1 }),
            t({"' end", ""})
          })
        })
      }
    )
  )
}
