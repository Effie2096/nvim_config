local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

local ignore =
	require("faith.plugins.statusline.lualine.components.winbar").ignore
local winbar_ignore = ignore.winbar_ignore

return {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	-- Displays diagnostics for the defined severity types
	sections = { "error", "warn", "info", "hint" },
	diagnostics_color = {
		-- Same values as the general color option can be used here.
		error = "BarDiagError", -- Changes diagnostics' error color.
		warn = "BarDiagWarn", -- Changes diagnostics' warn color.
		info = "BarDiagInfo", -- Changes diagnostics' info color.
		hint = "BarDiagHint", -- Changes diagnostics' hint color.
	},
	symbols = require("faith.icons").diagnostic,
	colored = true, -- Displays diagnostics status in color if set to true.
	update_in_insert = true, -- Update diagnostics in insert mode.
	always_visible = false, -- Show diagnostics even if there are none.
	color = "WinBar",
	fmt = function(str, ctx)
		local buf = vim.api.nvim_get_current_buf()

		if not winbar_ignore() then
			return histr(" ", "DiagnosticCheck", true)
		end

		local total = 0
		if ctx.last_diagnostics_count[buf] then
			for _, value in pairs(ctx.last_diagnostics_count[buf]) do
				total = total + value
			end
		end

		return total == 0 and histr(icons.ui.Check, "DiagnosticCheck", true) or str
	end,
	separator = { left = "", right = "" },
}
