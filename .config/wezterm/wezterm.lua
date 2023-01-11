local wezterm = require 'wezterm'

return {
    color_scheme = 'Gruvbox Dark',
    enable_tab_bar = false,
    font = wezterm.font_with_fallback {
        -- 'Hack Nerd Font Mono',
        'RobotoMono Nerd Font',
        -- 'mplus Nerd Font Mono',
    },
    font_size = 14,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
