local wezterm = require("wezterm")

return {
	-- color_scheme = 'Gruvbox Dark',
	-- color_scheme = 'nightfox',
	color_scheme = "tokyonight",
	enable_tab_bar = false,
	font = wezterm.font_with_fallback({
		"RobotoMono Nerd Font",
		-- 'Hack Nerd Font Mono',
		-- 'SauceCodePro Nerd Font Mono',
		-- 'mplus Nerd Font Mono',
	}),
	font_size = 15,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	window_decorations = "RESIZE",
}
