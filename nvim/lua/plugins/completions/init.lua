return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-cmdline" },
      { "onsails/lspkind-nvim" },
      { "tzachar/cmp-tabnine", build = "./install.sh" },
      { "windwp/nvim-autopairs", opts = {} },
    },
    config = function()
      require("nvim-autopairs").setup({})
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      -- Used by formatter
      local source_mapping = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        cmp_tabnine = "[TN]",
        cmdline = "[Cmd]",
        path = "[Path]",
        copilot = "[Copilot]",
      }

      local function formatTabnine(entry, vim_item)
        vim_item.kind = lspkind.presets.default[vim_item.kind]
        local menu = source_mapping[entry.source.name]
        if entry.source.name == "cmp_tabnine" then
          local data = entry.completion_item.data
          if data ~= nil and data.detail ~= nil then
            menu = data.detail .. " " .. menu
          end
          vim_item.kind = ""
        end
        if entry.source.name == "copilot" then
          vim_item.kind = ""
        end
        vim_item.menu = menu
        return vim_item
      end

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm(),
          ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(
            cmp.mapping.select_prev_item(),
            { "i", "s" }
          ),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "cmp_tabnine" },
          { name = "copilot", group_index = 2 },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            max_width = 200,
            before = formatTabnine,
          }),
        },
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline", keyword_length = 2 },
        }),
      })

      -- Tabnine AI completions
      local tabnine = require("cmp_tabnine.config")
      tabnine:setup({
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        show_prediction_strength = true,
        snippet_placeholder = "",
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    config = function()
      require("luasnip.loaders.from_vscode").load()
      require("luasnip").setup({
        keep_roots = true,
        link_roots = true,
        link_children = true,
        delete_check_events = "TextChanged",
      })
    end,
  },
}
