return {
  "nvim-lua/plenary.nvim",
  "folke/neodev.nvim",
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 750
      local wk = require("which-key")
      wk.setup({
        show_help = false,
        plugins = { spelling = true },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
      })
      wk.register({
        f = {
          name = "+Telescope",
        },
      }, { prefix = "<leader>" })
    end,
  },
}
