return {
	{
		"mrjones2014/smart-splits.nvim",
		opts = {},
		config = function()
			vim.keymap.set(
				"n",
				"<S-Left>",
				require("smart-splits").resize_left,
				{ desc = "Resize window Left" }
			)
			vim.keymap.set(
				"n",
				"<S-Down>",
				require("smart-splits").resize_down,
				{ desc = "Resize window Down" }
			)
			vim.keymap.set(
				"n",
				"<S-Up>",
				require("smart-splits").resize_up,
				{ desc = "Resize window Up" }
			)
			vim.keymap.set(
				"n",
				"<S-Right>",
				require("smart-splits").resize_right,
				{ desc = "Resize window Right" }
			)
			-- moving between splits
			vim.keymap.set(
				"n",
				"<M-Left>",
				require("smart-splits").move_cursor_left,
				{ desc = "Move window focus Left" }
			)
			vim.keymap.set(
				"n",
				"<M-Down>",
				require("smart-splits").move_cursor_down,
				{ desc = "Move window focus Down" }
			)
			vim.keymap.set(
				"n",
				"<M-Up>",
				require("smart-splits").move_cursor_up,
				{ desc = "Move window focus Up" }
			)
			vim.keymap.set(
				"n",
				"<M-Right>",
				require("smart-splits").move_cursor_right,
				{ desc = "Move window focus Right" }
			)
		end,
	},
}
