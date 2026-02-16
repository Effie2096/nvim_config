return {
	{
		"akinsho/toggleterm.nvim",
		keys = {
			"<C-t>",
		},
		version = "*",
		opts = {
			open_mapping = [[<c-t>]],
			close_on_exit = false,
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			shade_terminals = false,
		},
	},
}
