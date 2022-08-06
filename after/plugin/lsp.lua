local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities( capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function config(c)
  return c or {}
end

-- Rust
require('rust-tools').setup({
    server = {
        capabilities = capabilities,
        -- on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
})

-- Go
require("lspconfig").gopls.setup(config({
	cmd = { "gopls", "serve" },
  capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
},
}))

