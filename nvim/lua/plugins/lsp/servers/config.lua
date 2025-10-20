local M = {}

M.on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  local wk = require("which-key")
  wk.add({
    buffer = bufnr,
    { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
    { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
    { "K", vim.lsp.buf.hover, desc = "Hover documentation" },
    { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
    { "gr", vim.lsp.buf.references, desc = "References" },
    { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help" },
    { "<leader>w", group = "Workspace" },
    { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add folder" },
    {
      "<leader>wr",
      vim.lsp.buf.remove_workspace_folder,
      desc = "Remove folder",
    },
    {
      "<leader>wl",
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      desc = "List folders",
    },
    { "<leader>c", group = "Code" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Actions" },
    { "<leader>D", vim.lsp.buf.type_definition, desc = "Type definition" },
    { "<leader>rn", ":IncRename ", desc = "Rename symbol" },
    { "<leader>F", vim.lsp.buf.format, desc = "Format buffer" },
  })
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
