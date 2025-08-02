return {
	function()
		return vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
	end,
	color = "AccentInverse",
	padding = { left = 1, right = 0 },
}
