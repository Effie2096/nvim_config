return {
	{
		"stevearc/overseer.nvim",
		cmd = {
			"OverseerOpen",
			"OverseerClose",
			"OverseerToggle",
			"OverseerSaveBundle",
			"OverseerLoadBundle",
			"OverseerDeleteBundle",
			"OverseerRunCmd",
			"OverseerRun",
			"OverseerInfo",
			"OverseerBuild",
			"OverseerQuickAction",
			"OverseerTaskAction",
			"OverseerClearCache",
		},
		opts = {
			templates = {
				"builtin",
				"faith",
			},
			-- strategy = {
			-- 	"toggleterm",
			-- },
		},
		keys = {
			{
				"<F4>",
				function()
					require("overseer").run_template({
						tags = {
							require("overseer").TAG.BUILD,
						},
					})
					require("overseer").open({ enter = false })
				end,
				{ "n", "i" },
			},
			{
				"<F5>",
				function()
					require("overseer").run_template({
						tags = {
							require("overseer").TAG.RUN,
						},
					})
					require("overseer").open({ enter = false })
				end,
				{ "n", "i" },
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
		opts = function()
			require("overseer").enable_dap()
		end,
	},
	{
		"brianhuster/live-preview.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		cmd = "LivePreview",
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 16
				elseif term.direction == "vertical" then
					local term_win_width = math.floor(vim.o.columns * 0.4)
					return term_win_width > 81 and term_win_width or 81
				end
			end,
			open_mapping = [[<c-t>]],
			insert_mappings = true,
			terminal_mappings = true,
		},
		keys = {
			{
				"<c-t>",
				function()
					require("toggleterm").toggle({ direction = "horizontal" })
				end,
				{ "n", "i" },
			},
		},
	},
	{
		"willothy/flatten.nvim",
		config = true,
		-- or pass configuration with
		-- opts = {  }
		-- Ensure that it runs first to minimize delay when opening file from terminal
		lazy = false,
		priority = 1001,
	},
}
