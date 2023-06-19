return {
  "folke/neodev.nvim",
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      require("which-key").setup({
        -- Additional configuration can be set here
        -- https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
      })
    end,
  },
}
