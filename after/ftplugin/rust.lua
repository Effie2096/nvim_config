vim.opt_local.expandtab = false
vim.lsp.inlay_hint.enable(true)

local bufnr = vim.api.nvim_get_current_buf()

local opts = { silent = true, buffer = bufnr }

require("faith.plugins.lsp.common").lsp_keymaps(bufnr)
vim.keymap.set({ "n" }, "<leader>rr", function()
	vim.cmd.RustLsp("runnables")
end, vim.tbl_extend("force", opts, { desc = "[r]ust [r]unnables." }))
vim.keymap.set({ "n" }, "<leader>a", function()
	vim.cmd.RustLsp("codeAction")
end, vim.tbl_extend("force", opts, { desc = "[r]ust code[a]ction." }))
vim.keymap.set({ "n" }, "<leader>dl", function()
	vim.cmd.RustLsp({ "explainError", "current" })
end, opts)

vim.keymap.set(
	"n",
	"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
	function()
		local winid = require("ufo").peekFoldedLinesUnderCursor()
		if not winid then
			vim.cmd.RustLsp({ "hover", "actions" })
		end
	end,
	opts
)

vim.keymap.set({ "n", "v" }, "<J>", function()
	vim.cmd.RustLsp("joinLines")
end, opts)
vim.keymap.set({ "n", "v" }, "<K>", function()
	vim.cmd.RustLsp("joinLines")
end, opts)

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
			adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
		},
	}
end
