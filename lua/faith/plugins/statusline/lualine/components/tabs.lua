local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

return {
	"tabs",
	-- 0: Shows tab_nr
	-- 1: Shows tab_name
	-- 2: Shows tab_nr + tab_name
	mode = 1,
	-- 0: just shows the filename
	-- 1: shows the relative path and shorten $HOME to ~
	-- 2: shows the full path
	-- 3: shows the full path and shorten $HOME to ~
	path = 0,
	max_length = function()
		return math.floor(vim.o.columns * 4) - 5
	end,
	padding = { left = 0, right = 0 },
	tabs_color = {
		-- Same values as the general color option can be used here.
		active = "TabLineSel", -- Color for active tab.
		inactive = "TabLine", -- Color for inactive tab.
	},
	show_modified_status = false, -- Shows a symbol next to the tab name if the file has been modified.
	symbols = {
		modified = icons.ui.Dot, -- Text to show when the file is modified.
	},
	fmt = function(name, context)
		local is_current = context.tabnr == vim.fn.tabpagenr()
		local tab_dir = vim.fn.fnamemodify(vim.fn.getcwd(-1, context.tabnr), ":t")
		local show_dir = tab_dir ~= vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")

		local tabname = vim.fn.gettabvar(context.tabnr, "tabname")

		local tab_name = (type(tabname) == "string" and tabname ~= "")
				and string.format("%s ", string.upper(tabname))
			or ""

		local path = (
			show_dir and string.format("%s %s/", icons.kind.Folder, tab_dir) or ""
		)

		local highlight = (is_current and "TabLineSel" or "TabLine")

		return string.format(
			"%s%s%s",
			histr(
				string.format(" %d ", context.tabnr),
				(is_current and "TabLineSel" or "AccentInverse"),
				true
			),
			histr(string.format("%s%s", tab_name, path), highlight),
			histr("", highlight)
		)
	end,
	-- cond = function()
	-- 	return vim.fn.tabpagenr("$") > 1
	-- end,
}
