local has_ibl, ibl = pcall(require, "ibl")
if not has_ibl then
	return
end

local icons = require("faith.icons")

ibl.setup({
	indent = {
		char = icons.characters.indent,
		smart_indent_cap = true,
	},
	scope = {
		char = icons.characters.indent_focus,
	},
	--[[ char_list = { icons.characters.indent },
	context_char_list = { icons.characters.indent_focus },
	show_first_indent_level = true,
	show_trailing_blankline = false,
	use_treesitter = true,
	show_current_context = true,
	show_current_context_start = false,

	buftype_exclude = { "terminal", "nofile", "startify", "help", "plugins", "NvimTree" },
	filetype_exclude = {
		"help",
		"startify",
		"dashboard",
		"packer",
		"neogitstatus",
		"NvimTree",
		"Trouble",
		"text",
	}, ]]
})
