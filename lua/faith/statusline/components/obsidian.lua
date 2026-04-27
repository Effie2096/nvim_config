return function()
	local has, status  = pcall(vim.api.nvim_get_option_value,"obsidian_status", { buf = 0 })
	return has and status or ""
end
