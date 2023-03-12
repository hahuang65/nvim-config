-- https://www.reddit.com/r/neovim/comments/10fpqbp/gist_statuscolumn_separate_diagnostics_and/

local gitsigns_config = {
  GitSignsAdd = { name = "add", icon = "│", hl = "GitSignsAdd" },
  GitSignsChange = { name = "change", icon = "│", hl = "GitSignsChange" },
  GitSignsChangedelete = { name = "changedelete", icon = "~", hl = "GitSignsChange" },
  GitSignsDelete = { name = "delete", icon = "_", hl = "GitSignsDelete" },
  GitSignsTopdelete = { name = "topdelete", icon = "‾", hl = "GitSignsDelete" },
  GitSignsUntracked = { name = "untracked", icon = "┆", hl = "GitSignsAdd" },
}

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

local function sign_name(placed_signs)
  if placed_signs == nil then
    return nil
  end

  placed_signs = placed_signs[1]
  if placed_signs == nil then
    return nil
  end

  placed_signs = placed_signs.signs
  if placed_signs == nil then
    return nil
  end

  placed_signs = placed_signs[1]
  if placed_signs == nil then
    return nil
  end

  return placed_signs["name"]
end

local function render_sign(hlgroup, sym)
  return table.concat({ "%#", hlgroup, "#", sym, "%*" })
end

local function placed_signs_for_group(bufnr, lnum, group)
  local placed_signs = vim.fn.sign_getplaced(bufnr, {
    group = group,
    lnum = lnum,
  })

  return sign_name(placed_signs)
end

_G.statuscolumn_gitsigns = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return " "
  end

  local gitsign = placed_signs_for_group(bufnr, lnum, "gitsigns_vimfn_signs_")
  if gitsign ~= nil then
    return render_sign(gitsign, gitsigns_config[gitsign]["icon"])
  else
    return " "
  end
end

_G.statuscolumn_diagnostics = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return " "
  end

  local diag_sign = placed_signs_for_group(bufnr, lnum, "*")

  if diag_sign ~= nil and vim.startswith(diag_sign, "DiagnosticSign") then
    return render_sign(diag_sign, diagnostic_icons[diag_sign])
  else
    return " "
  end
end

_G.statuscolumn_neotest = function(bufnr, lnum, virtnum)
  if virtnum < 0 then
    return " "
  end

  local neotest_sign = placed_signs_for_group(bufnr, lnum, "neotest-status")

  if neotest_sign ~= nil then
    return render_sign(neotest_config[neotest_sign]["hl"], neotest_config[neotest_sign]["icon"])
  else
    return " "
  end
end

_G.statuscolumn = function()
  local str_table = {}

  local parts = {
    ["diagnostics"] = "%{%v:lua.statuscolumn_diagnostics(bufnr(), v:lnum, v:virtnum)%}",
    ["fold"] = "%C",
    ["gitsigns"] = "%{%v:lua.statuscolumn_gitsigns(bufnr(), v:lnum, v:virtnum)%}",
    ["neotest"] = "%{%v:lua.statuscolumn_neotest(bufnr(), v:lnum, v:virtnum)%}",
    ["num"] = '%{v:virtnum<0?"":v:relnum?v:relnum:v:lnum}',
    ["sep"] = "%=",
    ["signcol"] = "%s",
    ["space"] = " ",
  }

  local order = {
    "neotest", -- some bug here where if there's a neotest symbol and a diagnostic symble, the diagnostic won't show up
    "diagnostics",
    "sep",
    "num",
    "gitsigns",
    "fold",
  }

  for _, val in ipairs(order) do
    table.insert(str_table, parts[val])
  end

  return table.concat(str_table)
end

return {
  diagnostic_icons = diagnostic_icons,
  gitsigns_config = gitsigns_config,
}
