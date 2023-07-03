local function install()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local function setup()
  require("lazy").setup("plugins", {
    defaults = { lazy = true, version = nil },
    install = { missing = true, colorscheme = { "tokyonight" } },
    checker = { enabled = true },
    performance = {
      rtp = {
        disabled_plugins = {
          -- "matchparen", -- Highlighting matching parens (only available if `compatible` is not set)
          -- "netrwPlugin", -- Built-in file explorer plugin
          "matchit", -- Pressing the % key while on various keywords will move the cursor to its match
          "tohtml", -- Convert diff into HTML
          "gzip", -- Installs autocommands to intercept reading and writing of certain compressed files
          "tarPlugin", -- Display contents of tar files while editing
          "zipPlugin", -- Display contents of zip files while editing
          "tutor", -- Tutorial plugin
        },
      },
    },
  })
  vim.keymap.set(
    "n",
    "<leader>p",
    "<cmd>:Lazy<cr>",
    { desc = "Plugin Manager" }
  )
end

install()
setup()
