local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data")
    .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[packadd packer.nvim]])
require("packer").startup(function(use)
  -- Plugin management
  use("wbthomason/packer.nvim")

  -- General Language
  use("neovim/nvim-lspconfig")
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("hrsh7th/cmp-cmdline")
  use({
    "tzachar/cmp-tabnine",
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  })
  use("onsails/lspkind-nvim") -- Adds pictograms used by cmp formatter
  use({
    "numToStr/Comment.nvim", -- Multi-line comments
    config = function()
      require("Comment").setup()
    end,
  })
  use("sbdchd/neoformat")
  use({
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      require("which-key").setup({
        -- Additional configuration can be set here
        -- https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
      })
    end,
  })
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append("eol:↴")
      require("indent_blankline").setup({
        show_end_of_line = true,
      })
    end,
  })
  use({
    "goolord/alpha-nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local art = {
        [[                                                   ]],
        [[                                              ___  ]],
        [[                                           ,o88888 ]],
        [[                                        ,o8888888' ]],
        [[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
        [[              ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"    ]],
        [[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
        [[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
        [[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
        [[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
        [[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
        [[             . ..:.::o:ooooOoCoCCC"o:o             ]],
        [[             . ..:.::o:o:,cooooCo"oo:o:            ]],
        [[          `   . . ..:.:cocoooo"'o:o:::'            ]],
        [[          .`   . ..::ccccoc"'o:o:o:::'             ]],
        [[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
        [[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
        [[     ...:.'.:.::::"'    . . . . .'                 ]],
        [[    .. . ....:."' `   .  . . ''                    ]],
        [[  . . . ...."'                                     ]],
        [[  .. . ."'                                         ]],
        [[ .                                                 ]],
        [[                                                   ]],
      }
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = art
      require("alpha").setup(dashboard.config)
    end,
  })

  -- Specific Languages
  use("simrat39/rust-tools.nvim")
  use({ "fatih/vim-go", run = ":GoUpdateBinaries" })
  use("NoahTheDuke/vim-just")
  use("hashivim/vim-terraform") -- Using this for syntax highlighting because lsp isn't providing it
  use("zah/nim.vim")
  use({ "imsnif/kdl.vim", commit = "b84d7d3a15d8d30da016cf9e98e2cfbe35cddee5" }) -- KDL does not currently have an LSP

  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update =
        require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  })
  use({ "nvim-lua/plenary.nvim", requires = "nvim-treesitter/nvim-treesitter" })
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = "nvim-lua/plenary.nvim",
  })

  -- Themes
  use({ "dracula/vim", as = "dracula" })
  use({ "folke/tokyonight.nvim", branch = "main" })

  -- Look into these themes plug:
  -- - https://github.com/sonph/onehalf
  -- - https://github.com/chriskempson/base16-vim/
  -- use 'rcarriga/nvim-notify'

  if packer_bootstrap then
    require("packer").sync()
  end
end)

-- Plugin options
-- vim-go options
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

-- Default markdown ftplugin changes my settings
vim.g.markdown_recommended_style = 0

-- neoformat
vim.g.neoformat_try_node_exe = 1 -- look for prettier bin in node_modules

-- tokyonight options
vim.g.tokyonight_style = "storm"
