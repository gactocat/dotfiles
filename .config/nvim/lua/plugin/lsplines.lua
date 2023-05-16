local lsplines_status, lsplines = pcall(require, 'lsp_lines')
if not lsplines_status then return end

lsplines.setup {}
