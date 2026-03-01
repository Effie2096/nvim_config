return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
		init = function()
			vim.g.rustaceanvim = function()
				local codelldb = vim.fn.expand("$MASON/packages/codelldb")
				local extension_path = codelldb .. "/extension/"
				local codelldb_path = extension_path .. "adapter/codelldb"
				local liblldb_path = extension_path .. "lldb/lib/liblldb"

				local this_os = vim.uv.os_uname().sysname

				if this_os:find("Windows") then
					codelldb_path = extension_path .. "adapter\\codelldb.exe"
					liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
				else
					liblldb_path = liblldb_path
						.. (this_os == "Linux" and ".so" or ".dylib")
				end

				local cfg = require("rustaceanvim.config")

				return {
					tools = {
						code_actions = {
							ui_select_fallback = true,
						},
					},
					server = {
						on_attach = require("faith.plugins.lsp.common").on_attach,
						default_settings = require("faith.plugins.lsp.settings.rust").settings,
					},
					dap = {
						adapter = vim.tbl_deep_extend(
							"force",
							cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
							{
								cwd = "${workspaceFolder}",
							}
						),
					},
				}
			end
		end,
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup()
		end,
	},
}
