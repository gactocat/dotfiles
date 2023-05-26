local noice_status, noice = pcall(require, 'noice')
if not noice_status then return end

noice.setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  -- options
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = false, -- long messages will be sent to a split
    inc_rnname = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap('n', '<leader>nn', '<cmd>Noice dismiss<cr>', opts)
keymap('n', '<leader>nl', '<cmd>Noice last<cr>', opts)
keymap('n', '<leader>ne', '<cmd>Noice errors<cr>', opts)
