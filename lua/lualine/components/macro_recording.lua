local modules = require("lualine_require").lazy_require({
	highlight = "lualine.highlight",
	utils = "lualine.utils.utils",
})

local M = require("lualine.component"):extend()

local default_options = {}
local default_symbols = {
	icons = { recording = "󰑋 " },
	no_icons = { recording = "R:" },
}

function M:init(options)
	M.super.init(self, options)
	self.options.component_name = "macro_recording"
	self.options =
		vim.tbl_deep_extend("keep", self.options or {}, default_options)
	self.symbols = vim.tbl_extend(
		"keep",
		self.options.symbols or {},
		self.options.icons_enabled ~= false and default_symbols.icons
			or default_symbols.no_icons
	)
	self.highlight_groups = {
		icon = self:create_hl({
			fg = modules.utils.extract_highlight_colors("DiagnosticError", "fg"),
		}),
	}
end

function M:update_status()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return
	else
		return recording_register
	end
end

function M:apply_icon()
	if not self.options.icons_enabled then
		return
	end

	local default_highlight = self:get_default_hl()
	local icon_hl = self:format_hl(self.highlight_groups.icon)

	self.status = icon_hl
		.. self.symbols.recording
		.. default_highlight
		.. self.status
end

return M
