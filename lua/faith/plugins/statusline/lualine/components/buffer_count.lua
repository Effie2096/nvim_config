local utils = require("faith.plugins.statusline.utils")
local format_bubble = utils.format_bubble

return {
	function()
		local buffers_count = 0
		for b = 1, vim.fn.bufnr("$") do
			if
				vim.fn.buflisted(b) ~= 0
				and vim.api.nvim_get_option_value("buftype", { buf = b })
					~= "quickfix"
			then
				buffers_count = buffers_count + 1
			end
		end
		return buffers_count > 0 and format_bubble(buffers_count) or ""
	end,
	padding = { left = 1, right = 0 },
	separator = "",
}
