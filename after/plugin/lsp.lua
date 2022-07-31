local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

local function config(c)
  return c or {}
end

-- Look into fleshing this out: https://sharksforarms.dev/posts/neovim-rust/
require('lspconfig')['rust_analyzer'].setup{}

--[[
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
]]--
