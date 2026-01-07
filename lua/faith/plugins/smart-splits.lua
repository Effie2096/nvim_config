return {
	{
		"mrjones2014/smart-splits.nvim",
		opts = {},
		config = function()
			vim.keymap.set("n", "<S-Left>", require("smart-splits").resize_left)
			vim.keymap.set("n", "<S-Down>", require("smart-splits").resize_down)
			vim.keymap.set("n", "<S-Up>", require("smart-splits").resize_up)
			vim.keymap.set("n", "<S-Right>", require("smart-splits").resize_right)
			-- moving between splits
			vim.keymap.set("n", "<M-Left>", require("smart-splits").move_cursor_left)
			vim.keymap.set("n", "<M-Down>", require("smart-splits").move_cursor_down)
			vim.keymap.set("n", "<M-Up>", require("smart-splits").move_cursor_up)
			vim.keymap.set(
				"n",
				"<M-Right>",
				require("smart-splits").move_cursor_right
			)
		end,
	},
}
