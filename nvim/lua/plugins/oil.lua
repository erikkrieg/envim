local function config()
  require("oil").setup({
    view_options = {
      show_hidden = true,
    },
  })
  -- Consider setting `--float`
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

return {
  name = "stevearc/oil.nvim",
  config = config,
}
