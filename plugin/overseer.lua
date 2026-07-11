vim.pack.add(
	{ { src = "https://github.com/stevearc/overseer.nvim" } },
	{ load = function() end }
)

local function config()
	local overseer = require("overseer")
	local wk = require("which-key")

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

	---@type overseer.Config
	local opts = {
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
			-- max_width = {100, 0.2}, -- means "the lesser of 100 columns or 20% of total"
			-- max_width = { 40, 0.2 },
			-- min_width = {40, 0.1}, -- means "the greater of 40 columns or 10% of total"
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
	}

	overseer.setup(opts)

	local keymaps = {
		{
			lhs = "<leader>ro",
			rhs = vim.cmd.OverseerToggle,
			desc = "OverseerToggle",
		},
		{
			lhs = "<leader>rb",
			rhs = function()
				require("overseer").run_task({
					tags = {
						require("overseer").TAG.BUILD,
					},
				})
				require("overseer").open({ enter = false })
			end,
			desc = "OverseerRun BUILD",
		},
		{
			lhs = "<leader>rr",
			rhs = function()
				require("overseer").run_task({
					tags = {
						require("overseer").TAG.RUN,
					},
				})
				require("overseer").open({ enter = false })
			end,
			desc = "OverseerRun RUN",
		},
	}

	wk.add(vim.list_extend(
		vim
			.iter(vim.deepcopy(keymaps))
			:map(function(map)
				return {
					map.lhs,
					map.rhs,
					desc = map.desc,
					mode = map.mode or "n",
					map.opts or {},
				}
			end)
			:totable(),
		{
			{ "<leader>r", group = "Runner" },
		}
	))
end

local function load()
	if not package.loaded.overseer then
		vim.cmd.packadd("overseer.nvim")
		config()
	end
end

load()
