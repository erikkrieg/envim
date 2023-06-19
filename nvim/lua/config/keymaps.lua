local keymap = vim.keymap.set

-- Normal
-- Tab navigation
local function keymap_tab_n(n)
  -- ":<C-u><cr>" clears any count
  keymap("n", "<leader>" .. n, ":<C-u><cr>" .. n .. "gt")
end

for n = 1, 9 do
  keymap_tab_n(n)
end

keymap("n", "th", "<cmd>tabfirst<cr>")
keymap("n", "tk", "<cmd>tabnext<cr>")
keymap("n", "tj", "<cmd>tabprev<cr>")
keymap("n", "tl", "<cmd>tablast<cr>")

-- More intuitive vertical navigation of word-wrapping lines
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Center window vertically when cycling matches
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Insert
-- Delete previous word
keymap("i", "<M-BS>", "<c-w>")

-- Visual
-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP')
