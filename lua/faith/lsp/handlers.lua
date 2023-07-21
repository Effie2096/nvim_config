local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local vnoremap = fk.vnoremap
local desc = fk.desc

local M = {}

local diagnostic_icons = require("faith.icons").diagnostic

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = false

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_cmp_ok then
	M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
end

local float_config = {
	focusable = false,
	border = "single",
	source = false,
	header = "",
	prefix = function(_, i, _)
		return string.format("%s: ", i)
	end,
	-- width = 40,
	--[[ width = function()
				local vim_width = vim.api.nvim_get_option_value("columns", { scope = "global" })
				return vim_width / 2 < 61 and vim_width / 2 or 100
	end, ]]
}

vim.api.nvim_create_augroup("diagnostics", { clear = true })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	group = "diagnostics",
	callback = function()
		vim.diagnostic.setloclist({ open = false })
	end,
})

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = diagnostic_icons.error },
		{ name = "DiagnosticSignWarn", text = diagnostic_icons.warn },
		{ name = "DiagnosticSignHint", text = diagnostic_icons.hint },
		{ name = "DiagnosticSignInfo", text = diagnostic_icons.info },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false, --[[ {
	source = false,
	format = function(diagnostic)
		if vim.api.nvim_get_option_value("filetype", { scope = "local" }) == "rust" then
			diagnostic.message = string.gsub(diagnostic.message, "`#%[.*%(.*%)%]` on by default", "", 1)
			diagnostic.message = string.gsub(diagnostic.message, "for further information visit.*", "", 1)
		end
		return diagnostic.message
	end,
},]]
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = float_config,
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
		-- width = 60,
		-- height = 30,
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
		-- width = 60,
		-- height = 30,
	})
end

-- Create a custom namespace. This will aggregate signs from all other
-- namespaces and only show the one with the highest severity on a
-- given line
local ns = vim.api.nvim_create_namespace("my_namespace")

-- Get a reference to the original signs handler
local orig_signs_handler = vim.diagnostic.handlers.signs

-- Override the built-in signs handler
vim.diagnostic.handlers.signs = {
	show = function(_, bufnr, _, opts)
		-- Get all diagnostics from the whole buffer rather than just the
		-- diagnostics passed to the handler
		local diagnostics = vim.diagnostic.get(bufnr)

		-- Find the "worst" diagnostic per line
		local max_severity_per_line = {}
		for _, d in pairs(diagnostics) do
			local m = max_severity_per_line[d.lnum]
			if not m or d.severity < m.severity then
				max_severity_per_line[d.lnum] = d
			end
		end

		-- Pass the filtered diagnostics (with our custom namespace) to
		-- the original handler
		local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
		orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
	end,
	hide = function(_, bufnr)
		orig_signs_handler.hide(ns, bufnr)
	end,
}

local function refresh_codelens(bufnr)
	local auto_refresh_codelens = vim.api.nvim_create_augroup("RefreshCodelens", { clear = false })
	vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
		group = auto_refresh_codelens,
		buffer = bufnr,
		callback = function()
			vim.lsp.codelens.refresh()
		end,
	})
end

local function symbol_highlight(buffer)
	local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = group,
		buffer = buffer,
		callback = function()
			vim.lsp.buf.document_highlight()
		end,
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = group,
		buffer = buffer,
		callback = function()
			vim.lsp.buf.clear_references()
		end,
	})
end

local function attach_navic(client, bufnr)
	-- vim.g.navic_silence = true
	local status_ok, navic = pcall(require, "nvim-navic")
	if not status_ok then
		return
	end
	navic.attach(client, bufnr)
end

local function attach_inlay(client, bufnr)
	local status_ok, inlayhints = pcall(require, "lsp-inlayhints")
	if status_ok then
		inlayhints.on_attach(client, bufnr)
	end
end

