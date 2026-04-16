---@type overseer.Action[]
local actions = {
	add_env = {
		run = function(task)
			local env = task.env or {}
			local input = vim.fn.input("KEY=value", "")
			if input then
				local key = vim.fn.trim(input:match("^([^=]+)"))
				local value = vim.fn.trim(input:match("([^=]+)$"))
				env[key] = value
			end
			task.env = env
		end,
	},
	show_env = {
		condition = function(task)
			return task.env and not vim.tbl_isempty(task.env)
		end,
		run = function(task)
			vim.notify(vim.inspect(task.env), vim.log.levels.INFO)
		end,
	},
}

return {
	{
		"stevearc/overseer.nvim",
		tag = "v2.*.*",
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
			actions = actions,
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
				min_width = 40,
				max_height = { 20, 0.1 },
				min_height = 8,
				height = nil,
				-- String that separates tasks
				separator = "────────────────────────────────────────",
				-- Default direction. Can be "left", "right", or "bottom"
				direction = "bottom",
				keymaps = {
					["W"] = { "keymap.run_action", opts = { action = "watch" } },
				},
			},
		},
		keys = {
			{
				"<F4>",
				function()
					require("overseer").run_task({
						tags = {
							require("overseer").TAG.BUILD,
						},
					})
					require("overseer").open({ enter = false })
				end,
				{ "n", "i" },
				desc = "OverseerRun BUILD",
			},
			{
				"<F5>",
				function()
					local overseer = require("overseer")

					local task_list = require("overseer.task_list")
					local tasks = overseer.list_tasks({
						status = {
							overseer.STATUS.SUCCESS,
							overseer.STATUS.FAILURE,
							overseer.STATUS.CANCELED,
						},
						filter = function(task)
							vim.notify(vim.inspect(task))
							return true
						end,
						sort = task_list.sort_finished_recently,
					})
					-- if vim.tbl_isempty(tasks) then
					-- 	vim.notify("No tasks found", vim.log.levels.WARN)
					-- else
					-- 	local most_recent = tasks[1]
					-- 	overseer.run_action(most_recent, "restart")
					-- end
					require("overseer").run_task({
						tags = {
							require("overseer").TAG.RUN,
						},
					})
					require("overseer").open({ enter = false })
				end,
				{ "n", "i" },
				desc = "OverseerRun RUN",
			},
		},
	},
}
