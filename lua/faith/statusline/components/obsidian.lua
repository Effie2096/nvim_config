return function()
	local status = vim.b.obsidian_status
	return ((vim.b.obsidian_buffer ~= nil) and (status ~= "")) and status or ""
end
