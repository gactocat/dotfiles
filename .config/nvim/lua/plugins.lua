local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system {
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    }
    pcall(vim.cmd, 'packadd packer.nvim')
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- packer manage itself

  -- base
  use 'EdenEast/nightfox.nvim' -- colorscheme
  use 'nvim-lua/plenary.nvim' -- common utility
  use 'nvim-lua/popup.nvim' -- common utility
  use 'antoinemadec/FixCursorHold.nvim' -- common utility
  use 'MunifTanjim/nui.nvim' -- UI component library
  use 'rcarriga/nvim-notify' -- notifier
  use 'nvim-tree/nvim-web-devicons' -- icon set

  -- editor
  use 'petertriho/nvim-scrollbar' -- scrollbar
  use 'windwp/nvim-autopairs' -- autopairs
  use 'kevinhwang91/nvim-hlslens' -- hlsearch lens

  -- IDE
  use 'goolord/alpha-nvim' -- startup
  use 'nvim-tree/nvim-tree.lua' -- file explorer
  use 'nvim-lualine/lualine.nvim' -- status line
  use 'akinsho/bufferline.nvim' -- file tab
  use 'akinsho/toggleterm.nvim' -- terminal
  use 'nvim-telescope/telescope.nvim' -- fuzzy finder
  use 'williamboman/mason.nvim' -- manage LSP servers, DAP servers, linters, and formatters
  use 'folke/noice.nvim' -- UI for the message

  -- Git
  use 'lewis6991/gitsigns.nvim' -- signs for changed lines
  use 'dinhhuy258/git.nvim' -- git wrapper

  -- LSP
  use 'neovim/nvim-lspconfig' -- LSP client
  use 'williamboman/mason-lspconfig.nvim' -- extension to mason and provide command `:LSPInstall`
  use 'glepnir/lspsaga.nvim' -- highly performant UI for LSP
  use 'onsails/lspkind-nvim' -- pictograms for LSP completion items
  use 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

  -- completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp'

  -- snipet
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Copilot
  use 'github/copilot.vim'

  -- Test
  use 'nvim-neotest/neotest'
  use 'nvim-neotest/neotest-go'
  use 'haydenmeade/neotest-jest'

  -- syntax highlight
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update { with_sync = true } end,
  }

  -- linter and formatter
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'jayp0521/mason-null-ls.nvim'

  -- dap
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'leoluz/nvim-dap-go'
  use 'jayp0521/mason-nvim-dap.nvim'

  -- note taking
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
  }
  use 'renerocksai/telekasten.nvim'
  use 'ekickx/clipboard-image.nvim'

  if packer_bootstrap then require('packer').sync() end
end)
