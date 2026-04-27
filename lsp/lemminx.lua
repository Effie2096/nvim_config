return {
	cmd = { "lemminx" },
	filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
	root_dir = vim.fs.dirname(
		vim.fs.find(
			".git",
			{ path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), upward = true }
		)[1]
	),
	single_file_support = true,
}
