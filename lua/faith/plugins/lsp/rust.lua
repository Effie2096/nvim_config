vim.pack.add({
	{
		src = "https://github.com/mrcjkb/rustaceanvim",
		version = vim.version.range("^9"),
	},
})
vim.pack.add({
	{
		src = "https://github.com/saecki/crates.nvim",
	},
}, { load = function() end })

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
		liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
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

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	once = true,
	pattern = "Cargo.toml",
	callback = function()
		vim.cmd.packadd("crates.nvim")
		require("crates").setup()
	end,
})
