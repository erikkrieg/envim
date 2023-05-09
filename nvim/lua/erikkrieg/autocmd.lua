local autocmd = vim.api.nvim_create_autocmd

autocmd({"CursorHold"}, {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end
})

autocmd({"BufWritePre"}, {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.formatting_sync(nil, 200)
  end
})

autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.formatting_sync(nil, 200)
  end
})

autocmd({"BufWritePre"}, {
  pattern = "*.py",
  callback = function()
    -- Can be combined with yapf
    vim.api.nvim_command("Neoformat")
    -- The builtin buf format wasn't working. I'd get this error:
    -- "Format request failed, no matching language servers."
    -- vim.lsp.buf.format()
  end
})
