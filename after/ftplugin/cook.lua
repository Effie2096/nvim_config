vim.opt_local.wrap = true
vim.opt_local.conceallevel = 2

local root_markers = { ".git", ".cooklang" }

vim.lsp.config.cooklang = {
	cmd = { "cook", "lsp" },
	filetypes = { "cook" },
	root_markers = root_markers,
	root_dir = vim.fs.dirname(
		vim.fs.find(
			root_markers,
			{
				type = "directory",
				path = vim.fn.expand("%"),
				limit = math.huge,
				upwards = true,
			}
		)[1]
	) or vim.fn.getcwd(),
}

vim.lsp.enable("cooklang")
