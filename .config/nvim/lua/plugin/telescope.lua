local telescope_status, telescope = pcall(require, 'telescope')
if not telescope_status then return end

local trouble_status, trouble = pcall(require, 'trouble.providers.telescope')
if not trouble_status then return end

telescope.setup {
  defaults = {
    mappings = {
      i = { ['<c-t>'] = trouble.open_with_trouble },
      n = { ['<c-t>'] = trouble.open_with_trouble },
    },
  },
}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local builtin = require 'telescope.builtin'
keymap('n', '<leader>ff', builtin.find_files, opts)
keymap('n', '<leader>fg', builtin.live_grep, opts)
keymap('n', '<leader>fd', builtin.grep_string, opts)
keymap('n', '<leader>fb', builtin.buffers, opts)
keymap('n', '<leader>fm', builtin.marks, opts)
keymap('n', '<leader>fh', builtin.help_tags, opts)
keymap('n', '<leader>fc', builtin.git_status, opts)
keymap('n', '<leader>fj', builtin.jumplist, opts)
keymap('n', '<leader>fv', builtin.git_files, opts)
keymap('n', '<leader>fn', telescope.extensions.notify.notify, opts)
