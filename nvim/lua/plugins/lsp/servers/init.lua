local M = {}

M.setup = function()
  local lsp = require("lspconfig")
  local config = require("plugins.lsp.servers.config").config

  -- Lua
  lsp.lua_ls.setup(config(require("plugins.lsp.servers.lua")))

  -- Rust
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

  -- Go
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

  -- Bash
  require("lspconfig").bashls.setup(config({}))

  -- Terraform
  require("lspconfig").terraformls.setup(config({}))
  require("lspconfig").tflint.setup(config({}))

  -- Python
  require("lspconfig").pyright.setup(config({}))

  -- TS/JS
  require("lspconfig").tsserver.setup(config({}))

  -- Nix
  require("lspconfig").nil_ls.setup(config({}))

  -- Yaml
  require("lspconfig").yamlls.setup(config({
    settings = {
      yaml = {
        keyOrdering = false,
        -- Issues with schemas for different k8s versions:
        -- https://github.com/redhat-developer/yaml-language-server/issues/211
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        },
      },
    },
  }))

  -- Markdown
  require("lspconfig").marksman.setup(config({}))
end

return M
