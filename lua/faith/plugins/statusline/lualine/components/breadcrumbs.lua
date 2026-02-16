local navic = require("nvim-navic")
local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

return {
	function()
		return vim
			.iter(navic.get_data())
			:map(function(breadcrumb)
				return histr(breadcrumb.icon, "NavicIcons" .. breadcrumb.type)
					.. histr(breadcrumb.name, "NavicText")
			end)
			:join(histr(icons.ui.ChevronRight, "NavicSeparator") .. " ")
	end,
	cond = function()
		return navic.is_available() and navic.get_data() ~= nil
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
			str = str:gsub("%(.*%)", "(" .. icons.ui.Ellipsis .. ")")
		end
		return histr(icons.ui.ChevronRight, "NavicSeparator") .. " " .. str
	end,
}
