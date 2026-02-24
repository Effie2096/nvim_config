return {
	"tpope/vim-abolish",
	"kevinhwang91/promise-async",

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
