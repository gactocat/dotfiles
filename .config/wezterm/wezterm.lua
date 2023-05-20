local wezterm = require 'wezterm'

return {
  -- color_scheme = 'Gruvbox Dark',
  color_scheme = 'nightfox',
  enable_tab_bar = false,
  font = wezterm.font_with_fallback {
    'RobotoMono Nerd Font',
    -- 'Hack Nerd Font Mono',
    -- 'SauceCodePro Nerd Font Mono',
    -- 'mplus Nerd Font Mono',
  },
  font_size = 14,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_decorations = 'RESIZE'
}
