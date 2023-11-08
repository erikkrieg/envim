require("core.options")
require("core.plugins").loadAll(vim.g.plugin_config_dir)

-- Todo: Create "VeryLazy" event to load these on
require("core.autocmds")
require("core.keymaps")
