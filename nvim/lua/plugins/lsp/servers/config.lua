local M = {}

M.on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Enable inlay hints if supported (off by default, toggle with <leader>ch)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
  end

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
    {
      "<leader>ch",
      function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
          { bufnr = bufnr }
        )
      end,
      desc = "Toggle inlay hints",
    },
    { "<leader>D", vim.lsp.buf.type_definition, desc = "Type definition" },
    { "<leader>rn", ":IncRename ", desc = "Rename symbol" },
    { "<leader>F", vim.lsp.buf.format, desc = "Format buffer" },
  })

  if client.name == "harper_ls" then
    local harper = require("plugins.lsp.harper_review")
    vim.api.nvim_buf_create_user_command(bufnr, "HarperReview", function(opts)
      harper.review(opts.args ~= "" and opts.args or nil)
    end, {
      nargs = "?",
      complete = harper.rules,
      desc = "Review Harper's problems from the cursor down",
    })
    wk.add({
      buffer = bufnr,
      { "<leader>cg", harper.review, desc = "Review grammar" },
    })
  end
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

return M
