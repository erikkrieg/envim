local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>F', vim.lsp.buf.format, bufopts)
end

local function config(c)
  cfg = c or {}
  cfg.on_attach = on_attach
  cfg.capabilities = capabilities
  return cfg
end

-- Rust
require('rust-tools').setup({
    server = config({
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy"
          },
        }
      }
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

-- Nim
require'lspconfig'.nimls.setup(config({
  settings = {
    filetypes = { "*.nim", "nim" }
  }
}))

-- Python
require("lspconfig").pyright.setup(config({}))

-- TS/JS
require('lspconfig').tsserver.setup(config({}))

