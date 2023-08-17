local null_ls_status, null_ls = pcall(require, 'null-ls')
if not null_ls_status then return end

local mason_null_ls_status, mason_null_ls = pcall(require, 'mason-null-ls')
if not mason_null_ls_status then return end

null_ls.setup {
  -- cf. https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  sources = {
    null_ls.builtins.completion.luasnip, -- all
    null_ls.builtins.completion.spell, -- all
    null_ls.builtins.code_actions.refactoring, -- go, js, ts, lua, python
    null_ls.builtins.formatting.stylua, -- lua
    null_ls.builtins.diagnostics.eslint, -- js, ts
    null_ls.builtins.formatting.prettier, -- js, ts, html, css, json, yaml, etc...
    null_ls.builtins.formatting.gofumpt, -- go
    null_ls.builtins.diagnostics.golangci_lint, -- go
    null_ls.builtins.formatting.goimports, -- go
  },
}

mason_null_ls.setup {
  ensure_installed = nil,
  automatic_installation = true,
}
