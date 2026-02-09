-- https://github.com/NickvanDyke/opencode.nvim

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    ---@module 'snacks'
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {}

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    local maps = {
      { { "n", "x" }, "<leader>a", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode" } },
      { { "n", "x" }, "<leader>A", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" } },
      { { "n", "t" }, "<C-,>", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" } },
      { { "n", "x" }, "<C-.>", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to opencode" } },
      { "n", "<C-.>", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode" } },
    }

    local function set_keymaps()
      for _, map in ipairs(maps) do
        vim.keymap.set(map[1], map[2], map[3], map[4])
      end
    end

    local function del_keymaps()
      for _, map in ipairs(maps) do
        local modes = type(map[1]) == "table" and map[1] or { map[1] }
        for _, mode in ipairs(modes) do
          pcall(vim.keymap.del, mode, map[2])
        end
      end
    end

    if vim.g.ai_backend == "opencode" then
      set_keymaps()
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "AiBackendChanged",
      callback = function()
        if vim.g.ai_backend == "opencode" then
          set_keymaps()
        else
          del_keymaps()
        end
      end,
    })

    -- Buffer-local scrolling keymaps for opencode terminal only
    vim.api.nvim_create_autocmd("TermOpen", {
      callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        if bufname:match("opencode") then
          vim.keymap.set({ "n", "t" }, "<C-u>", function()
            require("opencode").command("session.half.page.up")
          end, { buffer = args.buf, desc = "opencode half page up" })

          vim.keymap.set({ "n", "t" }, "<C-d>", function()
            require("opencode").command("session.half.page.down")
          end, { buffer = args.buf, desc = "opencode half page down" })
        end
      end,
    })
  end,
}
