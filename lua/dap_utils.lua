local function dap()
  local ok, d = pcall(require, "dap")
  assert(ok, "nvim-dap is is not installed.")
  return d
end

local rspec_line = {
  type = "ruby",
  name = "run rspec current_file:current_line",
  bundle = "bundle",
  request = "attach",
  command = "rspec",
  script = "${file}",
  port = 38698,
  server = "127.0.0.1",
  options = {
    source_filetype = "ruby",
  },
  localfs = true,
  waiting = 1000,
  current_line = true,
}

local rspec_file = {
  type = "ruby",
  name = "run rspec current_file",
  bundle = "bundle",
  request = "attach",
  command = "rspec",
  script = "${file}",
  port = 38698,
  server = "127.0.0.1",
  options = {
    source_filetype = "ruby",
  },
  localfs = true,
  waiting = 1000,
}

return {
  dap = dap,
  rspec_line = rspec_line,
}
