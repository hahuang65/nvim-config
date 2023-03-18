-- https://www.reddit.com/r/neovim/comments/10fpqbp/gist_statuscolumn_separate_diagnostics_and/

local gitsigns_config = {
  GitSignsAdd = { name = "add", icon = "│", hl = "GitSignsAdd" },
  GitSignsChange = { name = "change", icon = "│", hl = "GitSignsChange" },
  GitSignsChangedelete = { name = "changedelete", icon = "~", hl = "GitSignsChange" },
  GitSignsDelete = { name = "delete", icon = "_", hl = "GitSignsDelete" },
  GitSignsTopdelete = { name = "topdelete", icon = "‾", hl = "GitSignsDelete" },
  GitSignsUntracked = { name = "untracked", icon = "┆", hl = "GitSignsAdd" },
}

-- Icons from https://microsoft.github.io/vscode-codicons/dist/codicon.html
-- Copy glyphs from https://raw.githubusercontent.com/microsoft/vscode-codicons/main/dist/codicon.csv

local diagnostic_icons = {
  DiagnosticSignError = " ",
  DiagnosticSignWarn = " ",
  DiagnosticSignHint = " ",
  DiagnosticSignInfo = " ",
  DiagnosticSignOk = " ",
}

local neotest_config = {
  neotest_passed = { icon = " ", hl = "NeotestPassed" },
  neotest_skipped = { icon = " ", hl = "NeotestSkipped" },
  neotest_failed = { icon = " ", hl = "NeotestFailed" },
  neotest_running = { icon = " ", hl = "NeotestRunning" },
}

local debugger_icons = {
  DapBreakpoint = " ",
  DapBreakpoingCondition = " ",
  DapBreakpointRejected = " ",
  DapLogPoint = " ",
  DapStopped = " ",
}

local function render_sign(hlgroup, sym)
  return table.concat({ "%#", hlgroup, "#", sym, "%*" })
end

local function placed_signs_for_group(bufnr, lnum, group)
  local signs = {}
  local placed = vim.fn.sign_getplaced(bufnr, {
    group = group,
    lnum = lnum,
  })

  for _, each in pairs(placed) do
    for _, sign in pairs(each["signs"]) do
      table.insert(signs, sign)
    end
  end
  return signs
end

local function filter_by_prefix(signs, prefix)
  local matches = {}
  for _, sign in pairs(signs) do
    if sign ~= nil and vim.startswith(sign["name"], prefix) then
      table.insert(matches, sign)
    end
  end

  return matches
end

local function debug_line()
  local bufnr = vim.api.nvim_get_current_buf()
  local _, lnum, _, _ = unpack(vim.fn.getpos("."))
  local debugger_signs = filter_by_prefix(placed_signs_for_group(bufnr, lnum, "*"), "Dap")
  print("Debugger Signs")
  print(vim.inspect(debugger_signs))

  local diagnostic_signs = filter_by_prefix(placed_signs_for_group(bufnr, lnum, "*"), "DiagnosticSign")
  print("Diagnostic Signs")
  print(vim.inspect(diagnostic_signs))

  local neotest_signs = placed_signs_for_group(bufnr, lnum, "neotest-status")
  print("Neotest Signs")
  print(vim.inspect(neotest_signs))

  local gitsign_signs = placed_signs_for_group(bufnr, lnum, "gitsigns_vimfn_signs_")
  print("Gitsign Signs")
  print(vim.inspect(gitsign_signs))
end

_G.statuscolumn_gitsigns = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return " "
  end

  local gitsign = placed_signs_for_group(bufnr, lnum, "gitsigns_vimfn_signs_")[1]
  if gitsign ~= nil then
    return render_sign(gitsign["name"], gitsigns_config[gitsign["name"]]["icon"])
  else
    return " "
  end
end

_G.statuscolumn_diagnostics = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return ""
  end

  local diag_sign = filter_by_prefix(placed_signs_for_group(bufnr, lnum, "*"), "DiagnosticSign")[1]
  if diag_sign ~= nil then
    local sign_name = diag_sign["name"]
    return render_sign(sign_name, diagnostic_icons[sign_name])
  else
    return ""
  end
end

_G.statuscolumn_neotest = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return ""
  end

  local neotest_sign = placed_signs_for_group(bufnr, lnum, "neotest-status")[1]
  if neotest_sign ~= nil then
    local sign_name = neotest_sign["name"]
    return render_sign(neotest_config[sign_name]["hl"], neotest_config[sign_name]["icon"])
  else
    return ""
  end
end

_G.statuscolumn_debugger = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return " "
  end

  local debugger_sign = filter_by_prefix(placed_signs_for_group(bufnr, lnum, "*"), "Dap")[1]
  if debugger_sign ~= nil then
    local sign_name = debugger_sign["name"]
    return render_sign(sign_name, debugger_icons[sign_name])
  else
    return ""
  end
end

local statuscolumn_parts = {
  -- No spaces in the expression
  ["debugger"] = "%{%v:lua.statuscolumn_debugger(bufnr(),v:lnum,v:virtnum)%}",
  ["diagnostics"] = "%{%v:lua.statuscolumn_diagnostics(bufnr(),v:lnum,v:virtnum)%}",
  ["fold"] = "%C",
  ["gitsigns"] = "%{%v:lua.statuscolumn_gitsigns(bufnr(),v:lnum,v:virtnum)%}",
  ["neotest"] = "%{%v:lua.statuscolumn_neotest(bufnr(),v:lnum,v:virtnum)%}",
  ["num"] = '%{v:virtnum<0?"":v:relnum?v:relnum:v:lnum}',
  ["absnum"] = '%{v:virtnum<0?"":v:lnum}',
  ["sep"] = "%=",
  ["signcol"] = "%s",
  ["space"] = " ",
}

_G.statuscolumn = function()
  local str_table = {}

  local order = {
    "diagnostics",
    "neotest",
    "debugger",
    "sep",
    "num",
    "space",
    "gitsigns",
    "fold",
  }

  for _, val in ipairs(order) do
    table.insert(str_table, statuscolumn_parts[val])
  end

  return table.concat(str_table)
end

_G.inactive_statuscolumn = function()
  local str_table = {}

  local order = {
    "diagnostics",
    "neotest",
    "debugger",
    "sep",
    "absnum",
    "space",
    "gitsigns",
    "fold",
  }

  for _, val in ipairs(order) do
    table.insert(str_table, statuscolumn_parts[val])
  end

  return table.concat(str_table)
end

return {
  debugger_icons = debugger_icons,
  diagnostic_icons = diagnostic_icons,
  gitsigns_config = gitsigns_config,
  debug_line = debug_line,
}
