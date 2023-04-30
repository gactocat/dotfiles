local bufferline_status, bufferline = pcall(require, 'bufferline')
if not bufferline_status then return end

bufferline.setup {
  options = {
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true -- use a "true" to enable the default, or set your own character
      }
    }
  }
}

local keymap = vim.keymap.set

keymap('n', '[b', '<cmd>BufferLineCyclePrev<cr>')
keymap('n', ']b', '<cmd>BufferLineCycleNext<cr>')
keymap('n', '[B', '<cmd>BufferLineMovePrev<cr>')
keymap('n', ']B', '<cmd>BufferLineMoveNext<cr>')
