vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'simrat39/rust-tools.nvim'
  use { 'fatih/vim-go', run = ':GoUpdateBinaries' }
  use { 'dracula/vim', as = 'dracula' }
  use { 'folke/tokyonight.nvim', branch = 'main' }
  use 'NoahTheDuke/vim-just'
  -- Look into these themes plug:
  -- - https://github.com/sonph/onehalf
  -- - https://github.com/chriskempson/base16-vim/
end)

-- Plugin options
-- vim-go options
vim.g.go_highlight_operators = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_types = 1
vim.g.go_highlight_variable_declarations = 1
vim.g.go_highlight_variable_assignments = 1

-- tokyonight options
vim.g.tokyonight_style = 'night'

