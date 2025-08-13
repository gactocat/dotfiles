local map = vim.keymap.set

map('n', '<S-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<S-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<S-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })
map('n', '<S-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<c-q>', '<c-w>q', { desc = 'Close window' })

-- claude command
if vim.fn.executable 'claude' == 1 then
  map(
    'n',
    '<leader>cc',
    function() Snacks.terminal({ 'claude', '--dangerously-skip-permissions' }, { cwd = LazyVim.root() }) end,
    { desc = 'Claude CLI' }
  )
  map(
    'n',
    '<leader>cC',
    function() Snacks.terminal({ 'claude', '--dangerously-skip-permissions', '--continue' }, { cwd = LazyVim.root() }) end,
    { desc = 'Claude CLI' }
  )
end
