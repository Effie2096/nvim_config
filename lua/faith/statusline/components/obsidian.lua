return function()
	local status = vim.b.obsidian_status
	return (vim.b.obsidian_buffer and (status ~= "")) and status or nil
end
