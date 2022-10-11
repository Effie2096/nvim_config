vim.opt.termguicolors = true

vim.opt.list = true
local empty_chars = { eol = ' ', tab = '  ', trail = '×', space = ' ', extends = ' ', precedes = ' ', nbsp = ' ' }
local listchars = { eol = '﬋', tab = '▸▸', trail = '×', space = '•', extends = '›', precedes = '‹', nbsp = '␣' }
vim.opt.listchars = empty_chars
-- vim.opt.listchars:append("eol = '﬋', tab = '»»', space = '•'")
--▸▸﬋
-- ['│','|','¦','┆','┊','']

local status_ok, indent_blankline = pcall(require, 'indent_blankline')
if not status_ok then
	return
end

indent_blankline.setup({
	-- char = "│",
	-- context_char = "│",
	char_list = { "▏" },
	context_char_list = { "▎" },
	--[[ char_list = {"│"},
	context_char_list = {"┃"}, ]]
	show_first_indent_level = true,
	show_trailing_blankline = true,
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
		"text"
	}
})
