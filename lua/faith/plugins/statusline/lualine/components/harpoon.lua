local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

return {
	function()
		local harpoon = require("harpoon")
		local marks = harpoon:list(
			string.format("%s%d", "tab", vim.fn.tabpagenr())
		).items or {}

		local buf = vim.api.nvim_buf_get_name(0)

		local function get_folder_initial(filepath)
			local parent =
				vim.fn.fnamemodify(filepath, ":p:h"):gsub(".*[/\\\\]", "")
			return parent:sub(1, 1)
		end

		local name_count = {}
		for _, mark in ipairs(marks) do
			local name = vim.fn.fnamemodify(mark.value, ":t")
			name_count[name] = (name_count[name] or 0) + 1
		end

		local extra_marks = 0

		local keys = {
			[1] = "h",
			[2] = "j",
			[3] = "k",
			[4] = "l",
			[5] = icons.arrows.left,
			[6] = icons.arrows.down,
			[7] = icons.arrows.up,
			[8] = icons.arrows.right,
		}
		local result = {}

		if next(marks) ~= nil then
			table.insert(result, {
				text = icons.ui.BookMark,
				link = "HarpoonNumberActive",
			})

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
				if mark.value == "" or mark.value == "(empty)" then
					label = "(empty)"
					is_current = false
				else
					label = string.format(
						"%s",
						vim.fn.fnamemodify(mark.value, ":t")
					)

					if name_count[label] > 1 then
						local initial = get_folder_initial(mark.value)
						label = initial .. "/" .. label
					end
				end

				if i <= #keys then
					if not is_current then
						table.insert(result, {
							text = (
								i == 1 and " "
								or icons.separators.bar.left
							),
							link = "HarpoonSeparator",
						})
					end
					table.insert(result, {
						text = string.format(
							"%s%s",
							(is_current and " " or ""),
							keys[i]
						),
						link = is_current and "HarpoonNumberActive"
							or "HarpoonNumberInactive",
					})
					table.insert(result, {
						text = string.format(" %s ", label),
						link = is_current and "HarpoonActive"
							or "HarpoonInactive",
					})
				else
					extra_marks = extra_marks + 1
					table.insert(result, {
						text = string.format(" %s%s", "+", extra_marks),
						link = "HarpoonNumberActive",
					})
				end
			end

			return vim.iter(result)
				:map(function(v)
					return histr(v.text, v.link)
				end)
				:join("")
		end
	end,
	cond = function()
		return package.loaded.harpoon ~= nil
			and next(
					require("harpoon"):list(
						string.format("%s%d", "tab", vim.fn.tabpagenr())
					).items
				)
				~= nil
	end,
}
