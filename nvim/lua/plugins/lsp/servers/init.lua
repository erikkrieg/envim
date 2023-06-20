local M = {}

M.setup = function()
  local lsp = require("lspconfig")
  local config = require("plugins.lsp.servers.config").config

  lsp.lua_ls.setup(config(require("plugins.lsp.servers.lua")))

  require("rust-tools").setup({
    server = config({
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    }),
  })

  require("lspconfig").gopls.setup(config({

    cmd = { "gopls", "serve" },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }))
end

return M
