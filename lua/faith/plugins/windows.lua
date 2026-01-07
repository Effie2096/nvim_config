return {
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		config = function()
			-- vim.o.winwidth = 10
			-- vim.o.winminwidth = 10
			-- vim.o.equalalways = false
			vim.keymap.set("n", "<C-w>m", "<CMD>WindowsMaximize<CR>")
			vim.keymap.set("n", "<C-w>u", "<CMD>WindowsToggleAutowidth<CR>")
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
					buftype = { "terminal", "nofile", "prompt" },
					filetype = {
						"toggleterm",
						"neo-tree",
						"OverseerList",
						"Avante",
						"AvanteInput",
						"AvanteSelectedFiles",
						"oil_preview",
						"snacks_input",
					},
				},
			})
		end,
	},
}
