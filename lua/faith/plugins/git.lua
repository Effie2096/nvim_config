return {
	{
		"tpope/vim-fugitive",
		keys = {
			{
				"<leader>gs",
				vim.cmd.G,
				desc = "[g]it [s]tatus: Open git status window.",
			},
		},
	},
	{
		"mbbill/undotree",
		keys = {
			{
				"<leader>u",
				vim.cmd.UndotreeToggle,
				desc = "[u]ndo tree: Open undo history for current file.",
			},
		},
		init = function()
			vim.g.undotree_WindowLayout = 3
			vim.g.undotree_SplitWidth = 70
			vim.g.undotree_DiffpanelHeight = 20
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_Helpline = 0

			vim.g.undotree_DiffCommand = "git diff"
		end,
	},
}
