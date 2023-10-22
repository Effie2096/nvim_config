local has_lsp_lines, lsp_lines = pcall(require, "lsp_lines")
if not has_lsp_lines then
	return
end

lsp_lines.setup()
