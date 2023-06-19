return {
  "nvim-lua/plenary.nvim",
  {
    "numToStr/Comment.nvim", -- Multi-line comments
    event = "BufReadPre",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    priority = 900,
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append("eol:↴")
      require("indent_blankline").setup({
        show_end_of_line = true,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    build = ":TSUpdate",
    event = "BufReadPost",
  },
  { -- KDL does not currently have an LSP
    "imsnif/kdl.vim",
    version = "b84d7d3a15d8d30da016cf9e98e2cfbe35cddee5",
    ft = { "kdl" },
  },
}
