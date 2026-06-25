local M = {}

M.lsp_keymaps = function(bufnr)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
	end

	vim.keymap.set("n", "K", vim.lsp.buf.hover)
	map(
		"grd",
		vim.lsp.buf.definition,
		"lsp [d]efinition: Jump to symbol definition."
	)
	map(
		"grt",
		vim.lsp.buf.type_definition,
		"lsp [t]ype definition: Jump to symbol type definition."
	)
	map(
		"grD",
		vim.lsp.buf.declaration,
		"lsp [D]eclaration: Jump to symbol declaration."
	)
	-- map(
	-- 	"<leader>li",
	-- 	vim.lsp.buf.implementation,
	-- 	"[l]sp [i]mplementation: Jump to symbol implementation."
	-- )
	-- map(
	-- 	"<leader>lr",
	-- 	vim.lsp.buf.references,
	-- 	"[l]sp [r]eferences: List references of symbol under cursor."
	-- )
	map(
		"grs",
		vim.lsp.buf.signature_help,
		"lsp [s]ignature: Show function signature."
	)
	map(
		"<leader>dq",
		vim.diagnostic.setqflist,
		"[d]iagnostic [q]uickfix: Add workspace diagnostics to quickfix list."
	)
	-- map(
	-- 	"<leader>a",
	-- 	vim.lsp.buf.code_action,
	-- 	"code [a]ction: List code actions available at cursor's position."
	-- )
	-- map(
	-- 	"<leader>a",
	-- 	vim.lsp.buf.code_action,
	-- 	"code [a]ction: List code actions available for selection.",
	-- 	{ "v" }
	-- )
	map(
		"<leader>dl",
		vim.diagnostic.open_float,
		"[d]iagnostic [l]ist: Open float listing all diagnostics on line."
	)
	-- map(
	-- 	"<leader>rn",
	-- 	vim.lsp.buf.rename,
	-- 	"[r]e[n]ame: Rename symbol under cursor."
	-- )
end

M.on_attach = function(client_id, bufnr)
	M.lsp_keymaps(bufnr)
	-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
	---@param client vim.lsp.Client
	---@param method vim.lsp.protocol.Method
	---@param bufnr? integer some lsp support methods only in specific files
	---@return boolean
	local function client_supports_method(client, method, bufnr)
		return client:supports_method(method, bufnr)
	end

	-- The following two autocommands are used to highlight references of the
	-- word under your cursor when your cursor rests there for a little while.
	--    See `:help CursorHold` for information about when this is executed
	--
	-- When you move your cursor, the highlights will be cleared (the second autocommand).
	local client = vim.lsp.get_client_by_id(client_id)
	if
		client
		and client_supports_method(
			client,
			vim.lsp.protocol.Methods.textDocument_documentHighlight,
			bufnr
		)
	then
		local highlight_augroup =
			vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
			callback = function(event2)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({
					group = "lsp-highlight",
					buffer = event2.buf,
				})
			end,
		})
	end

	-- The following code creates a keymap to toggle inlay hints in your
	-- code, if the language server you are using supports them
	--
	-- This may be unwanted, since they displace some of your code
	if
		client
		and client_supports_method(
			client,
			vim.lsp.protocol.Methods.textDocument_inlayHint,
			bufnr
		)
	then
		vim.lsp.inlay_hint.enable(false)
		vim.keymap.set("n", "<leader>uh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
				bufnr = bufnr,
			}))
		end, { buffer = bufnr, desc = "[t]oggle Inlay [h]ints" })
	end

	-- if
	-- 	client
	-- 	and client_supports_method(
	-- 		client,
	-- 		vim.lsp.protocol.Methods.textDocument_codeLens,
	-- 		bufnr
	-- 	)
	-- then
	-- 	vim.lsp.codelens.enable(true, { bufnr = bufnr })
	-- 	local auto_refresh_codelens =
	-- 		vim.api.nvim_create_augroup("RefreshCodelens", { clear = false })
	-- 	vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
	-- 		group = auto_refresh_codelens,
	-- 		buffer = bufnr,
	-- 		callback = function()
	-- 			vim.lsp.codelens.enable(true, {
	-- 				bufnr = bufnr,
	-- 			})
	-- 		end,
	-- 	})
	-- end

	if
		client
		and client_supports_method(
			client,
			vim.lsp.protocol.Methods.workspace_didChangeWatchedFiles,
			bufnr
		)
	then
		client.capabilities = vim.tbl_deep_extend("force", client.capabilities, {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		})
	end

	if client and client.name == "svelte" then
		vim.api.nvim_create_autocmd("BufWritePost", {
			-- pattern = { "*.js", "*.ts" },
			buffer = bufnr,
			callback = function(ctx)
				client:notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			end,
		})
	end
end

return M
