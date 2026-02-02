local icons = require("faith.icons")

return {
	{
		"lukas-reineke/virt-column.nvim",
		opts = {
			char = icons.characters.indent,
			highlight = { "VirtColumn", "Comment" },
		},
	},
}
