local function config()
  local ap = require("actions-preview")
  ap.setup()
  vim.keymap.set({ "v", "n" }, "<leader>fa", ap.code_actions)
end

return {
  name = "aznhe21/actions-preview.nvim",
  config = config,
}
