local neotest_status, neotest = pcall(require, 'neotest')
if not neotest_status then return end

local neotest_ns = vim.api.nvim_create_namespace 'neotest'
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      return message
    end,
  },
}, neotest_ns)

neotest.setup {
  adapters = {
    require 'neotest-go',
    require 'neotest-jest',
  },
}

local keymap = vim.keymap.set
local opts = { noremap = true }

keymap('n', '<leader>tn', '<cmd>lua require "neotest".run.run()<cr>', opts)
keymap('n', '<leader>tf', '<cmd>lua require "neotest".run.run(vim.fn.expand("%"))<cr>', opts)
