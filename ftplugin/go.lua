local has_dap_go, dap_go = pcall(require, "dap-go")
if not has_dap_go then
	return
end

local opts = { noremap = true, silent = true, buffer = 0 }
vim.keymap.set("n", "<leader>bn", function()
	require("dap-go").debug_test()
	require("dapui").open({ layout = 2 })
end, vim.tbl_extend("force", opts, { desc = "de[b]ug [n]ext test" }))
vim.keymap.set("n", "<leader>bl", function()
	require("dap-go").debug_last_test()
	require("dapui").open({ layout = 2 })
end, vim.tbl_extend("force", opts, { desc = "de[b]ug [l]ast test" }))

dap_go.setup()
