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
---@field prefix { text: string, group: string }[]
---@field marks markStatus[]
---@field postfix { text: string, group: string }[]

---@class markStatus
---@field current boolean
---@field path string
---@field key { text: string, group: string}
---@field icon { text: string, group: string}|nil
---@field prefix { text: string, group: string}|nil
---@field lable { text: string, group: string}
---@field postfix { text: string, group: string}|nil

M.get_data = function()
	if package.loaded.harpoon == nil then
		return ""
	end
	if next(harpoon:list().items) == nil then
		return ""
	end

	local marks = harpoon:list().items or {}

	local buf = vim.api.nvim_buf_get_name(0)

	local function split_path(path)
		local parts = {}
		for part in vim.fs.normalize(path):gmatch("[^/]+") do
			table.insert(parts, part)
		end
		return parts
	end
	local function slice(tbl, start_idx)
		local result = {}
		for i = start_idx, #tbl do
			table.insert(result, tbl[i])
		end
		return result
	end

	local function shortest_unique_suffixes(path_specs)
		local split_paths = {}
		local max_depth = 0

		for i, spec in ipairs(path_specs) do
			split_paths[i] = {}
			split_paths[i].path = split_path(spec.path)
			split_paths[i].shortened = spec.shortened and #split_paths[i].path > 1 -- only shortened if not at root
			max_depth = math.max(max_depth, #split_paths[i].path)
		end

		for depth = 1, max_depth do
			local seen = {}
			local unique = true
			local suffixes = {}

			for i, spec in ipairs(split_paths) do
				local start_idx = math.max(1, #spec.path - depth + 1)
				local suffix_parts = slice(spec.path, start_idx)

				local key = table.concat(suffix_parts, "/")

				if seen[key] then
					unique = false
				end

				seen[key] = true
				suffixes[i] = {}
				suffixes[i].path = suffix_parts
				suffixes[i].shortened = spec.shortened
			end

			if unique then
				return suffixes
			end
		end

		return split_paths
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
				mark_display.path = vim.fs.normalize(mark.value)

				local mark_file = vim.fn.fnamemodify(mark.value, ":t")

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

		local name_count = vim
			.iter(ipairs(mark_data.marks))
			:fold({}, function(acc, _, mark)
				local name = vim.fn.fnamemodify(mark.path, ":t")
				acc[name] = (acc[name] or 0) + 1
				return acc
			end)

		local shorten = shortest_unique_suffixes(vim
			.iter(mark_data.marks)
			:map(function(mark)
				local name = vim.fn.fnamemodify(mark.path, ":t")
				local ret = {}
				ret.shortened = name_count[name] > 1 -- only duplicate file names should have their paths shortened
				ret.path = mark.path
				return ret
			end)
			:totable())

		mark_data.marks = vim
			.iter(ipairs(mark_data.marks))
			:map(function(i, mark)
				if shorten[i].shortened then
					mark.prefix = {
						text = vim
							.iter(shorten[i].path)
							:map(function(dir)
								local s, e = dir:find("%w")
								return dir:sub(s, e)
							end)
							:join("/") .. "/",
						group = "@comment",
					}
					mark.postfix = {
						text = shorten[i].path[1],
						group = "@comment",
					}
				end
				return mark
			end)
			:totable()

		if extra_marks > 0 then
			mark_data.postfix = {
				{
					text = ("+%d"):format(extra_marks),
					group = "HarpoonNumberActive",
				},
			}
		end

		return mark_data
	end
end

local function splitIntoLetters(inputString)
	local letters = {}
	for letter in string.gmatch(inputString, ".") do
		table.insert(letters, letter)
	end
	return letters
end

M.statusline = function()
	local data = M.get_data()
	local prefix = {}
	local marks = {}
	local postfix = {}

	if data.marks then
		marks = vim
			.iter(data.marks)
			:map(function(mark)
				return ("%s %s %s%s%s"):format(
					histr(mark.key.text, mark.key.group, true),
					histr(mark.icon.text, mark.icon.group, true),
					mark.prefix and histr(mark.prefix.text, mark.prefix.group, true) or "",
					histr(mark.lable.text, mark.lable.group, true),
					mark.postfix
							and histr(
								vim
									.iter(splitIntoLetters(mark.postfix.text))
									:map(function(letter)
										return icons.letters.superscript[letter:lower()] or letter
									end)
									:join(""),
								mark.postfix.group,
								true
							)
						or ""
				)
			end)
			:totable()
	end
	if data.prefix then
		prefix = vim
			.iter(data.prefix)
			:map(function(part)
				return histr(part.text, part.group, true)
			end)
			:totable()
	end
	if data.postfix then
		postfix = vim
			.iter(data.postfix)
			:map(function(part)
				return histr(part.text, part.group, true)
			end)
			:totable()
	end

	return vim
		.iter({ prefix, marks, postfix })
		:flatten()
		:join(" " .. histr(separator, "HarpoonSeparator") .. " ")
end

return M
