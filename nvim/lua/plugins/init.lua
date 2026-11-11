return {
  { "nvim-lua/plenary.nvim" },
  { -- Multi-line comments
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    build = ":TSUpdate",
    config = function()
      -- Parsers and queries come from Nix; enable highlighting and indent for
      -- every filetype that has a parser.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
            return
          end
          vim.bo[args.buf].syntax = "ON" -- Keep regex highlighting as well
          local has_indents = #vim.treesitter.query.get_files(lang, "indents") > 0
          if lang ~= "yaml" and has_indents then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
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
      vim.g.go_info_mode = "guru"
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
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 750
      local wk = require("which-key")
      wk.setup({
        show_help = false,
        plugins = { spelling = true },
        replace = {
          key = {
            { "<leader>", "SPC" },
          },
        },
      })
      wk.add({
        { "<leader>f", group = "Telescope" },
        { "<leader>1", hidden = true },
        { "<leader>2", hidden = true },
        { "<leader>3", hidden = true },
        { "<leader>4", hidden = true },
        { "<leader>5", hidden = true },
        { "<leader>6", hidden = true },
        { "<leader>7", hidden = true },
        { "<leader>8", hidden = true },
        { "<leader>9", hidden = true },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
  { -- Helpful rendering of white space and indent levels
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    priority = 900,
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append("eol:↴")
      require("ibl").setup({
        indent = {
          char = "▎",
          tab_char = "▎",
        },
      })
    end,
  },
}
