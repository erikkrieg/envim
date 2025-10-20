require("core.options")
require("core.plugins").loadAll(vim.g.plugin_config_dir)

require("core.autocmds")
require("core.keymaps")
