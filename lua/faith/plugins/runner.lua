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
}
