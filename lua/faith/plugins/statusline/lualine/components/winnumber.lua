local format_bubble = require("faith.plugins.statusline.utils").format_bubble

return {
	function()
		return format_bubble(vim.api.nvim_win_get_number(0))
	end,
	padding = 0,
}
