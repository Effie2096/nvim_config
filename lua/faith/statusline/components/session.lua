local icons = require("faith.icons")
local histr = require("faith.statusline.utils").histr

return function()
	local session_state = require("resession").get_current_session_info()
	local manual_sessions = vim.tbl_count(require("resession").list())
	if session_state == nil and manual_sessions == nil then
		return ""
	end

	local icon  = icons.ui.Session
	local color = "@diff.plus"
	if session_state == nil and manual_sessions > 0 then
		color = "@diff.minus"
	end
	if session_state.dir:find("/auto/") ~= nil then
		-- if it's auto, make it yellow
		color = "@diff.delta"
	end
	return histr(("%s%s"):format(manual_sessions > 0 and tostring(manual_sessions) or "", icon), color, true)
end