M.rename = function()
	---@diagnostic disable-next-line: missing-parameter
	local position_params = vim.lsp.util.make_position_params()
	-- print(vim.inspect(position_params))
	local new_name = "new_name"

	position_params.newName = new_name

	---@diagnostic disable-next-line: param-type-mismatch, unused-local
	vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, result, ctx)
		vim.lsp.buf.rename()

		local entries = {}
		if result.changes then
			for uri, edits in pairs(result.changes) do
				local bufnr = vim.uri_to_bufnr(uri)
				local file_name = vim.fn.substitute(uri, "file://", "", "")

				for _, edit in ipairs(edits) do
					local start_line = edit.range.start.line + 1
					local line = ""
					if not vim.api.nvim_buf_is_loaded(bufnr) then
						line = vim.fn.readfile(file_name, "", start_line)[start_line]
					else
						line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]
					end

					table.insert(entries, {
						bufnr = bufnr,
						lnum = start_line,
						col = edit.range.start.character + 1,
						text = line,
					})
				end
			end
		end

		-- vim.lsp.handlers["textDocument/rename"](err, result, ctx, ...)
		vim.fn.setqflist(entries, "r")
	end)
end

local function ufo_hover(callback)
	return function()
		local winid = require("ufo").peekFoldedLinesUnderCursor()
		if not winid then
			callback()
		end
	end
end

local function formatting_maps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.cmd([[ command! Format execute 'lua Formatting({ async = true })' ]])
	nnoremap(
		"<M-f>",
		vim.cmd.Format,
		desc(opts, "[f]ormat: Run formatter (if there is one set up) for the current file.")
	)
	vnoremap(
		"<M-f>",
		vim.cmd.Format,
		desc(opts, "[f]ormat: Run formatter (if there is one set up) for the selected range.")
	)
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	nnoremap(
		"K",
		ufo_hover(function()
			if package.loaded.lspsaga ~= nil then
				vim.cmd(":Lspsaga hover_doc")
			end
			vim.lsp.buf.hover()
		end),
		opts
	)

	nnoremap("<leader>ld", vim.lsp.buf.definition, desc(opts, "[l]sp [d]efinition: Jump to symbol definition."))
	nnoremap(
		"<leader>lt",
		vim.lsp.buf.type_definition,
		desc(opts, "[l]sp [t]ype definition: Jump to symbol type definition.")
	)
	nnoremap("<leader>lD", vim.lsp.buf.declaration, desc(opts, "[l]sp [D]eclaration: Jump to symbol declaration."))
	nnoremap(
		"<leader>li",
		vim.lsp.buf.implementation,
		desc(opts, "[l]sp [i]mplementation: Jump to symbol implementation.")
	)
	nnoremap(
		"<leader>lr",
		vim.lsp.buf.references,
		desc(opts, "[l]sp [r]eferences: List references of symbol under cursor.")
	)
	nnoremap("<leader>ls", vim.lsp.buf.signature_help, desc(opts, "[l]sp [s]ignature: Show function signature."))
	nnoremap(
		"<leader>dq",
		vim.diagnostic.setqflist,
		desc(opts, "[d]iagnostic [q]uickfix: Add workspace diagnostics to quickfix list.")
	)

	if package.loaded.lspsaga ~= nil then
		nnoremap(
			"<leader>lf",
			"<cmd>Lspsaga finder<cr>",
			desc(opts, "[L]sp [F]inder: List all definitions and references of symbol under cursor")
		)

		nnoremap(
			"<leader>dl",
			"<cmd>Lspsaga show_line_diagnostics ++unfocus<cr>",
			desc(opts, "[d]iagnostic [l]ist: Open float listing all diagnostics on line.")
		)
		-- nnoremap("<leader>dl", require('lspsaga.diagnostic').show_cursor_diagnostics, opts)
		nnoremap(
			"<leader>dj",
			"<cmd>Lspsaga diagnostic_jump_next<cr>",
			desc(opts, "[d]iagnostic [down]: Jump to next diagnostic in file.")
		)
		nnoremap(
			"<leader>dk",
			"<cmd>Lspsaga diagnostic_jump_prev<cr>",
			desc(opts, "[d]iagnostic [up]: Jump to prev diagnostic in file.")
		)

		nnoremap("<leader>a", function()
			require("lspsaga.codeaction"):code_action()
		end, opts)
		vnoremap("<leader>a", function()
			require("lspsaga.codeaction"):code_action()
		end, opts)
		nnoremap("<leader>rn", "<cmd>Lspsaga rename<cr>", desc(opts, "[r]e[n]ame: Rename symbol under cursor."))
	else
		nnoremap(
			"<leader>dl",
			vim.diagnostic.open_float,
			desc(opts, "[d]iagnostic [l]ist: Open float listing all diagnostics on line.")
		)
		nnoremap(
			"<leader>dj",
			vim.diagnostic.goto_next,
			desc(opts, "[d]iagnostic [down]: Jump to next diagnostic in file.")
		)
		nnoremap(
			"<leader>dk",
			vim.diagnostic.goto_prev,
			desc(opts, "[d]iagnostic [up]: Jump to prev diagnostic in file.")
		)
		nnoremap(
			"<leader>a",
			vim.lsp.buf.code_action,
			desc(opts, "code [a]ction: List code actions available at cursor's position.")
		)
		vnoremap(
			"<leader>a",
			vim.lsp.buf.code_action,
			desc(opts, "code [a]ction: List code actions available for selection.")
		)
		nnoremap(
			"<leader>rn",
			require("faith.lsp.handlers").rename,
			desc(opts, "[r]e[n]ame: Rename symbol under cursor.")
		)
	end
