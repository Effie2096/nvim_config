return {
	function()
		local alt_buf = vim.fn.bufname("#")
		if alt_buf == "" then
			return ""
		end

		local alt_buf_name = vim.fn.fnamemodify(alt_buf, ":t")
		if alt_buf_name:len() > 20 then
			alt_buf_name = alt_buf_name:sub(1, 20) .. "..."
		end

		return alt_buf_name
	end,
	color = "AccentInverse",
	icon = "#",
	padding = { left = 1, right = 0 },
	separator = "",
	cond = function()
		return vim.fn.bufname("#") ~= ""
	end,
}
