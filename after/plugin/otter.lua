local has_otter, otter = pcall(require, "otter")
if not has_otter then
	return
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("attach_otter", { clear = true }),
	pattern = { "*.md" },
	callback = function()
		require("otter").activate()
	end,
})

local border = require("faith.icons").borders.square
otter.setup({
	lsp = {
		hover = {
			border = {
				border.top_left,
				border.top,
				border.top_right,
				border.right,
				border.bottom_right,
				border.bottom,
				border.bottom_left,
				border.left,
			},
		},
	},
	verbose = {
		no_code_found = false,
	},
})
