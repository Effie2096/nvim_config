local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

return {
	function()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return ""
		else
			return ("%s %s"):format(
				histr(icons.ui.Recording, "BarDiagError"),
				recording_register
			)
		end
	end,
	padding = { left = 0, right = 0 },
	separator = "",
}
