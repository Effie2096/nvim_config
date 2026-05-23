require("faith.plugins.color.kanagawa")
require("faith.plugins.color.kanagawa-paper")
require("faith.plugins.color.nightfox")

require("auto-dark-mode").setup()

local themery = require("themery")
themery.setup({
	themes = {
		{
			name = "Kanagawa Wave",
			colorscheme = "kanagawa-wave",
			before = [[
				vim.opt.background = "dark"
			]],
		},
		{
			name = "Kanagawa Dragon",
			colorscheme = "kanagawa-dragon",
			before = [[
				vim.opt.background = "dark"
			]],
		},
		{
			name = "Kanagawa Lotus",
			colorscheme = "kanagawa-lotus",
			before = [[
				vim.opt.background = "light"
			]],
		},
		{
			name = "Kanagawa Ink",
			colorscheme = "kanagawa-paper-ink",
			before = [[
				vim.opt.background = "dark"
			]],
		},
		{
			name = "Kanagawa Canvas",
			colorscheme = "kanagawa-paper-canvas",
			before = [[
				vim.opt.background = "light"
			]],
		},
		{
			name = "Nightfox",
			colorscheme = "nightfox",
			before = [[
				vim.opt.background = "dark"
			]],
		},
		{
			name = "Nightfox Dayfox",
			colorscheme = "dayfox",
			before = [[
				vim.opt.background = "light"
			]],
		},
		{
			name = "Nightfox Dawnfox",
			colorscheme = "dawnfox",
			before = [[
				vim.opt.background = "light"
			]],
		},
		{
			name = "Nightfox Duskfox",
			colorscheme = "duskfox",
			before = [[
				vim.opt.background = "dark"
			]],
		},
		{
			name = "Nightfox Nordfox",
			colorscheme = "nordfox",
			before = [[
				vim.opt.background = "dark"
			]],
		},
		{
			name = "Nightfox Terafox",
			colorscheme = "terafox",
			before = [[
				vim.opt.background = "dark"
			]],
		},
		{
			name = "Nightfox Carbonfox",
			colorscheme = "carbonfox",
			before = [[
				vim.opt.background = "dark"
			]],
		},
	},
	livePreview = true,
})

-- default
vim.cmd.colorscheme("kanagawa-wave")
