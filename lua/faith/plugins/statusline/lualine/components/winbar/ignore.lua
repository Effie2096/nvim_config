local icons = require("faith.icons")

local M = {}

M.winbar_ft_ignore = {
	"Avante",
	"AvanteInput",
	"AvanteSelectedFiles",
	"DiffviewFiles",
	"Outline",
	"OverseerList",
	"dap-repl",
	"dapui_breakpoints",
	"dapui_console",
	"dapui_scopes",
	"dapui_stacks",
	"dapui_watches",
	"fugitive",
	"help",
	"neo-tree",
	"oil",
	"qf",
	"undotree",
	"neotest-summary",
}

M.winbar_bt_ignore = {
	"nofile",
	"terminal",
	"quickfix",
}
M.winbar_ignore = function()
	return not (
		vim.tbl_contains(M.winbar_ft_ignore, vim.bo.filetype)
		or (vim.tbl_contains(M.winbar_bt_ignore, vim.bo.buftype))
	)
end

return M
