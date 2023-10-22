local has_indent_blankline, indent_blankline = pcall(require, "indent_blankline")
if not has_indent_blankline then
	return
end

local icons = require("faith.icons")

indent_blankline.setup({
	--[[ enabled = true,
	indent = {
		char = icons.characters.indent,
		smart_indent_cap = true,
		highlight = { "Function" },
	},
	scope = {
		enabled = true,
		show_start = false,
		show_end = false,
		char = icons.characters.indent_focus,
	}, ]]
	-- char = "│",
	-- context_char = "│",
	char_list = { icons.characters.indent },
	context_char_list = { icons.characters.indent_focus },
	--[[ char_list = {"│"},
	context_char_list = {"┃"}, ]]
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
	},
})
