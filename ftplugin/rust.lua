vim.opt_local.expandtab = false
vim.lsp.inlay_hint.enable(true)

local bufnr = vim.api.nvim_get_current_buf()

local has_rustaceanvim, rustaceanvim = pcall(require, "rustaceanvim")
require("faith.lsp.handlers").lsp_keymaps(bufnr)
if has_rustaceanvim then
	require("faith.lsp.handlers").rust_keymaps(bufnr)

	vim.g.rustaceanvim = function()
		local codelldb = require("mason-registry").get_package("codelldb")
		local extension_path = codelldb:get_install_path() .. "/extension/"
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
				on_attach = require("faith.lsp.handlers").on_attach,
				default_settings = require("faith.lsp.settings.rust").settings,
			},
			dap = {
				adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
			},
		}
	end
end

