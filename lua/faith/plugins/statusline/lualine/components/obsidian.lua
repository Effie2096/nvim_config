return {
	"b:obsidian_status",
	fmt = function(str)
		return ("%%=%s%%="):format(str)
	end,
	color = "Comment",
	separator = "|",
	cond = function()
		return vim.b.obsidian_buffer and (vim.b.obsidian_status ~= nil)
	end,
}
