local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

local gi = require("guess-indent")

return {
	function()
		local indent = gi.guess_from_buffer()
		local out = ""
		if indent ~= nil then
			local is_tabs = indent ~= nil and type(indent) ~= "number"
			if is_tabs then
				out = histr(icons.ui.Tab, "AccentInverse", true)
			else
				out = histr(
					("%s%s"):format(indent, icons.ui.Space),
					"AccentInverse",
					true
				)
			end
		end
		return out
	end,
	-- fmt = function(str)
	-- return str:format("%s%s", icons.ui.Tab)
	-- if not str then
	-- 	return "erm"
	-- end
	--
	-- if str == "tabs" then
	-- 	return icons.ui.Tabs
	-- end
	--
	-- if type(str) == "number" then
	-- 	return (" %d%s "):format(str, icons.ui.Space)
	-- end

	-- local is_tabs = str:match("tabs") ~= nil
	-- P(is_tabs)
	-- P(histr(icons.ui.Tabs, "TabLine", true))
	-- P(histr(("%s%s"):format(str, icons.ui.Space), "TabLine", true))

	-- return histr(
	-- 	string.format(
	-- 		"%s%s",
	-- 		str,
	-- 		(is_tabs and icons.ui.Tabs or icons.ui.Space)
	-- 	),
	-- 	"TabLine",
	-- 	true
	-- )
	-- end,
	-- cond = function()
	-- 	return gi.guess_from_buffer() ~= nil
	-- end,
}
