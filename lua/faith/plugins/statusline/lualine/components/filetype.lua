local winbar = require("faith.plugins.statusline.lualine.components.winbar")
local winbar_ft_icons = winbar.winbar_ft_icons
local winbar_ignore = winbar.ignore.winbar_ignore

local utils = require("faith.plugins.statusline.utils")
local trunc = utils.trunc
local histr = utils.histr

return {
	"filetype",
	colored = true, -- Displays filetype icon in color if set to true
	icon_only = true, -- Display only an icon for filetype
	icon = { align = "right" }, -- Display filetype icon on the right hand side
	-- icon =    {'X', align='right'}
	-- Icon string ^ in table is ignored in filetype component
	padding = { left = 0, right = 0 },
	separator = "",
	color = "WinBar",
	fmt = function(str)
		local ft = vim.bo.filetype
		local bt = vim.bo.buftype

		if winbar_ft_icons[ft] ~= nil or winbar_ft_icons[bt] then
			local ico = winbar_ft_icons[ft] or winbar_ft_icons[bt]
			str = histr((ico.icon .. " " or ""), (ico.hl or "WinBar"))
		end

		return trunc(str, 10, 0, 5, true)
	end,
	cond = winbar_ignore,
}
