local telekasten_status, telekasten = pcall(require, 'telekasten')
if not telekasten_status then return end

local home = vim.fn.expand '~/zettelkasten'

telekasten.setup {
  home = home,
  take_over_my_home = true,
  auto_set_filetype = true,

  dailies = home .. '/' .. 'daily',
  weeklies = home .. '/' .. 'weekly',
  templates = home .. '/' .. 'templates',

  new_note_filename = 'title',

  uuid_type = '%Y%m%d%H%M',
  uuid_sep = '-',

  follow_creates_nonexisting = true,
  dailies_create_nonexisting = true,
  weeklies_create_nonexisting = true,

  journal_auto_open = false,

  template_new_note = home .. '/' .. 'templates/new_note.md',
  template_new_daily = home .. '/' .. 'templates/daily.md',
  template_new_weekly = home .. '/' .. 'templates/weekly.md',

  image_link_style = 'markdown',

  sort = 'filename',

  plug_into_calendar = true,
  calendar_opts = {
    weeknm = 4,
    calendar_monday = 1,
    calendar_mark = 'left-fit',
  },

  close_after_yanking = false,
  insert_after_inserting = true,

  tag_notation = '#tag',
  command_palette_theme = 'ivy',
  show_tags_theme = 'ivy',

  subdirs_in_links = true,

  template_handling = 'smart',
  new_note_location = 'smart',

  rename_update_links = true,

  media_previewer = 'telescope-media-files',
  follow_url_fallback = nil,
}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<leader>zf', '<cmd>lua require "telekasten".find_notes()<cr>', opts)
keymap('n', '<leader>zd', '<cmd>lua require "telekasten".find_daily_notes()<cr>', opts)
keymap('n', '<leader>zw', '<cmd>lua require "telekasten".find_weekly_notes()<cr>', opts)
keymap('n', '<leader>zg', '<cmd>lua require "telekasten".search_notes()<cr>', opts)
keymap('n', '<leader>zz', '<cmd>lua require "telekasten".follow_link()<cr>', opts)
keymap('n', '<leader>z', '<cmd>lua require "telekasten".panel()<cr>', opts)

keymap('n', '<leader>zp', '<cmd>MarkdownPreview<cr>', opts)
