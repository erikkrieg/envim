local M = {}

M.on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local map_n = function(lhs, rhs, desc)
    local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
    vim.keymap.set("n", lhs, rhs, opts)
  end

  map_n("gD", vim.lsp.buf.declaration, "Go to declaration")
  map_n("gd", vim.lsp.buf.definition, "Go to definition")
  map_n("K", vim.lsp.buf.hover, "Hover documentation")
  map_n("gi", vim.lsp.buf.implementation, "Go to implementation")
  map_n("<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map_n("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map_n(
    "<leader>wr",
    vim.lsp.buf.remove_workspace_folder,
    "Remove workspace folder"
  )
  map_n("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
  map_n("<leader>D", vim.lsp.buf.type_definition, "Type definition")
  map_n("<leader>rn", ":IncRename ", "Rename symbol")
  map_n("<leader>ca", vim.lsp.buf.code_action, "Code actions")
  map_n("gr", vim.lsp.buf.references, "References")
  map_n("<leader>F", vim.lsp.buf.format, "Format buffer")
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

M.config = function(c)
  local cfg = c or {}
  cfg.on_attach = M.on_attach
  cfg.capabilities = M.capabilities
  return cfg
end

return M
