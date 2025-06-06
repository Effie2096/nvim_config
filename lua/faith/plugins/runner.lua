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

			task_list = {
				-- Default detail level for tasks. Can be 1-3.
				default_detail = 1,
				-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- min_width and max_width can be a single value or a list of mixed integer/float types.
				-- max_width = {100, 0.2} means "the lesser of 100 columns or 20% of total"
				-- max_width = { 40, 0.2 },
				-- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
				-- min_width = { 40, 0.1 },
				-- optionally define an integer/float for the exact width of the task list
				width = 40,
				max_height = { 20, 0.1 },
				min_height = 8,
				height = nil,
				-- String that separates tasks
				separator = "────────────────────────────────────────",
				-- Default direction. Can be "left", "right", or "bottom"
				direction = "bottom",
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
		config = function()
			require("livepreview.config").set({
				dynamic_root = true,
			})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {},
		init = function()
			local term_opts = function()
				local direction = vim.o.columns > 180 and "vertical"
					or "horizontal"
				local size = 16
				if direction == "horizontal" then
					local term_win_height = math.floor(vim.o.lines * 0.2)
					size = term_win_height > 120 and term_win_height or 10
				elseif direction == "vertical" then
					local term_win_width = math.floor(vim.o.columns * 0.4)
					size = term_win_width > 81 and term_win_width or 81
				end
				return { size = size, direction = direction }
			end
			vim.keymap.set("n", "<c-\\>", function()
				local opts = term_opts()
				vim.api.nvim_cmd({
					cmd = "ToggleTerm",
					args = {
						"size=" .. opts.size,
						"direction=" .. opts.direction,
					},
					count = 1,
				}, { output = false })
			end)
			vim.keymap.set("i", "<c-\\>", function()
				local opts = term_opts()
				vim.api.nvim_cmd({
					cmd = "ToggleTerm",
					args = {
						"size=" .. opts.size,
						"direction=" .. opts.direction,
					},
					count = 1,
				}, { output = false })
			end)

			vim.api.nvim_create_autocmd("TermEnter", {
				pattern = "term://*toggleterm#*",
				callback = function(args)
					vim.schedule(function()
						vim.cmd("startinsert")
					end)
					vim.keymap.set("t", "<c-t>", function()
						vim.api.nvim_cmd({
							cmd = "ToggleTerm",
							args = {
								"size=16",
								"direction=horizontal",
							},
							count = 1,
						}, {})
					end, { buffer = args.buf })
				end,
			})
		end,
	},
	{
		"willothy/flatten.nvim",
		enabled = false,
		config = true,
		-- or pass configuration with
		-- opts = {  }
		-- Ensure that it runs first to minimize delay when opening file from terminal
		lazy = false,
		priority = 1001,
	},
}
