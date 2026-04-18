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
		fullySemanticToken = true, -- Provide more semantic tokens
		AutoLibInclude = "Disabled", -- or "Local" or "User and Standard" or "All"
		CommentTags = "^;;\\s*(?<tag>.+)",
		CompleteFunctionParens = false,
		Diagnostics = {
			ClassStaticMemberCheck = true,
			ParamsCheck = true,
		},
		FormatOptions = {
			array_style = "expand", -- or "collapse" or "expand"
			break_chained_methods = true,
			ignore_comment = false,
			indent_string = "\t",
			max_preserve_newlines = 2,
			brace_style = "One True Brace", -- or "Allman" or "One True Brace Variant"
			object_style = "none", -- or "collapse" or "expand"
			preserve_newlines = true,
			space_after_double_colon = true,
			space_before_conditional = true,
			space_in_empty_paren = false,
			space_in_other = true,
			space_in_paren = false,
			wrap_line_length = 0,
		},
	},
	single_file_support = true,
	flags = { debounce_text_changes = 500 },
}

vim.lsp.enable({ "ahk2" })
