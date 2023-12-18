local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.text_node

local help = t({
  "## help: print this help message",
  ".PHONY: help",
  "help:",
  "\t@echo 'Usage:'",
  "\t@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'",
  "",
  "",
})

local confirm = t({
  ".PHONY: confirm",
  "confirm:",
  "\t@echo 'Are you sure? [y/N] \\c' && read ans && [ $${ans:-N} = y ]",
  "",
  "",
})

local dirty = t({
  ".PHONY: check_dirty",
  "check_dirty:",
  "\t	@git diff --quiet || $(error ERROR: Git workspace is dirty)",
  "",
  "",
})

return {
  s("help", {
    help,
  }),
  s("confirm", {
    confirm,
  }),
  s("dirty", {
    dirty,
  }),
}, {
  s("phony", {
    t(".PHONY: "),
    i(0),
  }),
}
