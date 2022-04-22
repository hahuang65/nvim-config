local ls = require'luasnip'
local s = ls.s
local t = ls.text_node

return {
}, {
  s("#!", t("#!/usr/bin/env bash"))
}
