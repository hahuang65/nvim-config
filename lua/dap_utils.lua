local function extend_config(base, config)
  return vim.tbl_extend("force", base, config)
end

local ruby_base = {
  type = "ruby",
  request = "attach",
  options = { source_filetype = "ruby" },
  error_on_failure = true,
  localfs = true,
  waiting = 1000,
  random_port = true,
}

local function ruby_dap_config(config)
  extend_config(ruby_base, config)
end

local ruby_test_line = ruby_dap_config({
  name = "RSpec: Current Line",
  command = "bundle",
  args = { "exec", "rspec" },
  current_line = true,
})

local ruby_test_file = ruby_dap_config({
  name = "RSpec: Current File",
  command = "bundle",
  args = { "exec", "rspec" },
  current_file = true,
})

local rails_server = ruby_dap_config({
  name = "Rails: Server",
  command = "bundle",
  args = { "exec", "rails", "server" },
})

local ruby_file = ruby_dap_config({
  name = "Ruby: Current File",
  command = "bundle",
  args = { "exec", "rails", "runner" },
  current_file = true,
})

local pytest_file = {
  name = "Pytest: Current File",
  type = "python",
  request = "launch",
  module = "pytest",
  args = {
    "${file}",
    "-sv",
    "--log-cli-level=INFO",
  },
  console = "integratedTerminal",
}

return {
  ruby_test_line = ruby_test_line,
  ruby_test_file = ruby_test_file,
  rails_server = rails_server,
  ruby_file = ruby_file,
  pytest_file = pytest_file,
}
