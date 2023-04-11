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
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format()
  end
})

