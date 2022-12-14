local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local actions = null_ls.builtins.code_actions

null_ls.setup {
	debug = false,
	sources = {
		--[[ formatting.prettier.with {
			extra_filetypes = { "toml", "solidity" },
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
		}, ]]
		diagnostics.commitlint,
		formatting.clang_format.with {
			extra_args = { "--style={UseTab: Always, IndentWidth: 4, TabWidth: 4, ContinuationIndentWidth: 4, BreakBeforeBraces: Allman, AlignAfterOpenBracket: AlwaysBreak, BreakAfterJavaFieldAnnotations: true, BinPackArguments: false, BinPackParameters: true, ColumnLimit: 0}" },
			-- extra_args = { "--style={BasedOnStyle: Microsoft, BreakBeforeBraces: Allman, AlignAfterOpenBracket: DontAlign }" },
		},
		--, IndentAccessModifiers: true
		formatting.prettierd.with {
			-- extra_filetypes = { "toml", "solidity" },
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote", "--use-tabs" },
		},
		actions.eslint_d,
		diagnostics.eslint_d,
		-- actions.gitsigns,
		-- formatting.google_java_format,
	},
}

vim.notify = function(msg, ...)
	if msg:match("error: method textDocument/documentHighlight is not supported by any of the servers registered for the current buffer") then
		return
	end

	vim.notify(msg, ...)
end
