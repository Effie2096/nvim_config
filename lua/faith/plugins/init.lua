return {
	{
		'rcarriga/nvim-notify',
		config = function()
			local notify = require("notify")
			notify.setup({
				render = "wrapped-compact",
				fps = 60,
				top_down = false
			})
			vim.notify = require("notify")
		end
	},
	"tpope/vim-abolish",
	{
		"godlygeek/tabular",
		cmd = "Tabularize"
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
