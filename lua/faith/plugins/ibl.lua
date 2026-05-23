local icons = require("faith.icons")

local ibl = require("ibl")
local highlights = {
	"NonText",
}
-- I only have this because it freaks out when switching themes
-- otherwise...
local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "NonText", { fg = "#af9d9e" })
	vim.api.nvim_set_hl(0, "Accent", { fg = "#af9d9e" })
end)

ibl.setup(
	---@module "ibl"
	---@type ibl.config
	{
		exclude = {
			filetypes = {
				"fugitive",
				-- "Avante",
				"AvanteSelectedFiles",
				"AvanteInput",
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
			highlight = "Accent",
		},
	}
)
