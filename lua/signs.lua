-- Icons from https://microsoft.github.io/vscode-codicons/dist/codicon.html
-- Copy glyphs from https://raw.githubusercontent.com/microsoft/vscode-codicons/main/dist/codicon.csv
-- https://github.com/catppuccin/nvim#special-integrations

local gitsign_bar = "▍" -- "│"

local signs = {
  DapBreakpoint = { icon = " " },
  DapBreakpointCondition = { icon = " " },
  DapBreakpointRejected = { icon = " " },
  DapLogPoint = { icon = " " },
  DapStopped = { icon = " " },
  DiagnosticSignError = { icon = " " },
  DiagnosticSignHint = { icon = " " },
  DiagnosticSignInfo = { icon = " " },
  DiagnosticSignOk = { icon = " " },
  DiagnosticSignWarn = { icon = " " },
  GitSignsAdd = { icon = gitsign_bar },
  GitSignsChange = { icon = gitsign_bar },
  GitSignsChangedelete = { icon = "~", texthl = "GitSignsChange" },
  GitSignsDelete = { icon = "_", texthl = "GitSignsDelete" },
  GitSignsStagedAdd = { icon = gitsign_bar, texthl = "GitSignsAdd" },
  GitSignsStagedChange = { icon = gitsign_bar, texthl = "GitSignsChange" },
  GitSignsStagedDelete = { icon = "_", texthl = "GitSignsDelete" },
  GitSignsTopdelete = { icon = "‾", texthl = "GitSignsDelete" },
  GitSignsUntracked = { icon = "┆", texthl = "GitSignsAdd" },
  NeotestFailed = { icon = " " },
  NeotestPassed = { icon = " " },
  NeotestRunning = { icon = " " },
  NeotestSkipped = { icon = " " },
}

local border = {
  "╭",
  "─",
  "╮",
  "│",
  "╯",
  "─",
  "╰",
  "│",
}

local function opt(sign, property)
  local override = signs[sign][property]
  if override == nil or override == "" then
    return nil
  else
    return override
  end
end

local text_config = {}
local texthl_config = {}
local linehl_config = {}
local numhl_config = {}

for name, opts in pairs(signs) do
  local text = opts.icon
  local texthl = opt(name, "texthl") or name
  local linehl = opt(name, "linehl")
  local numhl = opt(name, "numhl")

  if vim.startswith(name, "DiagnosticSign") then
    -- Use vim.diagnostic.config if it's a DiagnosticSign
    -- Currently the deprecation won't chirp if there exists a key with `DiagnosticSign*` in vim.diagnostic.config.signs.text
    -- View with := vim.diagnostic.config()
    text_config[name] = text
    texthl_config[name] = texthl
    linehl_config[name] = linehl
    numhl_config[name] = numhl
  end

  vim.fn.sign_define(name, {
    text = text,
    texthl = texthl,
    linehl = linehl,
    numhl = numhl,
  })
end

vim.diagnostic.config({
  signs = { text = text_config, linehl = linehl_config, numhl = numhl_config, texthl = texthl_config },
})

return {
  signs = signs,
  border = border,
  opt = opt,
}
