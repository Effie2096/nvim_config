local indentWidth = 2
vim.opt_local.tabstop = indentWidth
vim.opt_local.shiftwidth = indentWidth -- Change the number of space characters inserted for indentation
vim.opt_local.textwidth = 80
vim.opt_local.conceallevel = 2

vim.api.nvim_create_augroup("markdown_format", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = "markdown_format",
	pattern = "*.md",
	command = [[
	g!/^|\|\[\[.*\]\]\|\[.*\](.*)/normal gqq
	:execute "normal! \<C-o>"
	]],
})
