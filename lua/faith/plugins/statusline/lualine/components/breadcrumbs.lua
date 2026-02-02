local navic = require("nvim-navic")
local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

return {
	function()
		return navic.get_location()
	end,
	cond = function()
		return navic.is_available()
	end,
	padding = { left = 0, right = 0 },
	separator = "",
	fmt = function(str)
		local ft = vim.bo.filetype
		if str == "" then
			return ""
		end
		if ft == "java" then
			-- replace all method params (if any) with `...`
			str = str:gsub("%(.*%)", "(...)")
		end
		return histr(icons.ui.ChevronRight, "NavicSeparator") .. " " .. str
	end,
}
