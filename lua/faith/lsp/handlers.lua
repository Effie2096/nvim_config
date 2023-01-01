local fk = require('faith.keymap')
local nnoremap = fk.nnoremap
local vnoremap = fk.vnoremap

local M = {}

local diagnostic_icons = require('faith.icons').diagnostic

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = false

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_cmp_ok then
	M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)
end


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
		virtual_text = {
			source = false,
			format = function (diagnostic)
				if vim.api.nvim_buf_get_option(0, 'filetype') == 'rust' then
					return string.gsub(
						diagnostic.message,
						'`#%[.*%(.*%)%]` on by default[\n\r]',
						'',
						1
					)
				end
				return diagnostic.message
			end
		},
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			border = "none",
			source = "if_many",
			header = "",
			prefix = function (_, i, _)
				return string.format("%s: ", i)
			end,
			-- width = 40,
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "none",
		width = 60,
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
		callback = function ()
			vim.lsp.codelens.refresh()
		end
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
						line = vim.fn.readfile(file_name, '', start_line)[start_line]
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
		vim.fn.setqflist(entries, 'r')
	end)
end

local function ufo_hover(callback)
	return function()
		local winid = require('ufo').peekFoldedLinesUnderCursor()
		if not winid then
			callback()
		end
	end
end

local function formatting_maps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]]
	-- vim.cmd [[ command! Format execute 'lua Reset_Spaces(true)' ]]
	nnoremap("<M-f>", vim.cmd.Format, opts)
	vnoremap("<M-f>", vim.cmd.Format, opts)
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	nnoremap("K", ufo_hover(
		function ()
				vim.lsp.buf.hover()
		end
		),
		opts
	)

	nnoremap("<leader>ld", vim.lsp.buf.definition, opts)
	nnoremap("<leader>lD", vim.lsp.buf.declaration, opts)
	nnoremap("<leader>li", vim.lsp.buf.implementation, opts)
	nnoremap("<leader>lr", vim.lsp.buf.references, opts)
	nnoremap("<leader>ls", vim.lsp.buf.signature_help, opts)
	nnoremap("<leader>dl", vim.diagnostic.open_float, opts)
	nnoremap("<leader>dj", vim.diagnostic.goto_next, opts)
	nnoremap("<leader>dk", vim.diagnostic.goto_prev, opts)
	nnoremap("<leader>dq", vim.diagnostic.setqflist, opts)
	nnoremap("<leader>a", vim.lsp.buf.code_action, opts)
end

local function jdt_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	-- nnoremap("<M-a>", require 'jdtls'.organize_imports, opts)
	vnoremap("<leader>em", "<cmd> lua require('jdtls').extract_method(true)<CR>", opts)
	nnoremap("<leader>ev", require('jdtls').extract_variable, opts)
	vnoremap("<leader>ev", "<cmd> lua require('jdtls').extract_variable(true)<CR>", opts)
	nnoremap("<leader>ec", require('jdtls').extract_constant, opts)
	vnoremap("<leader>ec", "<cmd> lua require('jdtls').extract_constant(true)<CR>", opts)
	nnoremap("<leader>tm", require 'jdtls'.test_nearest_method, opts)
	nnoremap("<leader>tc", require 'jdtls'.test_class, opts)

	vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
	vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
	vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
	vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
	-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
	vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"
end

local function rust_keymaps (bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	if pcall(require, "rust-tools") then
		nnoremap("<leader>rh", require'rust-tools.hover_actions'.hover_actions, opts)
		nnoremap("<leader>rr", require'rust-tools'.runnables.runnables, opts)
	end
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	formatting_maps(bufnr)

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
		local status_ok, inlayhints = pcall(require, 'lsp-inlayhints')
		if status_ok then
			inlayhints.on_attach(client, bufnr)
		end
	end

	if client.name == "jdtls" then
		jdt_keymaps(bufnr)
		-- vim.lsp.codelens.refresh()
		-- vim.cmd [[autocmd BufEnter,InsertLeave *.java lua vim.lsp.codelens.refresh()]]
		-- if JAVA_DAP_ACTIVE then
		require("jdtls").setup_dap { hotcodereplace = "auto" }
		require("jdtls.dap").setup_dap_main_class_configs()
		-- end
		require("lsp-inlayhints").on_attach(client, bufnr)
	end

	if client.name == "rust_analyzer" then
		rust_keymaps(bufnr)
	end

end

function Reset_Spaces(async)
	vim.lsp.buf.format({ async = async })
	-- vim.cmd('%retab!')
end

function M.enable_format_on_save()
	local format_on_save_group = vim.api.nvim_create_augroup("format_on_save", { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		group = format_on_save_group,
		pattern = "*",
		callback = function()
			Reset_Spaces(false)
		end,
	})
	vim.notify "Enabled format on save"
end

function M.disable_format_on_save()
	M.remove_augroup "format_on_save"
	vim.notify "Disabled format on save"
end

function M.toggle_format_on_save()
	if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
		M.enable_format_on_save()
	else
		M.disable_format_on_save()
	end
end

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.cmd("au! " .. name)
	end
end

-- vim.cmd [[ command! LspToggleAutoFormat execute 'lua require("faith.lsp.handlers").toggle_format_on_save()' ]]
vim.api.nvim_create_user_command('LspToggleAutoFormat',
	function()
		require("faith.lsp.handlers").toggle_format_on_save()
	end,
	{}
)

return M
