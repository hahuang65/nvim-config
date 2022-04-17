-- https://github.com/sumneko/lua-language-server
-- Install with `./install_sumneko_lua.sh`
sumneko_root_path = vim.fn.stdpath('cache')..'/lua-language-server'
sumneko_binary = sumneko_root_path.."/bin/lua-language-server"

local common = require('plugin/lsp/common')

local function sumneko_exists()
  local f = io.open(sumneko_binary, "r")
  if f ~= nil then io.close(f) return true else return false end
end

if sumneko_exists() == false then
  print("Sumneko not installed, please install using install_sumneko_lua.sh.")
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  on_attach = common.on_attach,
  capabilities = common.capabilities,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      }
    }
  }
}
