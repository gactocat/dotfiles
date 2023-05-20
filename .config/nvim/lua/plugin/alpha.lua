local alpha_status, alpha = pcall(require, 'alpha')
if not alpha_status then return end

local dashboard_status, dashboard = pcall(require, 'alpha.themes.dashboard')
if not dashboard_status then return end

dashboard.section.header.val = {
  [[                                                 ]],
  [[                                                 ]],
  [[                                                 ]],
  [[                               __                ]],
  [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}
dashboard.section.buttons.val = {
  dashboard.button('e', '  New file', ':ene <bar> startinsert <cr>'),
  dashboard.button('SPC e', '  File explorer'),
  dashboard.button('SPC f f', '󰈞 Find file'),
  dashboard.button('SPC f g', '  Find word'),
  dashboard.button('SPC f c', '  Changed files'),
  dashboard.button('q', '  Quit', ':qa<cr>'),
}
local handle = io.popen 'fortune'
local fortune = handle:read '*a'
handle:close()
dashboard.section.footer.val = fortune

dashboard.config.opts.noautocmd = true

vim.cmd [[autocmd User AlphaReady]]

alpha.setup(dashboard.config)
