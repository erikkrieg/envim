local keys = {
  { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
  { "<leader>f/", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
  { "<leader>ft", "<cmd>Telescope<cr>", desc = "Telescope options" },
}

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup()
    for _, k in ipairs(keys) do
      vim.keymap.set("n", k[1], k[2], {})
    end
  end,

  -- These options were for lazy loading when the given command is run or
  -- keys are inputted.
  cmd = "Telescope",
  keys = keys,
}
