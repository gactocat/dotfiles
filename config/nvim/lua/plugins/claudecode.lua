return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = true,
  opts = {
    terminal = {
      split_width_percentage = 0.45,
      -- split_side = 'right',
      -- provider = 'auto',
    },
    track_selection = true,
  },
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode --allow-dangerously-skip-permissions<cr>', desc = 'Toggle Claude' },
  },
}