end

local function jdt_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	nnoremap("<M-a>", require("jdtls").organize_imports, desc(opts, "Organize Java Imports."))
	vnoremap(
		"<leader>em",
		"<esc><cmd> lua require('jdtls').extract_method(true)<CR>",
		desc(opts, "[e]xtract [m]ethod: Extract selection to new method.")
	)
	local ev_desc = "[e]xtract [v]ariable."
	nnoremap("<leader>ev", require("jdtls").extract_variable, desc(opts, ev_desc))
	vnoremap("<leader>ev", "<cmd> lua require('jdtls').extract_variable(true)<CR>", desc(opts, ev_desc))
	local ec_desc = "[e]xtract [c]onstant."
	nnoremap("<leader>ec", require("jdtls").extract_constant, desc(opts, ec_desc))
	vnoremap("<leader>ec", "<cmd> lua require('jdtls').extract_constant(true)<CR>", desc(opts, ec_desc))

	nnoremap("<leader>tm", function()
		require("jdtls").test_nearest_method()
		require("dapui").open({ layout = 2 })
	end, desc(opts, "[t]est [m]ethod: Run java test under cursor."))
	nnoremap("<leader>tc", function()
		require("jdtls").test_class()
		require("dapui").open({ layout = 2 })
	end, desc(opts, "[t]est [c]lass: Run java test class"))

	vim.cmd(
		"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
	)
	vim.cmd(
		"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
	)
	vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
	vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
	-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
	vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")
end

local function rust_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	if pcall(require, "rust-tools") then
		nnoremap("<leader>rh", require("rust-tools.hover_actions").hover_actions, desc(opts, "[r]ust [h]over."))
		nnoremap("<leader>rr", require("rust-tools").runnables.runnables, desc(opts, "[r]ust [r]unnables."))
	end
end

