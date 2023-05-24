local autocmd = vim.api.nvim_create_autocmd

local function auto_neoformat(pattern)
  autocmd({ "BufWritePre" }, {
    pattern = pattern,
    callback = function()
      vim.api.nvim_command("Neoformat")
    end,
  })
end

for _, pattern in ipairs({ "*.rs", "*.py", "*.js", "*.lua", "*.nix" }) do
  auto_neoformat(pattern)
end

autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.formatting_sync(nil, 200)
  end,
})

autocmd({ "VimEnter" }, {
  pattern = "*",
  callback = function()
    -- One of my hosts has an elusive bug that causes color scheme to change.
    -- This is a hacky solution that seems to use in the meantime.
    vim.cmd([[colorscheme tokyonight-storm]])
  end,
})
