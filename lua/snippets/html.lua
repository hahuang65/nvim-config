local ls = require"luasnip"
local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("doctype",
    fmt(
      [[
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
            <title>{}</title>
          </head>
          <body>
            {}
          </body>
        </html>
      ]],
      {
        i(1),
        i(0)
      }
    )
  )
}
