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

for name, opts in pairs(signs) do
  vim.fn.sign_define(
    name,
    { text = opts.icon, texthl = opt(name, "texthl") or name, linehl = opt(name, "linehl"), numhl = opt(name, "numhl") }
  )
end

return {
  signs = signs,
  border = border,
  opt = opt,
}
