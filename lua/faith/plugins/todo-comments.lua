return {
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "plenary.nvim" },
		opts = { signs = true, sign_priority = 15 },
	},
}
