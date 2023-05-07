local cmp_status, cmp = pcall(require, 'cmp')
if not cmp_status then return end

local luasnip_status, luasnip = pcall(require, 'luasnip')
if not luasnip_status then return end

local lspkind_status, lspkind = pcall(require, 'lspkind')
if not lspkind_status then return end

cmp.setup {
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },

  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  {
    { name = 'buffer' },
  },

  formatting = {
    format = lspkind.cmp_format {
      maxwidth = 50,
      ellipsis_char = '...',
    },
  },
}

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
