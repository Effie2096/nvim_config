return {
	"b:obsidian_status",
	fmt = function(str)
		local len = vim.fn.strdisplaywidth(str)
		return ("%s(%s)"):format(string.rep(" ", len / 5), str)
	end,
	color = "Comment",
	separator = "|",
	cond = function()
		return vim.b.obsidian_status ~= nil
	end,
}
