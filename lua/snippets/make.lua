local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.text_node

return {
      s("help", {
        t({
          "## help: print this help message",
          ".PHONY: help",
          "help:",
          "\t@echo 'Usage:'",
          "\t@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'",
          "",
          "",
        }),
      }),
    }, {
      s("phony", {
        t(".PHONY: "),
        i(0),
      }),
    }
