-- https://github.com/nvim-neotest/neotest

require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-go"),
    require("neotest-rspec")
  }
})

vim.keymap.set('n', '<leader>tp', function()
  require('neotest').run.run({ suite = true })
end, { desc = '[T]est [P]roject' })

vim.keymap.set('n', '<leader>ta', require('neotest').run.attach, { desc = '[T]est - [A]ttach to current run' })

vim.keymap.set('n', '<leader>td', function()
  require('neotest').run.run({ strategy = 'dap' })
end, { desc = '[T]est - Run test with [d]ebugging' })

vim.keymap.set('n', '<leader>tf', function()
  require('neotest').run.run(vim.fn.expand('%'))
end, { desc = '[T]est [F]ile' })

vim.keymap.set('n', '<leader>to', function()
  require('neotest').output.open({ enter = true })
end, { desc = '[T]est - Show [o]utput' })

vim.keymap.set('n', '<leader>ts', require('neotest').summary.toggle, { desc = '[T]est - Open [s]ummary window' })
vim.keymap.set('n', '<leader>tS', require('neotest').run.stop,       { desc = '[T]est - [S]top current run' })
vim.keymap.set('n', '<leader>tt', require('neotest').run.run,        { desc = '[T]est - Run neares[t]' })
vim.keymap.set('n', '<leader>tT', require('neotest').run.run_last,   { desc = '[T]est - re-run las[t]' })

-- `f/F` textobject is taken by `function` in LSP
vim.keymap.set('n', '[x', function()
  require('neotest').jump.prev({ status = "failed" })
end, { desc = 'Jump to previous failed test' })

vim.keymap.set('n', ']x', function()
  require('neotest').jump.next({ status = "failed" })
end, { desc = 'Jump to next failed test' })
