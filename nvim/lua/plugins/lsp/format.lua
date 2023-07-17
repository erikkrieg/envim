local file_extensions = {
  "js",
  "lua",
  "md",
  "nix",
  "py",
  "rs",
  "sh",
  "yaml",
  "yml",
  "zsh",
}

return {
  "sbdchd/neoformat",
  lazy = false,
  config = function()
    vim.g.lsp_format = 1
    local autocmd = vim.api.nvim_create_autocmd
    local function auto_neoformat(pattern)
      autocmd({ "BufWritePre" }, {
        pattern = pattern,
        callback = function()
          if vim.g.lsp_format == 1 then
            vim.api.nvim_command("Neoformat")
          end
        end,
      })
    end

    for _, pattern in ipairs(file_extensions) do
      auto_neoformat("*." .. pattern)
    end

    vim.g.shfmt_opt = "-ci"
    -- look for prettier bin in node_modules
    vim.g.neoformat_try_node_exe = 1
  end,
}
