local histr = require("faith.plugins.statusline.utils").histr
local M = {}

M.trans_flag = {
	function()
		return string.format(
			"%s%s%s%s%s",
			histr(" ", "TransB", false),
			histr(" ", "TransP", false),
			histr(" ", "TransW", false),
			histr(" ", "TransP", false),
			histr(" ", "TransB", true)
		)
	end,
	padding = 0,
}

return M
