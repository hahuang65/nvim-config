-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:hahuang65/mason-registry",
      },
    })

    local language_servers = vim.tbl_flatten(vim.tbl_values(require("tools").language_servers))
    for i, ls in ipairs(language_servers) do
      for k, v in pairs(require("tools").renames) do
        if ls == k then
          language_servers[i] = v
        end
      end
    end
    require("mason-lspconfig").setup({
      ensure_installed = language_servers,
    })

    local tools = {}
    local formatters = vim.tbl_flatten(vim.tbl_values(require("tools").formatters))
    local linters = vim.tbl_flatten(vim.tbl_values(require("tools").linters))
    local debuggers = require("tools").debuggers
    vim.list_extend(tools, formatters)
    vim.list_extend(tools, linters)
    vim.list_extend(tools, debuggers)
    table.sort(tools)
    tools = vim.fn.uniq(tools)
    tools = vim.tbl_filter(function(tool)
      return not vim.tbl_contains(require("tools").install_blacklist, tool)
    end, tools)

    for i, tool in ipairs(tools) do
      for k, v in pairs(require("tools").renames) do
        if tool == k then
          tools[i] = v
        end
      end
    end

    require("mason-tool-installer").setup({
      ensure_installed = tools,
    })
  end,
}
