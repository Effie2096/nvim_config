local winbar = require("faith.plugins.statusline.lualine.components.winbar")
local ignore = winbar.ignore
local winbar_ignore = ignore.winbar_ignore

return {
	"fileformat",
	padding = { left = 1, right = 1 },
	fmt = function(str)
		if str == "" then -- only show if *not* unix format
			return ""
		end
		return str
	end,
	cond = winbar_ignore,
}
