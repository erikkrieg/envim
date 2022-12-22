local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
  -- Plugin management
  use 'wbthomason/packer.nvim'

  -- General Language
  use('neovim/nvim-lspconfig')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('L3MON4D3/LuaSnip')
  use('saadparwaiz1/cmp_luasnip')
  use('hrsh7th/cmp-cmdline')
  use({'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'})
  use('onsails/lspkind-nvim') -- Adds pictograms used by cmp formatter

  -- Specific Languages
  use('simrat39/rust-tools.nvim')
  use({ 'fatih/vim-go', run = ':GoUpdateBinaries' })
  use('NoahTheDuke/vim-just')
  use('LnL7/vim-nix')
  use('hashivim/vim-terraform') -- Using this for syntax highlighting because lsp isn't providing it
  use('zah/nim.vim')
  -- use('reasonml-editor/vim-reason-plus')
  use('jordwalke/vim-reasonml')

  use("nvim-lua/plenary.nvim")
  use({'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = 'nvim-lua/plenary.nvim'})
  -- Themes
  use({'dracula/vim', as = 'dracula'})
  use({'folke/tokyonight.nvim', branch = 'main'})

  -- Look into these themes plug:
  -- - https://github.com/sonph/onehalf
  -- - https://github.com/chriskempson/base16-vim/

  if packer_bootstrap then
    require('packer').sync()
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
vim.g.go_metalinter_enabled = {'vet', 'golint', 'errcheck'}
vim.g.go_metalinter_autosave = 1
vim.g.go_metalinter_deadline = '5s'
vim.g.go_auto_type_info = 1

-- tokyonight options
vim.g.tokyonight_style = 'night'

