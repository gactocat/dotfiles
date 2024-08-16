local wezterm = require("wezterm")

return {
	-- color_scheme = 'Gruvbox Dark',
	-- color_scheme = "nightfox",
	color_scheme = "tokyonight",
	colors = {
		background = "#202020",
	},
	-- enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	hide_mouse_cursor_when_typing = true,
	default_cursor_style = "SteadyBlock",
	font = wezterm.font_with_fallback({
		"RobotoMono Nerd Font",
		-- 'Hack Nerd Font Mono',
		-- 'SauceCodePro Nerd Font Mono',
		-- 'mplus Nerd Font Mono',
	}),
	font_size = 13,
	keys = {
		{ key = "/", mods = "CTRL", action = wezterm.action.SendString("\x1f") },
	},
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	window_decorations = "RESIZE",
	window_background_opacity = 0.9,
	macos_window_background_blur = 16,
}
