return {
	{
		"stevearc/aerial.nvim",
		cmd = {
			"AerialToggle",
			"AerialOpen",
			"AerialOpenAll",
			"AerialClose",
			"AerialCloseAll",
			"AerialNext",
			"AerialPrev",
			"AerialGo",
			"AerialInfo",
			"AerialNavToggle",
			"AerialNavOpen",
			"AerialNavClose",
		},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"onsails/lspkind.nvim",
		},
		opts = {
			attach_mode = "global",
			show_guides = true,
			layout = {
				max_width = 40,
				min_width = 40,
				resize_to_content = true,
				width = 40,
				default_direction = "right",
				placement = "edge",
			},
			highlight_on_hover = true,
		},
	},
}
