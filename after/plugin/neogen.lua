local has_neogen, neogen = pcall(require, "neogen")
if not has_neogen then
	return
end

neogen.setup({
	snippet_engine = "luasnip",
	languages = {
		python = {
			template = {
				annotation_convention = "reST",
			},
		},
	},
})
