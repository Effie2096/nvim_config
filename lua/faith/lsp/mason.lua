local servers = {
	"jdtls",
	"sumneko_lua",
	"lemminx",
	"clangd",
	"cmake",
	"tsserver",
	"html",
	"emmet_ls",
	"cssls",
	"cssmodules_ls",
	"jsonls",
	"rust_analyzer",
	"taplo",
}

local icons = require("faith.icons")

local settings = {
	ui = {
		border = "single",
		icons = {
			package_installed = icons.ui.Check,
			package_pending = icons.ui.Mason,
			package_uninstalled = icons.ui.Circle_Empty,
		},
	},
	log_level = vim.log.levels.DEBUG,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.pory" },
	callback = function(a)
		local active_clients = vim.lsp.get_active_clients({ name = "poryscript_pls" })
		if next(active_clients) == nil then
			local client_id = vim.lsp.start_client({
				name = "poryscript_pls",
				cmd = { "poryscript-pls-linux" },
				root_dir = vim.fs.dirname(vim.fs.find({ "porymap.project.cfg" }, { upward = true })[1]),
				on_attach = require("faith.lsp.handlers").on_attach,
				capabilities = require("faith.lsp.handlers").capabilities,
			})
			if next(vim.lsp.get_active_clients({ id = client_id, bufnr = a.buf })) == nil then
				vim.lsp.buf_attach_client(a.buf, client_id)
			end
		end
	end,
})

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("faith.lsp.handlers").on_attach,
		capabilities = require("faith.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@", {})[1]

	if server == "sumneko_lua" then
		local sumneko_opts = require("faith.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
		local status_ok, neodev = pcall(require, "neodev")
		if not status_ok then
			return
		end
		neodev.setup({
			-- add any options here, or leave empty to use the default settings
			-- lspconfig = opts,
			lspconfig = {
				on_attach = opts.on_attach,
				capabilities = opts.capabilities,
				setting = {
					Lua = {
						runtime = {
							hint = {
								enable = true,
								arrayIndex = "Enable", -- "Enable", "Auto", "Disable"
								await = true,
								paramName = "All", -- "All", "Literal", "Disable"
								paramType = true,
								semicolon = "Disable", -- "All", "SameLine", "Disable"
								setType = true,
							},
						},
					},
				},
				--	 -- settings = opts.settings,
			},
		})
		lspconfig.sumneko_lua.setup(opts)
		goto continue
	end

	if server == "tsserver" then
		local tsserver_opts = require("faith.lsp.settings.tsserver")
		opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
	end

	if server == "jsonls" then
		local jsonls_opts = require("faith.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server == "emmet_ls" then
		local emmet_ls_opts = require("faith.lsp.settings.emmet_ls")
		opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
	end

	if server == "clangd" then
		opts.capabilities.offsetEncoding = { "utf-16" }
	end

	if server == "lemminx" then
		local lemminx_opts = require("faith.lsp.settings.lemminx")
		opts = vim.tbl_deep_extend("force", lemminx_opts, opts)
	end
	-- special case: configured in ftplugin/java.lua
	if server == "jdtls" then
		goto continue
	end

	if server == "rust_analyzer" or server == "rust_analyzer-standalone" then
		local rust_analyzer_opts = require("faith.lsp.settings.rust")
		opts = vim.tbl_deep_extend("force", rust_analyzer_opts, opts)

		if pcall(require, "rust-tools") then
			local rust_tools_opts = require("faith.lsp.settings.rust-tools")
			local rust_opts = {
				server = opts,
			}
			rust_opts = vim.tbl_deep_extend("force", rust_opts, rust_tools_opts)
			require("rust-tools").setup(rust_opts)
			goto continue
		end
	end

	lspconfig[server].setup(opts)
	::continue::
end
