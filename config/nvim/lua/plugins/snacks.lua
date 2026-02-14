return {
  'folke/snacks.nvim',
  dependencies = { 'MaximilianLloyd/ascii.nvim' },
  opts = function()
    local ascii = require 'ascii'
    return {
      dashboard = {
        preset = {
          header = table.concat(ascii.art.text.neovim.sharp, '\n'),
        },
      },
    }
  end,
}
