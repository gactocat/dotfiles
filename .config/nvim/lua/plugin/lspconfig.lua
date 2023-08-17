local lspconfig_status, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status then return end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_status then return end

local mason_lspconfig_status, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_lspconfig_status then return end

mason_lspconfig.setup {
  ensure_installed = {
    'taplo',    -- toml
    'lua_ls',   -- lua
    'marksman', -- markdown
    'tsserver', -- ts
    'gopls',    -- go
  },
}

mason_lspconfig.setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = cmp_nvim_lsp.default_capabilities(),
      on_attach = function(_, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>j', function() vim.lsp.buf.format { async = true } end, bufopts)
      end,
    }
  end,
}

local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '●',
  },
  update_in_insert = true,
  float = {
    source = 'always',
  },
}
