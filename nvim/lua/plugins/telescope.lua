return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.2",
  dependencies = { "folke/which-key.nvim", "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
    { "<leader>f/", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    { "<leader>ft", "<cmd>Telescope<cr>", desc = "Telescope options" },
  },
  config = true,
}
