-- Using vim-plug
local Plug = vim.fn['plug#']
vim.call('plug#begin')
  -- Language plugins
  Plug('fatih/vim-go', { ['do'] = 'GoUpdateBinaries' })

  -- Themes
  Plug('dracula/vim', { as = 'dracula' })
  Plug('folke/tokyonight.nvim', { branch = 'main' })

  -- Look into these themes plug:
  -- - https://github.com/sonph/onehalf
  -- - https://github.com/chriskempson/base16-vim/
vim.call('plug#end')

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
