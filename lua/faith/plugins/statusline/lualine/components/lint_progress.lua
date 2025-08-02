local histr = require("faith.plugins.statusline.utils").histr

local spinner = require("faith.plugins.statusline.ui.spinner")
local lint_spinner = spinner:new("lualine_lint_spinner", "dots_negative", 1)

local linger_timer = nil -- Timer to handle lingering names
local linger_duration = 5000 -- Duration in milliseconds for names to linger

local M = {}

return {
	function()
		local linters = require("lint").get_running()

		if #linters == 0 then
			lint_spinner:stop()

			-- If no linters are running, start the linger timer if not already active
			if not linger_timer then
				linger_timer = vim.uv.new_timer()
				linger_timer:start(
					linger_duration,
					0, -- No repeat
					vim.schedule_wrap(function()
						M.linters = nil -- Clear the names after the delay
						linger_timer:close()
						linger_timer = nil
					end)
				)
			end

			return histr("󰦕 ", "DiagnosticCheck", true) .. (M.linters or "")
		else
			if linger_timer then
				linger_timer:stop()
				linger_timer:close()
				linger_timer = nil
			end

			M.linters = table.concat(linters, ", ")
		end

		lint_spinner:start()
		return histr(
			string.format("%s ", lint_spinner:get_frame()),
			"BarDiagInfo",
			true
		) .. M.linters
	end,
	cond = function()
		return require("lint").linters_by_ft[vim.bo.filetype] ~= nil
	end,
	padding = { left = 1, right = 0 },
	separator = "",
}
