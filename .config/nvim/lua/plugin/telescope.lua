local telescope_status, telescope = pcall(require, 'telescope')
if not telescope_status then return end

telescope.setup {}

local keymap = vim.keymap.set
local builtin = require 'telescope.builtin'
local opts = { noremap = true, silent = true }

keymap('n', '<leader>ff', builtin.find_files, opts)
keymap('n', '<leader>fg', builtin.live_grep, opts)
keymap('n', '<leader>fd', builtin.grep_string, opts)
keymap('n', '<leader>fb', builtin.buffers, opts)
keymap('n', '<leader>fh', builtin.help_tags, opts)
keymap('n', '<leader>fs', builtin.git_status, opts)
keymap('n', '<leader>fv', builtin.git_files, opts)
