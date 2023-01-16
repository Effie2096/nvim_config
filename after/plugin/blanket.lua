local blanket_ok, blanket = pcall(require, "blanket")
if not blanket_ok then
	return
end

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local desc = fk.desc

blanket.setup({
	report_path = vim.fn.getcwd() .. "/target/site/jacoco/jacoco.xml",
	-- filetypes = "java",
	signs = {
		priority = 7,
		incomplete_branch_color = "WarningMsg",
		covered_color = "Statement",
		uncovered_color = "Error",
	},
})

local blanket_group = vim.api.nvim_create_augroup("blanket_group", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	group = blanket_group,
	pattern = "*.java",
	callback = function(data)
		local opts = { noremap = true, buffer = data.buf }
		nnoremap(
			"<leader>tcr",
			require("blanket").refresh,
			desc(opts, "[t]est [c]overage [r]efresh: Refresh jacoco test covarage gutter.")
		)
	end,
})
