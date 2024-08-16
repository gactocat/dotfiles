return {
  'CopilotC-Nvim/CopilotChat.nvim',
  opts = function()
    local user = vim.env.USER or 'User'
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      model = 'gpt-4o',
      auto_insert_mode = true,
      show_help = true,
      question_header = '  ' .. user .. ' ',
      answer_header = '  Copilot ',
      window = {
        width = 0.4,
      },
      selection = function(source)
        local select = require 'CopilotChat.select'
        return select.visual(source) or select.buffer(source)
      end,
    }
  end,
}
