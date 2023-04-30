local nvim_tree_status, nvim_tree = pcall(require, 'nvim-tree')
if not nvim_tree_status then return end

nvim_tree.setup {
--  open_on_setup = true,
}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', opts)
keymap('n', '<leader>d', '<cmd>NvimTreeFindFile<cr>', opts)
