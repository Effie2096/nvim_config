local icons = require("faith.icons")

return {
	"diagnostics",
	sources = { "nvim_workspace_diagnostic" },
	symbols = require("faith.icons").diagnostic,
	update_in_insert = false,
	padding = { left = 0, right = 1 },
	separator = {
		left = icons.separators.straight.left,
		right = "",
	},
}
