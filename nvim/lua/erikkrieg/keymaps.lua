local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal
-- Telescope
keymap("n", "<leader>t", "<cmd>Telescope<cr>", opts)
keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", opts)

-- Tab navigation
local function keymap_tab_n(n)
  -- ":<C-u><cr>" clears any count
  keymap("n", "<leader>" .. n, ":<C-u><cr>" .. n .. "gt", opts)
end

for n = 1, 9 do
  keymap_tab_n(n)
end

keymap("n", "th", "<cmd>tabfirst<cr>", opts)
keymap("n", "tk", "<cmd>tabnext<cr>", opts)
keymap("n", "tj", "<cmd>tabprev<cr>", opts)
keymap("n", "tl", "<cmd>tablast<cr>", opts)

-- Insert
keymap("i", "<M-BS>", "<c-w>", opts)

