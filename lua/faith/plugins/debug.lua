local icons = require("faith.icons")

local gh = function(str)
	return ("https://github.com/%s"):format(str)
end
vim.pack.add({
	{ src = gh("bfredl/nvim-luadev") },
}, { load = function() end })

vim.pack.add({
	{ src = gh("rcarriga/nvim-dap-ui") },
	{ src = gh("nvim-neotest/nvim-nio") },
	{ src = gh("LiadOz/nvim-dap-repl-highlights") },
	{ src = gh("ofirgall/goto-breakpoints.nvim") },
	{ src = gh("theHamsta/nvim-dap-virtual-text") },

	{ src = gh("jay-babu/mason-nvim-dap.nvim") },
	{ src = gh("mfussenegger/nvim-dap") },

	{ src = gh("Weissle/persistent-breakpoints.nvim") },
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	once = true,
	callback = function()
		if not package.loaded["luadev"] then
			vim.cmd.packadd("nvim-luadev")

			local luadev_group =
				vim.api.nvim_create_augroup("luadev_maps", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				group = luadev_group,
				pattern = { "*.lua" },
				callback = function(args)
					local opts = { silent = true, noremap = true, buffer = args.buf }
					vim.keymap.set(
						{ "n" },
						"<localleader>e",
						"<CMD>Luadev<CR><Plug>(Luadev-RunLine)",
						opts
					)
					vim.keymap.set(
						{ "n", "v" },
						"<localleader>E",
						"<CMD>Luadev<CR><Plug>(Luadev-Run)",
						opts
					)
				end,
			})
		end
	end,
})

local sign = vim.fn.sign_define
sign("DapBreakpoint", {
	text = icons.debug.Breakpoint,
	texthl = "DapBreakpoint",
	linehl = "",
	numhl = "",
})
sign("DapBreakpointCondition", {
	text = icons.debug.BreakpointCond,
	texthl = "DapBreakpointCondition",
	linehl = "",
	numhl = "",
})
sign("DapLogPoint", {
	text = icons.debug.BreakpointLog,
	texthl = "DapLogPoint",
	linehl = "",
	numhl = "",
})

local vt_opts = {
	enable_commands = true,
	only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
	all_references = false, -- show virtual text on all all references of the variable (not only definitions)
	highlight_changed_variables = true,
}
require("nvim-dap-virtual-text").setup(vt_opts)

local dap = require("dap")
local dapui = require("dapui")

local persistent_breakpoints = require("persistent-breakpoints")
persistent_breakpoints.setup({
	load_breakpoints_event = "BufReadPost",
})
require("overseer").enable_dap()

require("mason").setup()
require("mason-nvim-dap").setup({
	-- Makes a best effort to setup the various debuggers with
	-- reasonable debug configurations
	automatic_installation = true,

	-- You can provide additional configuration to the handlers,
	-- see mason-nvim-dap README for more information
	handlers = {
		function(config)
			-- all sources with no handler get passed here

			-- Keep original functionality
			require("mason-nvim-dap").default_setup(config)
		end,
		-- codelldb = function(config)
		-- 	config.configurations = {
		-- 		{
		-- 			name = "LLDB: Launch",
		-- 			type = "codelldb",
		-- 			program = function()
		-- 				return vim.ui.input({
		-- 					prompt = "Path to executable: ",
		-- 					default = vim.fn.getcwd() .. "/",
		-- 					completion = "file",
		-- 				}, function(input) end)
		-- 			end,
		-- 			console = "integratedTerminal",
		-- 		},
		-- 		{
		-- 			name = "LLDB: Launch (args)",
		-- 			program = function()
		-- 				return vim.ui.input({
		-- 					prompt = "Path to executable: ",
		-- 					default = vim.fn.getcwd() .. "/",
		-- 					completion = "file",
		-- 				}, function(input) end)
		-- 			end,
		-- 			args = function()
		-- 				return vim.split(
		-- 					vim.ui.input(
		-- 						{ prompt = "Args: " },
		-- 						function(input)
		-- 							return input or ""
		-- 						end
		-- 					),
		-- 					" +",
		-- 					{ trimempty = true }
		-- 				)
		-- 			end,
		-- 			console = "integratedTerminal",
		-- 		},
		-- 	}
		-- 	require("mason-nvim-dap").default_setup(config)
		-- end,
	},

	-- You'll need to check that you have the required things installed
	-- online, please don't ask me how to install them :)
	ensure_installed = {
		-- Update this to ensure that you have the debuggers for the langs you want
		-- "delve",
	},
})

dap.adapters["local-lua"] = {
	type = "executable",
	command = "node",
	args = {
		vim.fn.expand(
			"$MASON/share/local-lua-debugger-vscode/extension/debugAdapter.js"
		),
	},
	enrich_config = function(config, on_config)
		if not config["extensionPath"] then
			local c = vim.deepcopy(config)
			-- 💀 If this is missing or wrong you'll see
			-- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
			c.extensionPath = vim.fn.expand("$MASON/share/local-lua-debugger-vscode")
			on_config(c)
		else
			on_config(config)
		end
	end,
}
dap.configurations.lua = {
	{
		name = "Local Lua Debugger: Run Love Project",
		type = "local-lua",
		request = "launch",
		cwd = "${workspaceFolder}",
		program = { command = "love" },
		args = { "." },
		scriptRoots = { "game" },
	},
}

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		-- 💀 Make sure to update this path to point to your installation
		args = {
			vim.fn.globpath(
				"$MASON/share/js-debug-adapter",
				"/js-debug/src/dapDebugServer.js",
				true,
				true
			),
			"${port}",
		},
	},
}

