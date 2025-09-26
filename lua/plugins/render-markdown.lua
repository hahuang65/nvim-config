-- https://github.com/MeanderingProgrammer/render-markdown.nvim

return {
  "MeanderingProgrammer/render-markdown.nvim", -- Make Markdown buffers look beautiful
  ft = { "markdown", "quarto" },
  opts = {
    render_modes = true, -- Render in ALL modes
    sign = {
      enabled = false, -- Turn off in the status column
    },
    completions = {
      blink = {
        enabled = true,
      },
      lsp = {
        enabled = true,
      },
    },
    heading = {
      border = true,
    },
    pipe_table = { preset = "heavy" },
  },
}
