local function toggle_quickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
  elseif not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd("copen")
  else
    vim.notify("Quickfix is empty.", vim.log.levels.WARN)
  end
end

local function paste()
  vim.ui.input({ prompt = "New Paste (omit extension): " }, function(name)
    vim.cmd([['<,'>w ! pst -u -n ]] .. name .. "." .. vim.bo.filetype)
  end)
end

local function filetype_icon(filename, extension)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    vim.notify("No icon plugin found. Please install 'nvim-tree/nvim-web-devicons'", vim.log.levels.WARN)
    return ""
  end
  local icon = devicons.get_icon(filename, extension) or ""
  return icon
end

local function filename()
  if vim.b.term_title then
    return vim.b.term_title
  else
    local shortname = vim.fn.expand("%:t")

    if vim.fn.empty(shortname) == 1 then
      return "[No Name]"
    end

    local name = vim.fn.expand("%")
    local extension = vim.fn.expand("%:e")
    local readonly = ""

    if vim.bo.readonly == true then
      readonly = " " .. filetype_icon(shortname, extension)
    else
      readonly = ""
    end

    if string.len(readonly) ~= 0 then
      return name .. readonly
    end

    if vim.bo.modifiable then
      if vim.bo.modified then
        return name .. " " .. ""
      end
    end
    return name
  end
end

local function has_value(table, value)
  for _, v in ipairs(table) do
    if value == v then
      return true
    end
  end

  return false
end

local function file_contents_match(filepath, word)
  for line in io.lines(filepath) do
    if string.find(line, "%f[%a]" .. word .. "%f[%A]") then
      return true
    end
  end

  return false
end

local function camel_case(word)
  word = word:gsub("(%l)(%w*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)

  return word:gsub("_", "")
end

local function dir_has_file(dir, file)
  return require("lspconfig").util.search_ancestors(dir, function(path)
    local abs_path = require("lspconfig").util.path.join(path, file)
    if require("lspconfig").util.path.is_file(abs_path) then
      return true
    end
  end)
end

local function cwd_has_file(file)
  return dir_has_file(vim.uv.cwd(), file)
end

return {
  camel_case = camel_case,
  file_contents_match = file_contents_match,
  filename = filename,
  filetype_icon = filetype_icon,
  has_value = has_value,
  paste = paste,
  toggle_quickfix = toggle_quickfix,
  dir_has_file = dir_has_file,
  cwd_has_file = cwd_has_file,
}
