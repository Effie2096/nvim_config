local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local actions = null_ls.builtins.code_actions

null_ls.setup({
	debug = false,
	sources = {
		diagnostics.gitlint,
		actions.shellcheck,
		diagnostics.clang_check,
		diagnostics.cmake_lint.with({
			command = "cmakelint",
		}),
		diagnostics.flake8,
	},
})

--[[ vim.notify = function(msg, ...)
	if
		msg:match(
			"error: method textDocument/documentHighlight is not supported by any of the servers registered for the current buffer"
		)
	then
		return
	end

	vim.notify(msg, ...)
end ]]
