local wezterm = require 'wezterm'

return {
  color_scheme = 'tokyonight',
  colors = {
    background = '#181818',
  },

  hide_tab_bar_if_only_one_tab = true,
  hide_mouse_cursor_when_typing = true,

  font = wezterm.font_with_fallback {
    'RobotoMono Nerd Font',
    -- 'Hack Nerd Font Mono',
    -- 'SauceCodePro Nerd Font Mono',
  },
  font_size = 13,

  keys = {
    { key = '/', mods = 'CTRL', action = wezterm.action.SendString '\x1f' },
  },

  window_decorations = 'RESIZE',
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },
  window_background_opacity = 0.8,
  macos_window_background_blur = 10,
}
