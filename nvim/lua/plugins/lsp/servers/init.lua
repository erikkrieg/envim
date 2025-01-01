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
          cargo = {
            features = "all",
          },
          files = {
            excludeDirs = {
              ".cargo",
              ".direnv",
              ".git",
              "node_modules",
              "target",
            },
          },
          checkOnSave = {
            command = "clippy",
            features = "all",
          },
          check = {
            command = "clippy",
            features = "all",
          },
          procMacro = {
            enable = true,
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
  require("lspconfig").ts_ls.setup(config({}))

  -- Nix
  require("lspconfig").nil_ls.setup(config({}))

  -- JSON
  require("lspconfig").jsonls.setup(config({}))

  -- Haskell
  -- Going to try haskell tools for now since syntax highlighting was not great
  -- require("lspconfig").hls.setup(config({}))

  -- Helm
  local configs = require("lspconfig.configs")
  local util = require("lspconfig.util")
  if not configs.helm_ls then
    configs.helm_ls = {
      default_config = {
        cmd = { "helm_ls", "serve" },
        filetypes = { "helm" },
        root_dir = function(fname)
          return util.root_pattern("Chart.yaml")(fname)
        end,
      },
    }
  end
  lsp.helm_ls.setup(config({}))

  -- Yaml
  local yamlconfig = config({
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
  })
  local yaml_attach = yamlconfig.on_attach
  yamlconfig.on_attach = function(client, bufnr)
    -- yamlls does not play nice with helm files
    -- https://github.com/redhat-developer/yaml-language-server/issues/220
    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
      vim.lsp.stop_client(client.id)
    else
      yaml_attach(client, bufnr)
    end
  end
  require("lspconfig").yamlls.setup(yamlconfig)

  -- Markdown
  require("lspconfig").marksman.setup(config({}))

  -- Grammar and spelling markup languages (includes markdown)
  require("lspconfig").ltex.setup(config({
    flags = { debounce_text_changes = 300 },
    settings = {
      ltex = {
        language = "en",
        additionalRules = {
          languageModel = "~/models/ngrams/",
        },
      },
    },
  }))
end

return M
