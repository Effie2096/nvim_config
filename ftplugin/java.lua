local indentWidth = 4
vim.opt_local.tabstop = indentWidth
-- vim.opt.softtabstop=indentWidth								-- Insert 4 spaces for a tab
vim.opt_local.shiftwidth = indentWidth -- Change the number of space characters inserted for indentation
-- vim.opt_local.foldcolumn = "auto:2"
local build_command = "mvn clean compile -Dmaven.test.skip=true"

vim.opt_local.makeprg = build_command
vim.cmd([[setlocal errorformat=[%tRROR]\ %f:[%l]\ %m,%-G%.%#]])

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local desc = fk.desc

local bufnr = vim.api.nvim_get_current_buf()

local function find_build_method(markers, bufname)
	bufname = bufname or vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	local dirname = vim.fn.fnamemodify(bufname, ":p:h")
	local getparent = function(p)
		return vim.fn.fnamemodify(p, ":h")
	end
	while getparent(dirname) ~= dirname do
		for _, marker in ipairs(markers) do
			if vim.loop.fs_stat(require("jdtls.path").join(dirname, marker)) then
				return marker
			end
		end
		dirname = getparent(dirname)
	end
end

local build_markers = { "mvnw", "pom.xml", "gradlew", "build.gradle" }
local found_build = find_build_method(build_markers)

if vim.fn.exists("*VimuxRunCommand") ~= 0 then
	local opts = { noremap = true, silent = true, buffer = bufnr }
	nnoremap(
		"<F3>",
		"<cmd>AsyncRun -mode=term -pos=tmux -cwd=<root> " .. build_command .. "<cr>",
		desc(opts, "Compile Project")
	)
	if found_build == "mvnw" or found_build == "pom.xml" then
		nnoremap("<F4>", "<cmd>AsyncRun -mode=term -pos=tmux -cwd=<root> mvn exec:java<cr>", desc(opts, "Run Project"))
	end
end

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
extendedClientCapabilities.progressReportProvider = false

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
	return
end

local home = os.getenv("HOME")
if vim.fn.has("unix") == 1 then
	WORKSPACE_PATH = home .. "/Documents/dev/workspace/"
	CONFIG = "linux"
elseif vim.fn.has("win32") == 1 then
	WORKSPACE_PATH = home .. "/Documents/dev/workspace/"
	-- WORKSPACE_PATH = 'G:/dev/Java_Projects/workspace/'
	CONFIG = "win"
else
	print("Unsupported system")
end

local jdtloc = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

if vim.fn.has("win32") == 1 and vim.fn.isdirectory(workspace_dir) == 0 then
	local dir = string.gsub(workspace_dir, "\\", "/")
	print("...making workspace directory " .. dir)
	vim.cmd('call mkdir("' .. dir .. '", ["p"])')
	print("Workspace directory created!")
end

local bundles = {}
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(
			vim.fn.stdpath("data")
				.. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
		),
		"\n",
		{}
	)
)
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(
	bundles,
	vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar"), "\n")
)

local opts = { noremap = true, buffer = bufnr }
nnoremap("<leader>da", function()
	vim.ui.input({ prompt = "Args>", default = "" }, function(input)
		if not require("faith.functions").isempty(input) then
			require("dap").run(
				vim.tbl_deep_extend("force", require("dap").configurations.java[1], { args = tostring(input) })
			)
		else
			require("dap").continue()
			vim.notify("No args provided. Running debugger with defaults.")
		end
	end)
end, desc(opts, "[d]ebug with [a]rgs: Run default java debugger launch profile with provided arguments."))

local function progress_report(_, result, ctx)
	local lsp = vim.lsp
	local info = {
		client_id = ctx.client_id,
	}

	local kind = "report"
	if result.complete then
		kind = "end"
	elseif result.workDone == 0 then
		kind = "begin"
	elseif result.workDone > 0 and result.workDone < result.totalWork then
		kind = "report"
	else
		kind = "end"
	end

	local percentage = 0
	if result.totalWork > 0 and result.workDone >= 0 then
		percentage = result.workDone / result.totalWork * 100
	end

	local msg = {
		token = result.id,
		value = {
			kind = kind,
			percentage = percentage,
			title = result.task,
			message = result.subTask,
		},
	}
	-- print(vim.inspect(result))
	lsp.handlers["$/progress"](nil, msg, info)
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {

		-- 💀
		"java", -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. vim.fn.glob(jdtloc .. "/lombok.jar"),
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		---@diagnostic disable-next-line: missing-parameter
		vim.fn.glob(jdtloc .. "/plugins/org.eclipse.equinox.launcher_*.jar"),

		-- 💀
		"-configuration",
		vim.fn.glob(jdtloc .. "/config_" .. CONFIG),

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},

	on_attach = require("faith.lsp.handlers").on_attach,

	capabilities = capabilities,

	handlers = {
		["language/progressReport"] = progress_report,
	},
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
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
			format = {
				settings = {
					url = home .. "/.local/share/eclipse/mystyleuwuv1.xml",
					profile = "GoogleStyle",
				},
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
		},
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
require("jdtls").start_or_attach(config)
