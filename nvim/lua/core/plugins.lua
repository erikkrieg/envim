-- This module for loading plugins is inspired by plugin managers like Lazy.
-- The intention is implement a subset of Lazy's interface for loading, but not
-- installing, plugins.
local M = {}

-- Accepts options for loading a single plugins, or a list of plugin options.
M.load = function(opts)
  if opts.config ~= nil then
    opts.config()
  else
    for i, plugin in pairs(opts) do
      plugin.config()
    end
  end
end

-- Finds all lua files and directories at target path then requires and loads them
-- as a plugin. See M.load for details on how plugins are loaded.
M.loadAll = function(path)
  if not path then
    return
  end
  local files = vim.split(vim.fn.glob(path .. "/*"), "\n", { trimempty = true })
  local lua_files = {}
  for _, file in ipairs(files) do
    if vim.loop.fs_stat(file).type == "directory" or file:match("%.lua$") then
      table.insert(lua_files, file)
    end
  end
  for _, lua_file in ipairs(lua_files) do
    local file = string.match(lua_file, "[^/]+$"):gsub(".lua$", "")
    local plugins = require("plugins." .. file)
    M.load(plugins)
  end
end

return M
