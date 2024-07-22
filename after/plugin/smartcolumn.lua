local has_smartcolumn, smartcolumn = pcall(require, "smartcolumn")
if not has_smartcolumn then
	return
end

smartcolumn.setup({
	colorcolumn = vim.api.nvim_get_option_value("colorcolumn", { scope = "global" }),
})
