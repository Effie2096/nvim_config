vim.opt_local.textwidth = 120
vim.opt_local.colorcolumn = "+0,-20"

local jdtls = require("jdtls")
local bundles = {
	vim.fn.glob(
		"$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar",
		true
	),
}

local java_test_bundles = vim.split(
	vim.fn.glob("$MASON/packages/java-test/extension/server/*.jar", true),
	"\n"
)
local excluded = {
	"com.microsoft.java.test.runner-jar-with-dependencies.jar",
	"jacocoagent.jar",
}
vim.list_extend(
	bundles,
	vim
		.iter(java_test_bundles)
		:filter(function(jar)
			local name = vim.fn.fnamemodify(jar, ":t")
			return not vim.tbl_contains(excluded, name)
		end)
		:totable()
)

local config = {
	name = "jdtls",
	cmd = { "jdtls" },
	root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),
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
					exclusions = { "this" },
				},
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
		},
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
	init_options = {
		bundles = bundles,
	},
}

jdtls.start_or_attach(config)
