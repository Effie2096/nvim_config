require("faith.plugins.color.kanagawa")
require("faith.plugins.color.nightfox")

vim.pack.add({
	{ src = "https://github.com/f-person/auto-dark-mode.nvim" },
}, {
	load = function(data)
		if vim.fn.executable("dbus-send") == 1 or vim.fn.has("win32") == 1 then
			vim.cmd.packadd("auto-dark-mode.nvim")
			require("auto-dark-mode").setup()
		end
	end,
})

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
