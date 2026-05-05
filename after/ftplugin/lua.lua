local lua_buffer = vim.api.nvim_get_current_buf()

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

if
	vim.fn.fnamemodify(vim.api.nvim_buf_get_name(lua_buffer), ":t") == "xmake.lua"
then
	local xmake = require("xmake")
	xmake.setup({
		runner = {
			type = "terminal",
		},
	})
end
