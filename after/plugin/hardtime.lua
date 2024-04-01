local has_hardtime, hardtime = pcall(require, "hardtime")
if not has_hardtime then
	return
end

local config = require("hardtime.config").config

local disabled_filetypes = config.disabled_filetypes

hardtime.setup({
	disabled_keys = {
		["<Up>"] = {},
		["<Down>"] = {},
		["<Left>"] = {},
		["<Right>"] = {},
	},
	disabled_filetypes = vim.list_extend(disabled_filetypes, { "fugitive" }),
})
