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

local function get_sign_name(cur_sign)
  if cur_sign == nil then
    return nil
  end

  cur_sign = cur_sign[1]

  if cur_sign == nil then
    return nil
  end

  cur_sign = cur_sign.signs

  if cur_sign == nil then
    return nil
  end

  cur_sign = cur_sign[1]

  if cur_sign == nil then
    return nil
  end

  return cur_sign["name"]
end

local function mk_hl(group, sym)
  return table.concat({ "%#", group, "#", sym, "%*" })
end

local function get_name_from_group(bufnr, lnum, group)
  local cur_sign_tbl = vim.fn.sign_getplaced(bufnr, {
    group = group,
    lnum = lnum,
  })

  return get_sign_name(cur_sign_tbl)
end

_G.statuscolumn_gitsigns = function(bufnr, lnum)
  local sign_name = get_name_from_group(bufnr, lnum, "gitsigns_vimfn_signs_")

  if sign_name ~= nil then
    return mk_hl(sign_name, gitsigns_config[sign_name]["icon"])
  else
    return " "
  end
end

_G.statuscolumn_diagnostics = function(bufnr, lnum)
  local cur_sign_nm = get_name_from_group(bufnr, lnum, "*")

  if cur_sign_nm ~= nil and vim.startswith(cur_sign_nm, "DiagnosticSign") then
    return mk_hl(cur_sign_nm, diagnostic_icons[cur_sign_nm])
  else
    return " "
  end
end

_G.statuscolumn = function()
  local str_table = {}

  local parts = {
    ["diagnostics"] = "%{%v:lua.statuscolumn_diagnostics(bufnr(), v:lnum)%}",
    ["fold"] = "%C",
    ["gitsigns"] = "%{%v:lua.statuscolumn_gitsigns(bufnr(), v:lnum)%}",
    ["num"] = "%{v:relnum?v:relnum:v:lnum}",
    ["sep"] = "%=",
    ["signcol"] = "%s",
    ["space"] = " ",
  }

  local order = {
    "diagnostics",
    "sep",
    "num",
    "space",
    "gitsigns",
    "fold",
    "space",
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
