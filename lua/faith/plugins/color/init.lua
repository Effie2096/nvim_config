require("faith.plugins.color.kanagawa")
require("faith.plugins.color.kanso")
require("faith.plugins.color.nightfox")

local themery = require("themery")
themery.setup({
	themes = {
		{
			name = "Kanagawa Wave",
			colorscheme = "kanagawa-wave",
		},
		{
			name = "Kanagawa Dragon",
			colorscheme = "kanagawa-dragon",
		},
		{
			name = "Kanagawa Lotus",
			colorscheme = "kanagawa-lotus",
		},
		{
			name = "Kanso Zen",
			colorscheme = "kanso-zen",
		},
		{
			name = "Kanso Ink",
			colorscheme = "kanso-ink",
		},
		{
			name = "Kanso Mist",
			colorscheme = "kanso-mist",
		},
		{
			name = "Kanso Pearl",
			colorscheme = "kanso-pearl",
		},
		{
			name = "Nightfox",
			colorscheme = "nightfox",
		},
		{
			name = "Nightfox Dayfox",
			colorscheme = "dayfox",
		},
		{
			name = "Nightfox Dawnfox",
			colorscheme = "dawnfox",
		},
		{
			name = "Nightfox Duskfox",
			colorscheme = "duskfox",
		},
		{
			name = "Nightfox Nordfox",
			colorscheme = "nordfox",
		},
		{
			name = "Nightfox Terafox",
			colorscheme = "terafox",
		},
		{
			name = "Nightfox Carbonfox",
			colorscheme = "carbonfox",
		},
	},
	livePreview = true,
})

-- default
vim.cmd.colorscheme("kanagawa-wave")
