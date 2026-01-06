return {
  {
    'natecraddock/workspaces.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    cmd = {
      'WorkspacesAdd',
      'WorkspacesAddDir',
      'WorkspacesRemove',
      'WorkspacesList',
      'WorkspacesOpen',
    },
    keys = {
      { '<leader>fw', '<cmd>Telescope workspaces<cr>', desc = 'Workspaces' },
    },
    config = function()
      require('workspaces').setup {
        hooks = {
          open = function() Snacks.explorer() end,
        },
      }
      require('telescope').load_extension 'workspaces'
    end,
  },
  {
    'nvim-telescope/telescope-ghq.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'natecraddock/workspaces.nvim',
    },
    keys = {
      {
        '<leader>fG',
        function()
          require('telescope').extensions.ghq.list {
            attach_mappings = function(_, map)
              local actions = require 'telescope.actions'
              local action_state = require 'telescope.actions.state'
              map('i', '<CR>', function(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local path = entry.value
                local name = vim.fn.fnamemodify(path, ':t')
                require('workspaces').add(path, name)
                require('workspaces').open(name)
              end)
              return true
            end,
          }
        end,
        desc = 'Ghq repositories (add to workspace)',
      },
      { '<leader>fg', '<cmd>Telescope ghq list<cr>', desc = 'Ghq repositories' },
    },
    config = function() require('telescope').load_extension 'ghq' end,
  },
}