-- custom adapter for running tasks before starting debug
local custom_adapter = "pwa-node-custom"
dap.adapters[custom_adapter] = function(cb, config)
	if config.preLaunchTask then
		local async = require("plenary.async")
		local notify = require("notify").async

		async.run(function()
			---@diagnostic disable-next-line: missing-parameter
			notify("Running [" .. config.preLaunchTask .. "]").events.close()
		end, function()
			vim.fn.system(config.preLaunchTask)
			config.type = "pwa-node"
			dap.run(config)
		end)
	end
end

for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		{
			name = "Launch",
			type = "pwa-node",
			request = "launch",
			program = "${file}",
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**" },
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			name = "Attach to node process",
			type = "pwa-node",
			request = "attach",
			rootPath = "${workspaceFolder}",
			processId = require("dap.utils").pick_process,
		},
		{
			name = "Debug Main Process (Electron)",
			type = "pwa-node",
			request = "launch",
			program = "${workspaceFolder}/node_modules/.bin/electron",
			args = {
				"${workspaceFolder}/dist/index.js",
			},
			outFiles = {
				"${workspaceFolder}/dist/*.js",
			},
			resolveSourceMapLocations = {
				"${workspaceFolder}/dist/**/*.js",
				"${workspaceFolder}/dist/*.js",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**" },
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			name = "Compile & Debug Main Process (Electron)",
			type = custom_adapter,
			request = "launch",
			preLaunchTask = "npm run build-ts",
			program = "${workspaceFolder}/node_modules/.bin/electron",
			args = {
				"${workspaceFolder}/dist/index.js",
			},
			outFiles = {
				"${workspaceFolder}/dist/*.js",
			},
			resolveSourceMapLocations = {
				"${workspaceFolder}/dist/**/*.js",
				"${workspaceFolder}/dist/*.js",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**" },
			protocol = "inspector",
			console = "integratedTerminal",
		},
	}
end

-- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
-- dap.listeners.before.event_exited['dapui_config'] = dapui.close

dapui.setup({
	icons = {
		expanded = icons.ui.ArrowFillOpen,
		collapsed = icons.ui.ArrowFillClosed,
	},
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	-- Expand lines larger than the window
	-- Requires >= 0.7
	expand_lines = vim.fn.has("nvim-0.7") == 1,
	layouts = {
		{
			elements = {
				{ id = "repl", size = 0.40 },
				{ id = "console", size = 0.60 },
			},
			size = 8,
			position = "bottom",
		},
		{
			elements = {
				"breakpoints",
				"stacks",
				"watches",
				"scopes",
			},
			size = 40,
			position = "left",
		},
	},
	controls = {
		enabled = true,
		-- Display controls in this element
		element = "repl",
		icons = {
			pause = icons.debug.Pause,
			play = icons.debug.Play,
			step_into = icons.debug.Step_into,
			step_over = icons.debug.Step_over,
			step_out = icons.debug.Step_out,
			step_back = icons.debug.Step_back,
			run_last = icons.debug.Run_last,
			terminate = icons.debug.Terminate,
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "single", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
	render = {
		max_type_length = nil, -- Can be integer or nil.
	},
})

require("nvim-dap-repl-highlights").setup()
require("nvim-treesitter").install({ "dap_repl" })

vim.keymap.set("n", "<Leader>db", function()
	require("persistent-breakpoints.api").toggle_breakpoint()
end, {
	desc = "[d]ebug [b]reakpoint: Toggle debugger breakpoint on current line.",
})
vim.keymap.set("n", "<Leader>dB", function()
	require("persistent-breakpoints.api").set_conditional_breakpoint()
end, {
	desc = "[d]ebug [B]reakpoint conditional: Toggle conditional debug breakpoint on current line.",
})
vim.keymap.set("n", "<Leader>dp", function()
	require("persistent-breakpoints.api").set_log_point()
end, {
	desc = "[d]ebug log [p]oint: Add logging debug breakpoint on current line.",
})

vim.keymap.set("n", "<F6>", function()
	require("dap").continue()
end, {
	desc = "Debug: Start/Continue",
})
vim.keymap.set("n", "<F7>", function()
	require("dap").step_into()
end, {
	desc = "Debug: Step Into",
})
vim.keymap.set("n", "<F8>", function()
	require("dap").step_over()
end, {
	desc = "Debug: Step Over",
})
vim.keymap.set("n", "<F9>", function()
	require("dap").step_out()
end, {
	desc = "Debug: Step Out",
})
vim.keymap.set("n", "<leader>de", function()
	require("dapui").eval()
end, {
	desc = "[d]ebug [e]valuate: Evaluate <word> under cursor or selection.",
})

vim.keymap.set("n", "]D", function()
	require("goto-breakpoints").next()
end, {
	desc = "Next debug breakpoint.",
})
vim.keymap.set("n", "[D", function()
	require("goto-breakpoints").prev()
end, {
	desc = "Previous debug breakpoint.",
})
vim.keymap.set("n", "]S", function()
	require("goto-breakpoints").stopped()
end, {
	desc = "Goto debug stop point.",
})
vim.keymap.set("n", "<Leader>do", function()
	require("dapui").toggle({ reset = true })
	vim.cmd("DapVirtualTextForceRefresh")
end, {
	desc = "[d]ebug ui [o]pen: Toggle debugger ui.",
})
vim.keymap.set("n", "<leader>dt", function()
	require("dapui").toggle({ layout = 1 })
end, {
	desc = "[d]ebug [t]est view: Open repl and console for test output.",
})
