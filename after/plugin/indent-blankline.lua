local has_ibl, ibl = pcall(require, "ibl")
if not has_ibl then
	return
end

local icons = require("faith.icons")

local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}

local hooks = require("ibl.hooks")
local mocha = require("catppuccin.palettes").get_palette("mocha")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = mocha.red })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = mocha.peach })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = mocha.sapphire })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = mocha.yellow })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = mocha.green })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = mocha.mauve })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = mocha.teal })
end)

ibl.setup({
	indent = {
		char = icons.characters.indent,
		smart_indent_cap = true,
		highlight = highlight,
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
