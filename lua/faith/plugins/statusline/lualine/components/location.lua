local winbar = require("faith.plugins.statusline.lualine.components.winbar")
local winbar_ignore = winbar.ignore.winbar_ignore

return {
	"%11(%l/%L:%c%) ", --'%l/%L:%c'
	padding = 0,
	separator = "",
	cond = winbar_ignore,
}
