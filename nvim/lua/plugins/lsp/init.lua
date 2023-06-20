return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },

      -- Provides LSP capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",

      -- Plugins for specific languages
      { "folke/neodev.nvim", config = true }, -- Neovim Lua LSP features
      "simrat39/rust-tools.nvim", -- Easier Rust LSP config
    },
    config = function()
      require("plugins.lsp.servers").setup()
    end,
  },
}
