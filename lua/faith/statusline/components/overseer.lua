local icons = require("faith.icons")
local histr = require("faith.statusline.utils").histr

local constants = require("overseer.constants")
local task_list = require("overseer.task_list")
local util = require("overseer.util")
local STATUS = constants.STATUS

local M = {}

M.get_data = function()
	local tasks = task_list.list_tasks()
	local tasks_by_status = util.tbl_group_by(tasks, "status")

	local task_data = {}
	for _, status in ipairs(STATUS.values) do
		local status_tasks = tasks_by_status[status]
		if icons.task.status[status] and status_tasks then
			task_data[status] = {}
			task_data[status].icon = icons.task.status[status]
			task_data[status].count = #status_tasks
			task_data[status].group = ("Overseer%s"):format(status)
		end
	end
	return task_data
end

M.get_statusline = function()
	local task_data = M.get_data()
	return vim
		.iter(task_data)
		:map(function(status, task)
			-- print(vim.inspect(status))
			print(vim.inspect(task))
			return histr(("%s%s"):format(task.icon, task.count), task.group)
		end)
		:join(" ")
end

return M
