local cmp = require'cmp'
local lspkind = require('lspkind')

-- Used by formatter
local source_mapping = {
  buffer = '[Buffer]',
  nvim_lsp = '[LSP]',
  nvim_lua = "[Lua]",
  cmp_tabnine = '[TN]',
  cmdline = '[Cmd]',
  path = "[Path]",
}

local formatTabnine = function(entry, vim_item)
  vim_item.kind = lspkind.presets.default[vim_item.kind]
  print(entry.source.name)
  local menu = source_mapping[entry.source.name]
  if entry.source.name == 'cmp_tabnine' then
    if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
      menu = entry.completion_item.data.detail .. ' ' .. menu
    end
    vim_item.kind = ''
  end
  vim_item.menu = menu
  return vim_item
end

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'cmp_tabnine' },
    { name = 'cmdline' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
		-- format = formatTabnineAdvanced
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 200,
      before = formatTabnine,
    })
	},
})


-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Tabnine AI completions
local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
  show_prediction_strength = true,
	snippet_placeholder = "..",
})
