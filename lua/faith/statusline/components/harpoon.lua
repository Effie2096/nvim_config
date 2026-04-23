local icons = require("faith.icons")
local histr = require("faith.statusline.utils").histr

return function()
		local harpoon = require("harpoon")

		if package.loaded.harpoon == nil or next( harpoon:list().items) == nil then
			return ""
		end

		local separator = icons.separators.straight.left
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

		local keys = {
			[1] = "m",
			[2] = "n",
			[3] = "e",
			[4] = "i",
			[5] = "a",
			[6] = ";",
		}
		local harpoons = {}

		if next(marks) ~= nil then
			for i, mark in ipairs(marks) do
				local is_current = (
					(
						vim.fn.glob(vim.fn.fnamemodify(buf, ":p:.")) -- relative
						== vim.fn.glob(mark.value)
					)
					or (
						vim.fn.glob(vim.fn.fnamemodify(buf, ":p"))
						== vim.fn.glob(mark.value)
					) -- or absolute
				)

				local label
				local icon, hl = "", "StatusLine"

				if mark.value == "" or mark.value == "(empty)" then
					label = "(empty)"
					is_current = false
				else
					label = vim.fn.fnamemodify(mark.value, ":t")

					if name_count[label] > 1 then
						local initial = get_folder_initial(mark.value)
						label = ("%s/%s"):format(initial, label)
					end

					icon, hl, _ = require("mini.icons").get("file", label)
				end

				local tab = {}
				if i <= #keys then
					table.insert(tab, {
						text = ("%s "):format(keys[i]),
						link = is_current and "HarpoonNumberActive"
						or "HarpoonNumberInactive",
					})
					table.insert(tab, {
						text = icon,
						link = hl
					})
					table.insert(tab, {
						text = string.format(" %s ", label),
						link = is_current and "HarpoonActive" or "HarpoonInactive",
					})
					table.insert(harpoons, tab)
				else
					extra_marks = extra_marks + 1
				end
			end

			local result = vim
			.iter(ipairs(harpoons))
			:map(function(_, tab)
				return vim.iter(ipairs(tab)):map(function(_, segment)
					return histr(segment.text, segment.link)
				end):join("")
			end)
			:join(histr(separator, "HarpoonSeparator") .. " ")

			if extra_marks > 0 then
				result = result
				.. histr(separator, "HarpoonSeparator")
				.. histr(("+%s"):format( tostring(extra_marks)), "HarpoonNumberActive")

			end
			return result
		end
	end
