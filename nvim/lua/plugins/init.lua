return {
  "nvim-lua/plenary.nvim",
  { -- Multi-line comments
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
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
      require("ibl").setup({})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "bash",
          "css",
          "go",
          "haskell",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "nix",
          "python",
          "toml",
          "yaml",
          "rust",
        },
        sync_install = false,
        ignore_install = { "" }, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = { "" }, -- list of language that will be disabled
          additional_vim_regex_highlighting = true,
        },
        indent = { enable = true, disable = { "yaml" } },
        rainbow = {
          enable = true,
          -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = nil, -- Do not enable for files with more than n lines, int
          -- colors = {}, -- table of hex strings
          -- termcolors = {} -- table of colour name strings
        },
      })
    end,
  },
  { -- KDL does not currently have an LSP
    "imsnif/kdl.vim",
    version = "b84d7d3a15d8d30da016cf9e98e2cfbe35cddee5",
    ft = { "kdl" },
  },
  { -- Vim syntax files for justfiles
    "NoahTheDuke/vim-just",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "\\cjustfile", "*.just", ".justfile" },
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
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^3",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
