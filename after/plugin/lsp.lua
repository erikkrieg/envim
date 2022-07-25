-- I don't really know what this does, but it is used everywhere...
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Look into fleshing this out: https://sharksforarms.dev/posts/neovim-rust/
require('lspconfig')['rust_analyzer'].setup{}

