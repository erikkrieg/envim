return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },

      -- LSP progress UI
      {
        "j-hui/fidget.nvim",
        config = true,
        -- Pin to legacy to avoid breaking changes
        commit = "0ba1e16d07627532b6cae915cc992ecac249fb97",
      },

      -- Provides LSP capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",

      -- Plugins for specific languages
      { "folke/neodev.nvim", config = true }, -- Neovim Lua LSP features
      "simrat39/rust-tools.nvim", -- Easier Rust LSP config

      -- Misc
      { "smjonas/inc-rename.nvim", config = true },
    },
    config = function()
      require("neoconf").setup({})
      require("fidget").setup({})
      require("plugins.lsp.servers").setup()
    end,
  },
  require("plugins.lsp.format"),
}
