local indentWidth = 4
vim.opt_local.tabstop = indentWidth
-- vim.opt.softtabstop=indentWidth								-- Insert 4 spaces for a tab
vim.opt_local.shiftwidth = indentWidth -- Change the number of space characters inserted for indentation
-- vim.opt_local.foldcolumn = "auto:2"
vim.opt_local.makeprg = "mvn clean compile -Dskiptests -q -f pom.xml"
vim.opt_local.errorformat = "[ERROR] %f:[%l\\,%v] %m"

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local status, jdtls = pcall(require, "jdtls")
if not status then
	return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
	return
end

local home = os.getenv "HOME"
if vim.fn.has "unix" == 1 then
	WORKSPACE_PATH = '/mnt/sdb2/dev/Java_Projects/workspace/'
	CONFIG = "linux"
elseif vim.fn.has "win32" == 1 then
	WORKSPACE_PATH = home .. "/workspace/"
	CONFIG = "win"
else
	print("Unsupported system")
end

local jdtloc = home .. '/.local/share/nvim/mason/packages/jdtls'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

local bundles = {
}
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(bundles,
	vim.split(
		vim.fn.glob(home .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
		"\n", {})
)
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/vscode-java-test/server/*.jar"), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {

		-- 💀
		'java', -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-javaagent:' .. jdtloc .. '/lombok.jar',
		'-Xms1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens',
		'java.base/java.util=ALL-UNNAMED',
		'--add-opens',
		'java.base/java.lang=ALL-UNNAMED',

		-- 💀
		'-jar',
		---@diagnostic disable-next-line: missing-parameter
		vim.fn.glob(jdtloc .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^																			 ^^^^^^^^^^^^^^
		-- Must point to the																										 Change this to
		-- eclipse.jdt.ls installation																					 the actual version


		-- 💀
		'-configuration', jdtloc .. '/config_' .. CONFIG,
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^				^^^^^^
		-- Must point to the											Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation						Depending on your system.


		-- 💀
		-- See `data directory configuration` section in the README
		'-data', workspace_dir
	},

	on_attach = require('faith.lsp.handlers').on_attach,

	capabilities = capabilities,
	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = root_dir,

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			--[[ inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			}, ]]
			format = {
				enabled = false,
			}
		},
		signatureHelp = { enabled = false },
		contentProvider = { preferred = 'fernflower' },
		extendedClientCapabilities = extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
		--[[ on_init = function(client)
			if client.config.settings then
				client.notify('workspace/didChangeConfiguration',
				{ settings = client.config.settings })
			end
		end ]]
	},
	flags = {
		allow_incremental_sync = true,
	},
	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = bundles,
	},
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
