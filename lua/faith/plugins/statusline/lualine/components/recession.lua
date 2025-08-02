local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

return {
	function()
		local session_state = require("resession").get_current_session_info()
		if session_state == nil then
			return ""
		end
		-- if it's auto, make it yellow
		local color = session_state.dir:find("/auto/") ~= nil and "SessionAuto"
			or "DiagnosticCheck"
		return histr(icons.ui.Session, color, true) .. " in"
	end,
	padding = { left = 1, right = 0 },
	cond = function()
		return require("resession").get_current_session_info() ~= nil
	end,
}
