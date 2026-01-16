local icons = require("faith.icons")

return {
	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
		opts = {
			match_types = {
				space = true,
				tab = true,
				nbsp = true,
				lead = false,
				trail = true,
			},
			list_chars = {
				space = icons.characters.space,
				tab = icons.characters.tab,
				nbsp = icons.characters.nbsp,
				lead = icons.characters.precedes,
				trail = icons.characters.trail,
			},
			fileformat_chars = {
				unix = icons.characters.eol,
				mac = icons.characters.eol,
				dos = icons.characters.eol,
			},
		},
	},
}
