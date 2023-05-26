local trouble_status, trouble = pcall(require, 'trouble')
if not trouble_status then return end

trouble.setup {}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<leader>xx', '<cmd>TroubleToggle<cr>', opts)
keymap('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', opts)
keymap('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', opts)
keymap('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>', opts)
keymap('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', opts)
keymap('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>', opts)
