local keymap = vim.keymap.set
local wk = require("which-key")

-- Tab navigation
local function keymap_tab_n(n)
  keymap("n", "<leader>" .. n, ":<C-u><cr>" .. n .. "gt")
end

for n = 1, 9 do
  keymap_tab_n(n)
end

keymap("n", "th", "<cmd>tabfirst<cr>", { desc = "Tab: First" })
keymap("n", "tk", "<cmd>tabnext<cr>", { desc = "Tab: Next" })
keymap("n", "tj", "<cmd>tabprev<cr>", { desc = "Tab: Previous" })
keymap("n", "tl", "<cmd>tablast<cr>", { desc = "Tab: Last" })

-- More intuitive vertical navigation of word-wrapping lines
keymap(
  "n",
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, desc = "Move up (wrapped)" }
)
keymap(
  "n",
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, desc = "Move down (wrapped)" }
)

-- Center window vertically when cycling matches
keymap("n", "n", "nzzzv", { desc = "Next match (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous match (centered)" })

-- Insert mode
keymap("i", "<M-BS>", "<c-w>", { desc = "Delete word" })

-- Visual mode
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })
