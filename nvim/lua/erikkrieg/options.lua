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
v.lazyredraw = true     -- improves macro performance

-- Search
v.incsearch = true
v.ignorecase = true
v.smartcase = true

-- Menus
v.completeopt='menu,menuone,preview,noselect'
v.pumheight=20

-- Theme
v.termguicolors = true
v.background = 'dark'
vim.cmd('colorscheme tokyonight-night')
vim.cmd('syntax on')

-- Misc
-- Reducing updatetime is will improve perceived performance of features using
-- cursorhold events. The resource usage will be increased, tho.
v.updatetime = 300
v.clipboard = 'unnamedplus'
