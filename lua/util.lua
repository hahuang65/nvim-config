local function toggle_quickfix()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
    return
  else
    vim.notify("Quickfix is empty.", vim.log.levels.WARN)
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd("copen")
  else
    vim.notify("Quickfix is empty.", vim.log.levels.WARN)
  end
end

local function paste()
  vim.ui.input({ prompt = "New Paste (omit extension): " }, function(name)
    local url = vim.cmd([['<,'>w ! pst -u -n ]] .. name .. "." .. vim.bo.filetype)

    if url == nil or url == "" then
      vim.notify("Error creating paste", vim.log.levels.ERROR)
    else
      vim.notify(url, vim.log.levels.WARN, { title = "paste.sr.ht", timeout = 10000 })
    end
  end)
end

local function filetype_icon(filename, extension)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    vim.notify("No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'", vim.log.levels.WARN)
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

local function format_just_edited()
  local start_row, start_col, end_row, end_col

  vim.cmd.norm("`[v`]")
  _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
  _, end_row, end_col, _ = unpack(vim.fn.getpos("."))

  -- exit visual mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

  -- format range, this isn't strictly needed, as one could just `vim.lsp.buf.format()` before
  -- exiting visual mode, but this documents some useful tricks on getting positions in a buffer.
  vim.lsp.buf.format({
    range = {
      ["end"] = { end_row, end_col - 1 },
      ["start"] = { start_row, start_col - 1 },
    },
  })
end

local function has_value(table, value)
  for _, v in ipairs(table) do
    if value == v then
      return true
    end
  end

  return false
end

local function define_sign(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    linehl = "",
    numhl = "",
  })
end

return {
  filename = filename,
  filetype_icon = filetype_icon,
  paste = paste,
  toggle_quickfix = toggle_quickfix,
  format_just_edited = format_just_edited,
  has_value = has_value,
  define_sign = define_sign,
}
