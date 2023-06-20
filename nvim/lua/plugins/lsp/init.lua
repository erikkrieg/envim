return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-cmdline" },
      { "onsails/lspkind-nvim" },
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        dependencies = "hrsh7th/nvim-cmp",
      },

      -- Plugins for specific languages
      { -- Neovim Lua LSP features
        "folke/neodev.nvim",
        config = true,
      },
      { -- Rust LSP configuration
        "simrat39/rust-tools.nvim",
      },
    },
    config = function()
      require("plugins.lsp.servers").setup()
      require("plugins.lsp.completions").setup()
    end,
  },
}
