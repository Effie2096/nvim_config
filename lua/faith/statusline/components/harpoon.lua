local icons = require("faith.icons")

local histr = require("faith.statusline.utils").histr

local harpoon = require("harpoon")

local separator = icons.separators.straight.left

local M = {}
M.keys = {
	[1] = "m",
	[2] = "n",
	[3] = "e",
	[4] = "i",
	[5] = "a",
	[6] = ";",
}

---@class mark_data
---@field pre_fix { text: string, group: string }[]
---@field marks markStatus[]
---@field post_fix { text: string, group: string }[]

---@class markStatus
---@field current boolean
---@field key { text: string, group: string}
---@field icon { text: string, group: string}|nil
---@field lable { text: string, group: string}

M.get_data = function()
	if package.loaded.harpoon == nil or next(harpoon:list().items) == nil then
		return ""
	end

	local marks = harpoon:list().items or {}

	local buf = vim.api.nvim_buf_get_name(0)

	local function get_folder_initial(filepath)
		local parent = vim.fn.fnamemodify(filepath, ":p:h"):gsub(".*[/\\\\]", "")
		return parent:sub(1, 1)
	end

	local name_count = {}
	for _, mark in ipairs(marks) do
		local name = vim.fn.fnamemodify(mark.value, ":t")
		name_count[name] = (name_count[name] or 0) + 1
	end

	local extra_marks = 0

	---@type mark_data
	local mark_data = {}
	mark_data.marks = {}

	if next(marks) ~= nil then
		for i, mark in ipairs(marks) do
			---@type markStatus
			local mark_display = {}

			if
				not vim.list_contains({
					"nofile",
					"terminal",
					"quickfix",
					"prompt",
				}, vim.bo.buftype)
			then
				mark_display.current = (
					(
						vim.fn.glob(vim.fn.fnamemodify(buf, ":p:.")) -- relative
						== vim.fn.glob(mark.value)
					)
					or (
						vim.fn.glob(vim.fn.fnamemodify(buf, ":p"))
						== vim.fn.glob(mark.value)
					) -- or absolute
				)
			end

			if mark.value == "" or mark.value == "(empty)" then
				mark_display.lable.text = "(empty)"
				mark_display.current = false
				mark_display.icon = nil
			else
				local mark_file = vim.fn.fnamemodify(mark.value, ":t")

				if name_count[mark_file] > 1 then
					local initial = get_folder_initial(mark.value)
					mark_file = ("%s/%s"):format(initial, mark_file)
				end

				local icon, hl, _ = require("mini.icons").get("file", mark_file)
				mark_display.icon = {
					text = icon or "",
					group = hl or "StatusLine",
				}
				mark_display.lable = {
					text = mark_file,
					group = mark_display.current and "HarpoonActive" or "HarpoonInactive",
				}
			end

			if i <= #M.keys then
				mark_display.key = {
					text = M.keys[i],
					group = mark_display.current and "HarpoonNumberActive"
						or "HarpoonNumberInactive",
				}
				table.insert(mark_data.marks, mark_display)
			else
				extra_marks = extra_marks + 1
			end
		end

		if extra_marks > 0 then
			mark_data.post_fix = {
				{
					text = ("+%d"):format(extra_marks),
					group = "HarpoonNumberActive",
				},
			}
		end

		return mark_data
	end
end

M.statusline = function()
	local data = M.get_data()
	local pre_fix = {}
	local marks = {}
	local post_fix = {}

	if data.marks then
		marks = vim
			.iter(data.marks)
			:map(function(mark)
				return ("%s %s %s"):format(
					histr(mark.key.text, mark.key.group, true),
					histr(mark.icon.text, mark.icon.group, true),
					histr(mark.lable.text, mark.lable.group, true)
				)
			end)
			:totable()
	end
	if data.post_fix then
		post_fix = vim
			.iter(data.post_fix)
			:map(function(part)
				return histr(part.text, part.group, true)
			end)
			:totable()
	end

	return vim
		.iter({ marks, post_fix })
		:flatten()
		:join(" " .. histr(separator, "HarpoonSeparator") .. " ")
end

return M
