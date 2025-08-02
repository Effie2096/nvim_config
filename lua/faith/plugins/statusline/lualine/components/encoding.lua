local winbar = require("faith.plugins.statusline.lualine.components.winbar")
local ignore = winbar.ignore
local winbar_ignore = ignore.winbar_ignore

return {
	"encoding",
	padding = { left = 0, right = 1 },
	fmt = function(str)
		if str == "utf-8" then -- only show if *not* utf-8
			return ""
		end
		return str
	end,
	cond = winbar_ignore,
}
