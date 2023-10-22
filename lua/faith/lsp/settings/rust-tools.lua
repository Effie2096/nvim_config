local codelldb = require("mason-registry").get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
return {
	tools = {
		executor = require("rust-tools.executors").vimux,
		inlay_hints = {
			auto = false,
		},
		runnables = {
			use_telescope = true,
		},
		hover_actions = {
			auto_focus = true,
		},
		on_initialized = function()
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
				pattern = { "*.rs" },
				callback = function()
					local _, _
					pcall(vim.lsp.codelens.refresh)
				end,
			})
		end,
	},
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
}
