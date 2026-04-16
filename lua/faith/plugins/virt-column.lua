local icons = require("faith.icons")

return {
	{
		"lukas-reineke/virt-column.nvim",
		events = "VeryLazy",
		opts = {
			char = icons.characters.indent,
			highlight = { "VirtColumn", "NonText" },
		},
	},
}
