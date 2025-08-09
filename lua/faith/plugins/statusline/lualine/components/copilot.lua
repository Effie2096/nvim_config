return {
	"copilot",
	-- Default values
	symbols = {
		status = {
			icons = {
				enabled = " ",
				sleep = " ", -- auto-trigger disabled
				disabled = " ",
				warning = " ",
				unknown = " ",
			},
			hl = {
				enabled = require("copilot-lualine.colors").get_hl_value(
					0,
					"DiagnosticCheck",
					"fg"
				),
				sleep = require("copilot-lualine.colors").get_hl_value(
					0,
					"WinBar",
					"fg"
				),
				disabled = require("copilot-lualine.colors").get_hl_value(
					0,
					"NonText",
					"fg"
				),
				warning = require("copilot-lualine.colors").get_hl_value(
					0,
					"DiagnosticWarn",
					"fg"
				),
				unknown = require("copilot-lualine.colors").get_hl_value(
					0,
					"DiagnosticError",
					"fg"
				),
			},
		},
		spinners = "dots", -- has some premade spinners
		spinner_color = "#6272A4",
	},
	color = "WinBar",
	show_colors = true,
	show_loading = true,
	separator = "",
	padding = { left = 1, right = 0 },
}
