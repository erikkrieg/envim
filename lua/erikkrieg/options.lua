-- Global variables
local v = vim.opt

-- Indentation
local tabSize = 2
v.tabstop = tabSize 
v.shiftwidth =  tabSize
v.softtabstop =  tabSize
v.expandtab = true
v.autoindent = true
v.smartindent = true

-- Display
v.colorcolumn = '80'
v.relativenumber = true
v.number = true
v.scrolloff = 8
v.showcmd = true

-- Search
v.incsearch = true

-- Theme
v.termguicolors = true
v.background = 'dark'
vim.cmd('colorscheme tokyonight')
vim.cmd('syntax on')

