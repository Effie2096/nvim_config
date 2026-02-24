local winbar = require("faith.plugins.statusline.lualine.components.winbar")
local histr = require("faith.plugins.statusline.utils").histr
local ignore = winbar.ignore
local winbar_ignore = ignore.winbar_ignore

return {
	"fileformat",
	padding = { left = 0, right = 1 },
	fmt = function(str)
		if str == "" then -- only show if *not* unix format
			return ""
		end
		if str == "" then
			return histr(str, "OsWin")
		elseif str == "" then
			return histr(str, "OsMac")
		end
		return str
	end,
	cond = winbar_ignore,
}
