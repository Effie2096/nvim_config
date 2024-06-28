local has_neotest, neotest = pcall(require, "neotest")
if not has_neotest then
	return
end

neotest.setup({
	adapters = {
		require("neotest-vim-test")({
			allow_file_types = { "c" },
		}),
	},
})
