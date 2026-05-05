local icons = require("faith.icons")

local ibl = require("ibl")
local highlights = {
	"NonText",
}

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
		},
	}
)
