local lspsaga_status, lspsaga = pcall(require, 'lspsaga')
if not lspsaga_status then return end

lspsaga.init_lsp_saga()

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', 'gh', '<cmd>Lspsaga lsp_finder<cr>', opts)
keymap({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<cr>', opts)
keymap('n', '<leader>rn', '<cmd>Lspsaga rename<cr>', opts)
keymap('n', 'gp', '<cmd>Lspsaga peek_definition<cr>', opts)
keymap('n', '<leader>cd', '<cmd>Lspsaga show_line_diagnostics<cr>', opts)
keymap('n', '<leader>cd', '<cmd>Lspsaga show_cursor_diagnostics<cr>', opts)
keymap('n', '[e', '<cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
keymap('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts)
keymap(
    'n',
    '[E',
    function() require('lspsaga.diagnostic').goto_prev { severity = vim.diagnostic.severity.ERROR } end,
    opts
)
keymap(
    'n',
    ']E',
    function() require('lspsaga.diagnostic').goto_next { severity = vim.diagnostic.severity.ERROR } end,
    opts
)
keymap('n', '<leader>o', '<cmd>Lspsaga outline<cr>', opts)
keymap('n', 'K', '<cmd>Lspsaga hover_doc<cr>', opts)
