return {
  'subnut/nvim-ghost.nvim',
  config = function()
    vim.api.nvim_create_augroup('nvim_ghost_user_autocommands', { clear = true })
    vim.api.nvim_create_autocmd('User', {
      pattern = {
        '*github.com',
        '*esa.io',
      },
      group = 'nvim_ghost_user_autocommands',
      callback = function() vim.opt.filetype = 'markdown' end,
    })
  end,
}
