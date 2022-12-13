local extension_path = vim.env.XDG_DATA_HOME .. '/nvim/mason/packages/codelldb/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
return {
	tools = {
		executor = require("rust-tools.executors").termopen,
		inlay_hints = {
			auto = false
		},
		runnables = {
			use_telescope = true,
		},
		hover_actions = {
			auto_focus = true,
		},
	},
	dap = {
		adapter = require('rust-tools.dap').get_codelldb_adapter(
			codelldb_path, liblldb_path)
	},
}
