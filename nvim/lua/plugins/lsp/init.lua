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
      },

      -- Provides LSP capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",

      -- Plugins for specific languages
      { "folke/lazydev.nvim", ft = "lua", opts = {} }, -- Neovim Lua LSP features
      "simrat39/rust-tools.nvim", -- Easier Rust LSP config

      -- Misc
      { "smjonas/inc-rename.nvim", config = true },
    },
    config = function()
      require("neoconf").setup({})
      require("fidget").setup({
        progress = {
          suppress_on_insert = true,
          ignore = { "ltex" },
        },
      })
      require("plugins.lsp.servers").setup()
    end,
  },
  require("plugins.lsp.format"),
}
