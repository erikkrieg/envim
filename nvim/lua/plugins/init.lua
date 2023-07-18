return {
  "nvim-lua/plenary.nvim",
  { -- Multi-line comments
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = function()
      require("Comment").setup()
    end,
  },
  { -- Helpful rendering of white space and indent levels
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
  { -- Vim syntax files for justfiles
    "NoahTheDuke/vim-just",
    event = "BufReadPre",
  },
  { -- Better language support for Go (lsp features are a bit lacking)
    "fatih/vim-go",
    ft = "go",
    build = ":GoUpdateBinaries",
    config = function()
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_variable_declarations = 1
      vim.g.go_highlight_variable_assignments = 1
      vim.g.go_metalinter_enabled = { "vet", "golint", "errcheck" }
      vim.g.go_metalinter_autosave = 1
      vim.g.go_metalinter_deadline = "5s"
      vim.g.go_auto_type_info = 1
    end,
  },
  { -- Terraform syntax highlighting (look into other options)
    "hashivim/vim-terraform",
    ft = { "tf", "tfvar" },
  },
  {
    "towolf/vim-helm",
    ft = { "yaml" },
  },
}
