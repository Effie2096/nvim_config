return {
	{
		"anuvyklack/windows.nvim",
		event = "VeryLazy",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		config = function()
			vim.opt.winwidth = 5
			vim.opt.winminwidth = 5

			vim.opt.equalalways = false
			vim.keymap.set("n", "<C-w>m", "<CMD>WindowsMaximize<CR>")
			vim.keymap.set("n", "<C-w>u", "<CMD>WindowsToggleAutowidth<CR>")
			vim.keymap.set("n", "<C-w>|", "<CMD>WindowsMaximizeVertically<CR>")
			vim.keymap.set("n", "<C-w>_", "<CMD>WindowsMaximizeHorizontally<CR>")
			vim.keymap.set("n", "<C-w>=", "<CMD>WindowsEqualize<CR>")
			require("windows").setup({
				autowidth = {
					enable = true,
					winwidth = 0.1,
				},
				animation = {
					enable = true,
					duration = 100,
					fps = 60,
					easing = "in_out_sine",
				},
				ignore = {
					buftype = { "terminal", "nofile", "prompt", "quickfix" },
					filetype = {
						"Avante",
						"AvanteInput",
						"AvanteSelectedFiles",
						"OverseerList",
						"aerial",
						"neo-tree",
						"oil_preview",
						"qf",
						"snacks_input",
						"toggleterm",
						"undotree",
					},
				},
			})
		end,
	},
}
