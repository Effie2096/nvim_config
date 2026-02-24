local modules = require("lualine_require").lazy_require({
	highlight = "lualine.highlight",
})

local M = require("lualine.component"):extend()

local default_options = {
	padding = { left = 0, right = 0 },
}

local default_flag_colors = {
	blue = "#5bcffa",
	pink = "#ffb5cd",
	white = "#ffffff",
}

function M:init(options)
	M.super.init(self, options)
	self.options.component_name = "trans_flag"
	self.options.flag_colors = {
		blue = self:create_hl({ fg = default_flag_colors.blue }, "trans_blue"),
		pink = self:create_hl({ fg = default_flag_colors.pink }, "trans_pink"),
		white = self:create_hl({ fg = default_flag_colors.white }, "trans_white"),
	}
	self.options =
		vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:update_status()
	return string.format(
		"%s%s%s%s%s",
		string.format("%s%s", self:format_hl(self.options.flag_colors.blue), "█"),
		string.format("%s%s", self:format_hl(self.options.flag_colors.pink), "█"),
		string.format("%s%s", self:format_hl(self.options.flag_colors.white), "█"),
		string.format("%s%s", self:format_hl(self.options.flag_colors.pink), "█"),
		string.format("%s%s", self:format_hl(self.options.flag_colors.blue), "█")
	)
end

return M
