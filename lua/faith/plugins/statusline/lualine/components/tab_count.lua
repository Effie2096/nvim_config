local icons = require("faith.icons")

return {
	function()
		return string.format("[%s]", vim.fn.tabpagenr("$"))
	end,
	color = "AccentInverse",
	separator = icons.separators.straight.right,
	padding = 0,
	cond = function()
		return vim.fn.tabpagenr("$") > 6
	end,
}
