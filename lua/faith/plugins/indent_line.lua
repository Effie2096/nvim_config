local icons = require("faith.icons")

local highlights = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}

return {
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		main = "ibl",
		opts = function()
			-- I only have this because it freaks out when switching themes
			-- otherwise...
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			---@module "ibl"
			---@type ibl.config
			return {
				exclude = {
					filetypes = {
						"fugitive",
						-- "Avante",
						"AvanteSelectedFiles",
						"AvanteInput",
						"markdown",
					},
				},
				indent = {
					char = icons.characters.indent,
					smart_indent_cap = true,
					repeat_linebreak = true,
					highlight = highlights,
				},
				whitespace = {
					highlight = highlights,
					remove_blankline_trail = false,
				},
				scope = {
					enabled = true,
					show_start = true,
					show_end = true,
					char = icons.characters.indent_focus,
				},
			}
		end,
	},
}
