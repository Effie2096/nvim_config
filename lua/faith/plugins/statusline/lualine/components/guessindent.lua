local icons = require("faith.icons")
local winbar_ignore = require(
	"faith.plugins.statusline.lualine.components.winbar"
).ignore.winbar_ignore
local histr = require("faith.plugins.statusline.utils").histr

local gi = require("guess-indent")
local highlight = "AccentInverse"

return {
	function()
		local indent = gi.guess_from_buffer()
		local out = ""
		if indent ~= nil then
			local is_tabs = indent ~= nil and type(indent) ~= "number"
			if is_tabs then
				out =
					histr(("%s%s"):format(vim.bo.tabstop, icons.ui.Tab), highlight, true)
			else
				out = histr(("%s%s"):format(indent, icons.ui.Space), highlight, true)
			end
		end
		return out
	end,
	padding = { left = 0, right = 1 },
	cond = function()
		return gi.guess_from_buffer() ~= nil and winbar_ignore()
	end,
}
