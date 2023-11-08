return {
  {
    name = "folke/styler.nvim",
    event = "VeryLazy",
    config = function()
      require("styler").setup({
        themes = {
          help = { colorscheme = "catppuccin", background = "dark" },
        },
      })
    end,
  },
  {
    name = "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local tokyonight = require("tokyonight")
      tokyonight.setup({ style = "storm" })
      tokyonight.load()
    end,
  },
  {
    name = "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin")
    end,
  },
}
