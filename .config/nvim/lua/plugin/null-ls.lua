local null_ls_status, null_ls = pcall(require, 'null-ls')
if not null_ls_status then return end

local mason_null_ls_status, mason_null_ls = pcall(require, 'mason-null-ls')
if not mason_null_ls_status then return end

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

null_ls.setup {
  on_attach = function(current_client, bufnr)
    if current_client.supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      -- comment out this block to opt out of auto format
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format {
            filter = function(client) return client.name == 'null-ls' end,
            bufnr = bufnr,
          }
        end,
      })
    end
  end,
}

mason_null_ls.setup {
  ensure_installed = {
    'stylua', -- lua
    'jq', -- json
    'prettier', -- js/ts
    'gofumpt', -- go
    'goimports',
    'golangci_lint',
  },
  automatic_setup = true,
}
mason_null_ls.setup_handlers()
