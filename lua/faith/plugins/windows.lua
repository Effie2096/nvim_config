return {
	{
		"anuvyklack/windows.nvim",
		event = "VeryLazy",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		config = function()
			vim.o.winwidth = 5
			vim.o.winminwidth = 5
			vim.o.equalalways = false
			vim.keymap.set("n", "<C-w>m", "<CMD>WindowsMaximize<CR>")
			vim.keymap.set("n", "<C-w>u", "<CMD>WindowsToggleAutowidth<CR>")
			vim.keymap.set("n", "<C-w>|", "<CMD>WindowsMaximizeVertically<CR>")
			vim.keymap.set("n", "<C-w>_", "<CMD>WindowsMaximizeHorizontally<CR>")
			vim.keymap.set("n", "<C-w>=", "<CMD>WindowsEqualize<CR>")
			require("windows").setup({
				autowidth = {
					enable = true,
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
