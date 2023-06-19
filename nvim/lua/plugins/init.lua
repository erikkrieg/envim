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
}
