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
v.signcolumn = 'yes'

-- Search
v.incsearch = true

-- Theme
v.termguicolors = true
v.background = 'dark'
vim.cmd('colorscheme tokyonight')
vim.cmd('syntax on')

-- Misc
-- Reducing updatetime is will improve perceived performance of features using
-- cursorhold events. The resource usage will be increased, tho.
v.updatetime = 300
