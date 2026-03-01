if (not vim.fn.executable("autohotkey")) or (vim.fn.has("win32") ~= 1) then
	return
end

local ahk_path =
	vim.fn.glob("$HOME/scoop/apps/autohotkey/current/v2/AutoHotkey64.exe")

vim.lsp.config.ahk2 = {
	autostart = true,
	cmd = {
		"node",
		vim.fn.expand("$HOME/lsp/vscode-autohotkey2-lsp/server/dist/server.js"),
		"--stdio",
	},
	filetypes = { "ahk", "autohotkey", "ah2" },
	init_options = {
		locale = "en-us",
		InterpreterPath = ahk_path,
	},
	single_file_support = true,
	flags = { debounce_text_changes = 500 },
	-- capabilities = capabilities,
	-- on_attach = custom_attach,
}

vim.lsp.enable({ "ahk2" })
