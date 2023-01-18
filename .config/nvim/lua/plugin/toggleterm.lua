local toggleterm_status, toggleterm = pcall(require, 'toggleterm')
if not toggleterm_status then return end

toggleterm.setup {
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  close_on_exit = true,
}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<C-w>t', '<cmd>exe v:count1 . "ToggleTerm"<cr>', opts)
keymap('n', '<C-w>g', '<cmd>lua _G.toggle_gitui()<cr>', opts)

_G.toggle_gitui = function()
  if term_gitui == nil then
    _G.term_gitui = require('toggleterm.terminal').Terminal:new {
      cmd = 'gitui',
      direction = 'float',
      hidden = true,
    }
  end
  term_gitui:toggle()
end
