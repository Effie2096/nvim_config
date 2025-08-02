local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

local spinner = require("faith.plugins.statusline.ui.spinner")
local windsurf_spinner = spinner:new("windsurf_spinner", "dots")

return {
	function()
		local status = require("codeium.virtual_text").status()

		if status.state == "idle" then
			-- Output was cleared, for example when leaving insert mode
			windsurf_spinner:stop()
			return histr(icons.ui.Brain, "DiagnosticCheck")
		end

		if status.state == "waiting" then
			-- Waiting for response
			windsurf_spinner:start()
			return windsurf_spinner:get_frame() .. " "
		end

		if status.state == "completions" and status.total > 0 then
			windsurf_spinner:stop()
			return string.format("%d/%d", status.current, status.total)
		end

		return " 0 "
	end,
	separator = "",
	cond = function()
		return package.loaded["codeium"] ~= nil
	end,
}
