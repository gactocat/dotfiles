return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = true,
  opts = {
    terminal = {
      split_side = 'right',
      split_width_percentage = 0.30,
      provider = 'auto',
    },
    track_selection = true,
  },
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode --dangerously-skip-permissions<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    { '<leader>aa', '<cmd>ClaudeCodeAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeReject<cr>', desc = 'Reject diff' },
  },
}
