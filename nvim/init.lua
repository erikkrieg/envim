require("config.options") -- Some options need to be set before lazy
require("config.lazy")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.keymaps")
  end,
})
