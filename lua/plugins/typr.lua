-- https://github.com/nvzone/typr

return {
  "nvzone/typr",
  dependencies = "nvzone/volt",
  cmd = { "Typr", "TyprStats" },
  config = function()
    require("cmp").setup.filetype("typr", {
      enabled = false,
    })
  end,
}
