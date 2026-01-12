-- If true, use completions instead of suggestions and the panel.
local use_cmp = false

local function config()
  require("copilot").setup({
    panel = {
      enabled = not use_cmp,
      auto_refresh = true,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-p>",
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = not use_cmp,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        -- I've seen accept integrated with nvim-cmp key mapping so that tab
        -- could be used. Something to consider for at a future point.
        accept = "<M-CR>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 18.x
    server_opts_overrides = {},
  })

  -- Check authentication status and disable if not authenticated
  vim.defer_fn(function()
    local status_output = vim.fn.execute("Copilot status")
    if status_output:match("Not authenticated") then
      vim.cmd("Copilot disable")
    end
  end, 1000)
end

return {
  {
    name = "zbirenbaum/copilot.lua",
    config = config,
  },
  {
    name = "zbirenbaum/copilot-cmp",
    config = function()
      if use_cmp then
        require("copilot_cmp").setup()
      end
    end,
  },
}