local function refactor_keymaps(bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true, expr = false }
	-- Remaps for the refactoring operations currently offered by the plugin
	vnoremap(
		"<leader>re",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
		desc(opts, "[r]efactor [e]xtract: Extract selection to new function.")
	)
	vnoremap(
		"<leader>rf",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
		desc(opts, "[r]efactor to [f]ile: Extract selection to new function in new file.")
	)
	vnoremap(
		"<leader>rv",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
		desc(opts, "[r]efactor [v]ariable: Extract selected variable.")
	)
	vnoremap(
		"<leader>ri",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
		desc(opts, "[r]efactor [i]nline: Inline selected variable.")
	)

	-- Extract block doesn't need visual mode
	nnoremap(
		"<leader>rb",
		[[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
		desc(opts, "[r]efactor [b]lock: Extract surrounding block to new function.")
	)
	nnoremap(
		"<leader>rbf",
		[[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
		desc(opts, "[r]efactor [b]lock to [f]ile: Extract surrounding block to new function in new file.")
	)

	-- Inline variable can also pick up the identifier currently under the cursor without visual mode
	nnoremap(
		"<leader>ri",
		[[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
		desc(opts, "[r]efactor [i]nline: Inline variable under cursor.")
	)
	-- You can also use below = true here to to change the position of the printf
	-- statement (or set two remaps for either one). This remap must be made in normal mode.
	nnoremap(
		"<leader>rpo",
		"<cmd>lua require('refactoring').debug.printf({below = true})<CR>",
		desc(opts, "[r]efactor [p]rint [o]utline: Create print statement outlining current location in file.")
	)

	-- Print var

	-- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
	nnoremap(
		"<leader>rpv",
		"<cmd>lua require('refactoring').debug.print_var({ normal = true })<CR>",
		desc(opts, "[r]efactor [p]rint [v]ariable: Create print statement for variable under cursor.")
	)
	-- Remap in visual mode will print whatever is in the visual selection
	vnoremap(
		"<leader>rpv",
		"<cmd>lua require('refactoring').debug.print_var({})<CR>",
		desc(opts, "[r]efactor [p]rint [v]ariable: Create print statement for first variable/function in selection.")
	)

	-- Cleanup function: this remap should be made in normal mode
	nnoremap(
		"<leader>rpc",
		"<cmd>lua require('refactoring').debug.cleanup({})<CR>",
		desc(
			opts,
			"[r]efactor [p]rint [c]leanup: Automated cleanup of all print statements generated by refactor binds."
		)
	)
end

local function create_refactor_keymaps(bufnr)
	local status_ok, _ = pcall(require, "refactoring")
	if not status_ok then
		return
	end
	-- filetypes currently supported by refactor plugin
	local refactor_filetypes = { "typescript", "javascript", "lua", "c", "cpp", "go", "py", "java", "php", "rb" }
	-- check the filetype of the buffer is supported by plugin
	if
		vim.tbl_contains(
			refactor_filetypes,
			vim.api.nvim_get_option_value("filetype", { scope = "local", buf = bufnr })
		)
	then
		-- don't need to check if filetype is in client.config.filetypes
		-- because this is being called from on_attach which already
		-- is only called if a ls can attach to buffer.
		refactor_keymaps(bufnr)
	end
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	formatting_maps(bufnr)
	create_refactor_keymaps(bufnr)

	if client.server_capabilities.documentSymbolProvider then
		attach_navic(client, bufnr)
	end

	if client.server_capabilities.documentHighlightProvider then
		symbol_highlight(bufnr)
	end

	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.refresh()
		refresh_codelens(bufnr)
	end

	if client.server_capabilities.inlayHintProvider then
		attach_inlay(client, bufnr)
	end

	if client.name == "jdtls" then
		jdt_keymaps(bufnr)
		-- vim.lsp.codelens.refresh()
		-- vim.cmd [[autocmd BufEnter,InsertLeave *.java lua vim.lsp.codelens.refresh()]]
		-- if JAVA_DAP_ACTIVE then
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()
		-- end
		attach_inlay(client, bufnr)
	end

	if client.name == "rust_analyzer" or client.name == "rust_analyzer-standalone" then
		rust_keymaps(bufnr)
		attach_inlay(client, bufnr)
	end

	if FORMAT_ON_SAVE then
		M.enable_format_on_save()
	end
end

FORMAT_ON_SAVE = true

function Formatting(async)
	vim.lsp.buf.format({ async = async })
	vim.cmd("%retab!")
end

function M.enable_format_on_save()
	local format_on_save_group = vim.api.nvim_create_augroup("format_on_save", { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		group = format_on_save_group,
		pattern = "*",
		callback = function(data)
			local next = next
			if next(vim.lsp.get_active_clients({ bufnr = data.buf })) ~= nil then
				Formatting(false)
			end
		end,
	})
	FORMAT_ON_SAVE = true
end

function M.disable_format_on_save()
	M.remove_augroup("format_on_save")
	FORMAT_ON_SAVE = false
end

function M.toggle_format_on_save()
	if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
		M.enable_format_on_save()
		vim.notify("Enabled format on save")
	else
		M.disable_format_on_save()
		vim.notify("Disabled format on save")
	end
end

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.api.nvim_del_augroup_by_name(name)
	end
end

-- vim.cmd [[ command! LspToggleAutoFormat execute 'lua require("faith.lsp.handlers").toggle_format_on_save()' ]]
vim.api.nvim_create_user_command("LspToggleAutoFormat", function()
	require("faith.lsp.handlers").toggle_format_on_save()
end, {})

return M
