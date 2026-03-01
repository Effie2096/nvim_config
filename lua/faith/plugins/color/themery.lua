local themes = {
	-- Dark
	dark = {
		{
			name = "Eldritch Darker",
			colorscheme = "eldritch-dark",
		},
		{
			name = "Eldritch Default",
			colorscheme = "eldritch",
		},
		{
			name = "Kanagawa Dragon",
			colorscheme = "kanagawa-dragon",
		},
		{
			name = "Catppuccin Mocha",
			colorscheme = "catppuccin-mocha",
		},
		{
			name = "Tokyo Night",
			colorscheme = "tokyonight-night",
		},
		{
			name = "TokyoDark",
			colorscheme = "tokyodark",
		},
		{
			name = "Nightfox Carbon",
			colorscheme = "carbonfox",
		},
		{
			name = "Monokai Spectrum",
			colorscheme = "monokai-pro-spectrum",
		},
		{
			name = "Matrix",
			colorscheme = "matrix",
		},
		{
			name = "Midnight",
			colorscheme = "midnight",
		},
		{
			name = "Yorumi Abyss",
			colorscheme = "yorumi",
		},
	},
	-- Light
	light = {
		{
			name = "Catppuccin Latte",
			colorscheme = "catppuccin-latte",
		},
		{
			name = "Tokyo Day",
			colorscheme = "tokyonight-day",
		},
		{
			name = "Monokai Light",
			colorscheme = "monokai-pro-light",
		},
		{
			name = "Nightfox Day",
			colorscheme = "dayfox",
		},
		{
			name = "Sakura Light",
			colorscheme = "sakura",
		},
		{
			name = "Kanagawa Lotus",
			colorscheme = "kanagawa-lotus",
		},
	},
	color = {
		{
			name = "Kanagawa Wave",
			colorscheme = "kanagawa-wave",
		},
		{
			name = "Monokai Pro",
			colorscheme = "monokai-pro-default",
		},
		{
			name = "Monokai Octagon",
			colorscheme = "monokai-pro-octagon",
		},
		{
			name = "Monokai Machine",
			colorscheme = "monokai-pro-machine",
		},
		{
			name = "Monokai Ristretto",
			colorscheme = "monokai-pro-ristretto",
		},
		{
			name = "Monokai Classic",
			colorscheme = "monokai-pro-classic",
		},
	},
}

local function setBackground(theme, background)
	return vim.tbl_extend(
		"keep",
		theme,
		{ before = [[vim.o.background = "]] .. background .. [["]] }
	)
end

themes.dark = vim
	.iter(themes.dark)
	:map(function(theme)
		return setBackground(theme, "dark")
	end)
	:totable()
themes.color = vim
	.iter(themes.color)
	:map(function(theme)
		return setBackground(theme, "dark")
	end)
	:totable()
themes.light = vim
	.iter(themes.light)
	:map(function(theme)
		return setBackground(theme, "light")
	end)
	:totable()

return themes
