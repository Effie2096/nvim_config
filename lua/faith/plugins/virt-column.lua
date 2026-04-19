local icons = require("faith.icons")

return {
	{
		"lukas-reineke/virt-column.nvim",
		events = "BufWinEnter",
		opts = {
			char = icons.characters.indent,
			highlight = { "VirtColumn", "NonText" },
		},
	},
}
