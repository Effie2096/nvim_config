local icons = require("faith.icons")

return {
	"diagnostics",
	sources = { "nvim_workspace_diagnostic" },
	symbols = require("faith.icons").diagnostic,
	update_in_insert = false,
	padding = { left = 1, right = 0 },
}
