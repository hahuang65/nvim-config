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
  "\t@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]",
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
  s("golang", {
    help,
    confirm,
    t({
      "## setup: bootstrap all dependencies for the project",
      ".PHONY: setup",
      "setup:",
      "\tgo install honnef.co/go/tools/cmd/staticcheck@latest",
      "\tgo install github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
      "\tgo install gotest.tools/gotestsum@latest",
      "",
      "## audit: tidy dependencies and format, vet, and test all code",
      ".PHONY: audit",
      "audit: format lint test",
      "",
      "## format: format codebase using `go fmt`",
      ".PHONY: format",
      "format:",
      "\t@echo 'Formatting code...'",
      "\tgo fmt ./...",
      "",
      "## lint: lint and vet codebase using `go vet`, `staticcheck` and `golangci-lint`",
      ".PHONY: lint",
      "lint:",
      "\t@echo 'Linting and vetting code...'",
      "\tgo vet ./...",
      "\tstaticcheck ./...",
      "\tgolangci-lint run",
      "",
      "## test: test codebase using `gotestsum`",
      ".PHONY: test",
      "test: deps",
      "\t@echo 'Running tests...'",
      "\tgo clean -testcache",
      "\tgotestsum --format dots-v2 -- -race -vet=off ./...",
      "",
      "## deps: sync dependencies using `go mod tidy` and `go mod verify`",
      ".PHONY: deps",
      "deps:",
      "\t@echo 'Tidying and verifying module dependencies...'",
      "\tgo mod tidy",
      "\tgo mod verify",
    }),
  }),
}, {
  s("phony", {
    t(".PHONY: "),
    i(0),
  }),
}
