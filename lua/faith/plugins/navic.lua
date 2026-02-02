local icons = require("faith.icons")
local kinds = vim.deepcopy(icons.kind)
vim.list_extend(kinds, { enabled = true })

return {
	"SmiteshP/nvim-navic",
	lazy = true,
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	opts = {
		icons = kinds,
		separator = icons.ui.ChevronRight .. " ",
		safe_output = false,
		highlight = true,
	},
}
