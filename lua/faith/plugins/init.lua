return {
	"tpope/vim-abolish",
	"kevinhwang91/promise-async",
	{ "nvim-lua/plenary.nvim", name = "plenary.nvim" },
	{
		"nvim-tree/nvim-web-devicons",
		name = "dev_icons",
		opts = {},
	},
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>p",
				"<cmd>PasteImage<cr>",
				desc = "Paste image from system clipboard",
			},
		},
	},
	{
		{
			"folke/which-key.nvim",
			event = "VimEnter",
			opts = {
				delay = 500,
				icons = {
					mappings = true,
					keys = {},
				},
				disable = {
					ft = { "toggleterm", "snacks_input" },
					bt = { "terminal", "prompt" },
				},
			},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
	},
}
