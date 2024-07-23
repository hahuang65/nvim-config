-- https://www.reddit.com/r/neovim/comments/10fpqbp/gist_statuscolumn_separate_diagnostics_and/

local signs = require("signs").signs

local function render_sign(name)
  local sign = vim.fn.sign_getdefined(name)[1]
  if sign ~= nil then
    return table.concat({ "%#", sign.texthl, "#", sign.text, "%*" })
  end
end

local function extmarks_for_prefix(bufnr, lnum, namespace_prefix)
  local ns_ids = {}
  local namespaces = vim.api.nvim_get_namespaces()

  for k, v in pairs(namespaces) do
    if vim.startswith(k, namespace_prefix) then
      table.insert(ns_ids, v)
    end
  end

  local extmarks = {}

  for _, ns_id in pairs(ns_ids) do
    local line_extmarks = vim.api.nvim_buf_get_extmarks(
      bufnr,
      ns_id,
      { lnum - 1, 0 },
      { lnum - 1, -1 },
      { details = true }
    )
    for _, extmark in pairs(line_extmarks) do
      local details = extmark[4]
      table.insert(extmarks, details["sign_hl_group"])
    end
  end

  return extmarks
end

local function placed_signs_for_group(bufnr, lnum, group)
  local ret = {}
  local placed = vim.fn.sign_getplaced(bufnr, {
    group = group,
    lnum = lnum,
  })

  for _, each in pairs(placed) do
    for _, sign in pairs(each["signs"]) do
      table.insert(ret, sign)
    end
  end

  return ret
end

local function filter_by_prefix(tbl, prefix)
  local matches = {}
  for _, sign in pairs(tbl) do
    if sign ~= nil and vim.startswith(sign["name"], prefix) then
      table.insert(matches, sign)
    end
  end

  return matches
end

local function diagnostics_for_line(bufnr, lnum)
  local diagnostic_signs = vim.diagnostic.get(bufnr, { lnum = lnum - 1 })
  table.sort(diagnostic_signs, function(a, b)
    return a.severity < b.severity
  end)
  return diagnostic_signs
end

local function debuggers_for_line(bufnr, lnum)
  return filter_by_prefix(placed_signs_for_group(bufnr, lnum, "*"), "Dap")
end

local function neotests_for_line(bufnr, lnum)
  return placed_signs_for_group(bufnr, lnum, "neotest-status")
end

local function gitsigns_for_line(bufnr, lnum)
  return extmarks_for_prefix(bufnr, lnum, "gitsigns")
end

local function debug_line()
  local bufnr = vim.api.nvim_get_current_buf()
  local _, lnum, _, _ = unpack(vim.fn.getpos("."))
  print("Debugger Signs")
  print(vim.inspect(debuggers_for_line(bufnr, lnum)))

  print("Diagnostic Signs")
  print(vim.inspect(diagnostics_for_line(bufnr, lnum)))

  print("Neotest Signs")
  print(vim.inspect(neotests_for_line(bufnr, lnum)))

  print("Gitsign Signs")
  print(vim.inspect(gitsigns_for_line(bufnr, lnum)))
end

local function first_key_by_partial_match(table, match)
  for k, _ in pairs(table) do
    if vim.startswith(match, k) or vim.startswith(k, match) then
      return k
    end
  end

  return nil
end

_G.statuscolumn_gitsigns = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return " "
  end

  for _, sign in pairs(gitsigns_for_line(bufnr, lnum)) do
    local name = first_key_by_partial_match(signs, sign)

    if name then
      return render_sign(name)
    else
      vim.print("Could not find sign for " .. sign)
    end
  end

  return " "
end

_G.statuscolumn_diagnostics = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return ""
  end

  local diag_sign = diagnostics_for_line(bufnr, lnum)[1]
  if diag_sign ~= nil then
    local severities = { "Error", "Warn", "Info", "Hint" }
    return render_sign("DiagnosticSign" .. severities[diag_sign.severity])
  else
    return ""
  end
end

_G.statuscolumn_neotest = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return ""
  end

  local neotest_sign = neotests_for_line(bufnr, lnum)[1]
  if neotest_sign ~= nil then
    local name = require("util").camel_case(neotest_sign["name"])
    return render_sign(name)
  else
    return ""
  end
end

_G.statuscolumn_debugger = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return " "
  end

  local debugger_sign = debuggers_for_line(bufnr, lnum)[1]
  if debugger_sign ~= nil then
    return render_sign(debugger_sign["name"])
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
    "gitsigns",
    "diagnostics",
    "neotest",
    "debugger",
    "sep",
    "num",
    "space",
  }

  for _, val in ipairs(order) do
    table.insert(str_table, statuscolumn_parts[val])
  end

  return table.concat(str_table)
end

_G.inactive_statuscolumn = function()
  local str_table = {}

  local order = {
    "gitsigns",
    "diagnostics",
    "neotest",
    "debugger",
    "sep",
    "absnum",
    "space",
  }

  for _, val in ipairs(order) do
    table.insert(str_table, statuscolumn_parts[val])
  end

  return table.concat(str_table)
end

return {
  debug_line = debug_line,
}
