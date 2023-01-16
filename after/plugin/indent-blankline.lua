-- ['│','|','¦','┆','┊','']

local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	return
end

local icons = require("faith.icons")

indent_blankline.setup({
	-- char = "│",
	-- context_char = "│",
	char_list = { icons.characters.indent },
	context_char_list = { icons.characters.indent_focus },
	--[[ char_list = {"│"},
	context_char_list = {"┃"}, ]]
	show_first_indent_level = true,
	show_trailing_blankline = true,
	use_treesitter = true,
	show_current_context = false,
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
