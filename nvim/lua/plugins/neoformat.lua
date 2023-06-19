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
  ft = file_extensions,
  config = function()
    local autocmd = vim.api.nvim_create_autocmd
    local function auto_neoformat(pattern)
      autocmd({ "BufWritePre" }, {
        pattern = pattern,
        callback = function()
          vim.api.nvim_command("Neoformat")
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
