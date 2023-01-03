local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '

-- normal mode
keymap('n', '<C-q>', '<C-w>q', opts)
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

keymap('n', '<S-Left>', '2<C-w><', opts)
keymap('n', '<S-Right>', '2<C-w>>', opts)
keymap('n', '<S-Up>', '2<C-w>-', opts)
keymap('n', '<S-Down>', '2<C-w>+', opts)

keymap('n', '<A-Up>', '<Esc><cmd>m .-2<cr>', opts)
keymap('n', '<A-Down>', '<Esc><cmd>m .+1<cr>', opts)

-- visual mode
keymap('v', '>', '>gv', opts)
keymap('v', '<', '<gv', opts)

keymap('v', 'c', [['_c]], opts)
keymap('v', 'p', [['_dP]], opts)

-- terminal
keymap('t', '<C-q>', '<C-w>q', opts)
keymap('t', '<esc>', [[<C-\><C-n>]], opts)
