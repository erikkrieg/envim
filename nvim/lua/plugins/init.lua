return {
  "nvim-lua/plenary.nvim",
  {
    "numToStr/Comment.nvim", -- Multi-line comments
    event = "BufReadPre",
    config = function()
      require("Comment").setup()
    end,
  },
}
