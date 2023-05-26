local has_neotest, neotest = pcall(require, "neotest")
if not has_neotest then
	return
end

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap

neotest.setup({
	require("neotest-vim-test")({
		ignore_file_types = { "rust", "haskell" },
	}),
})
