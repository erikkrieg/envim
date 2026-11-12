local M = {}

-- neoconf only hooks the legacy require("lspconfig") setup, so merge its
-- settings (.neoconf.json, .vscode/settings.json) into each new client here.
local function apply_neoconf(client)
  local config = client.config
  local before = vim.deepcopy(client.settings)
  config.settings = config.settings or {}
  require("neoconf.plugins.lspconfig").on_new_config(
    config,
    client.root_dir,
    config
  )
  if not vim.deep_equal(before, config.settings) then
    client.settings = config.settings
    client:notify(
      "workspace/didChangeConfiguration",
      { settings = client.settings }
    )
  end
end

M.setup = function()
  local shared = require("plugins.lsp.servers.config")

  -- LspAttach rather than on_attach in each config: it also covers
  -- rust-analyzer from rustaceanvim and keeps the on_attach that some
  -- lspconfig server configs define.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspSharedAttach", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        shared.on_attach(client, args.buf)
      end
    end,
  })
  local neoconf_applied = {}
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspNeoconf", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and not neoconf_applied[client.id] then
        neoconf_applied[client.id] = true
        apply_neoconf(client)
      end
    end,
  })
  vim.lsp.config("*", { capabilities = shared.capabilities })

  -- Lua
  vim.lsp.config("lua_ls", require("plugins.lsp.servers.lua"))
  vim.lsp.enable("lua_ls")

  -- Rust: rustaceanvim starts rust-analyzer itself when a Rust buffer opens,
  -- so it must not also be enabled with vim.lsp.enable.
  vim.g.rustaceanvim = {
    server = {
      default_settings = {
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
          check = {
            command = "clippy",
            features = "all",
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
  }

  -- Go
  vim.lsp.config("gopls", {
    cmd = { "gopls", "serve" },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  })
  vim.lsp.enable("gopls")

  -- Bash
  vim.lsp.enable("bashls")

  -- Terraform
  vim.lsp.enable({ "terraformls", "tflint" })

  -- Python
  vim.lsp.enable("pyright")

  -- TS/JS
  vim.lsp.enable("ts_ls")

  -- Nix
  vim.lsp.enable("nil_ls")

  -- JSON
  vim.lsp.enable("jsonls")

  -- Haskell
  -- Going to try haskell tools for now since syntax highlighting was not great
  -- vim.lsp.enable("hls")

  -- Helm
  vim.lsp.enable("helm_ls")

  -- Yaml
  vim.lsp.config("yamlls", {
    on_attach = function(client, bufnr)
      -- yamlls does not play nice with helm files
      -- https://github.com/redhat-developer/yaml-language-server/issues/220
      if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
        client:stop()
      end
    end,
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
  vim.lsp.enable("yamlls")

  -- Markdown
  vim.lsp.enable("rumdl")

  -- Grammar and spelling. lspconfig's default filetypes include many
  -- programming languages, so limit harper to prose.
  vim.lsp.config("harper_ls", { filetypes = { "markdown", "gitcommit" } })
  vim.lsp.enable("harper_ls")
end

return M
