-- https://www.reddit.com/r/neovim/comments/10fpqbp/gist_statuscolumn_separate_diagnostics_and/

local signs = require("signs").signs

local function render_sign(name)
  local sign = vim.fn.sign_getdefined(name)[1]
  if sign ~= nil then
    return table.concat({ "%#", sign.texthl, "#", sign.text, "%*" })
  end
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

  local gitsign = placed_signs_for_group(bufnr, lnum, "gitsigns_vimfn_signs_")[1]
  if gitsign ~= nil then
    local name = first_key_by_partial_match(signs, gitsign["name"])
    if name then
      return render_sign(name)
    else
      vim.notify("Could not find sign for " .. gitsign["name"])
    end
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
    return render_sign(diag_sign["name"])
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

  local debugger_sign = filter_by_prefix(placed_signs_for_group(bufnr, lnum, "*"), "Dap")[1]
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
    "diagnostics",
    "neotest",
    "debugger",
    "sep",
    "num",
    "space",
    "gitsigns",
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
  }

  for _, val in ipairs(order) do
    table.insert(str_table, statuscolumn_parts[val])
  end

  return table.concat(str_table)
end

return {
  debug_line = debug_line,
}
