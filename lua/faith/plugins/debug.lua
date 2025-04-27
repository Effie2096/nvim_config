return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {
				enable_commands = true,
				only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
				all_references = false, -- show virtual text on all all references of the variable (not only definitions)
				highlight_changed_variables = true,
			},
		},
		"LiadOz/nvim-dap-repl-highlights",
		"ofirgall/goto-breakpoints.nvim",
		"Weissle/persistent-breakpoints.nvim",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		"leoluz/nvim-dap-go",
	},
	keys = {
		{
			"<Leader>db",
			function()
				require("persistent-breakpoints.api").toggle_breakpoint()
			end,
			"[d]ebug [b]reakpoint: Toggle debugger breakpoint on current line.",
		},
		{
			"<Leader>dB",
			function()
				require("persistent-breakpoints.api").set_conditional_breakpoint()
			end,
			"[d]ebug [B]reakpoint conditional: Toggle conditional breakpoint on current line.",
		},
		-- Basic debugging keymaps, feel free to change to your liking!
		{
			"<F6>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<F7>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<F8>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<F9>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<Leader>dp",
			function()
				require("dap").set_breakpoint(
					nil,
					nil,
					vim.fn.input({ prompt = "Log point message: " })
				)
			end,
			"[d]ebug log [p]oint: Add logging breakpoint on current line.",
		},
		{
			"<leader>de",
			function()
				require("dapui").eval()
			end,
			"[d]ebug [e]valuate: Evaluate <word> under cursor or selection.",
			{ "n", "v" },
		},

		{
			"]D",
			function()
				require("goto-breakpoints").next()
			end,
			"Next debug breakpoint.",
		},
		{
			"[D",
			function()
				require("goto-breakpoints").prev()
			end,
			"Previous debug breakpoint.",
		},
		{
			"]S",
			function()
				require("goto-breakpoints").stopped()
			end,
			"Goto debug stop point.",
		},
		{
			"<Leader>do",
			function()
				require("dapui").toggle({ reset = true })
				vim.cmd("DapVirtualTextForceRefresh")
			end,
			"[d]ebug ui [o]pen: Toggle debugger ui.",
		},
		{
			"<leader>dt",
			"<cmd>lua require('dapui').toggle({layout = 2})<CR>",
			"[d]ebug [t]est view: Open repl and console for test output.",
		},
		{
			"<Leader>m",
			":MaximizerToggle!<CR>",
			"[m]aximize: Toggle fullscreen current window",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local persistent_breakpoints = require("persistent-breakpoints")

		local icons = require("faith.icons")

		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"delve",
			},
		})

		-- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
		-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		-- dap.listeners.before.event_exited['dapui_config'] = dapui.close
		--
		--
		--
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
						-- Elements can be strings or table with id and size keys.
						"stacks",
						{ id = "scopes", size = 0.5 },
					},
					size = 0.33,
					position = "right",
				},
				{
					elements = {
						"repl",
						{ id = "console", size = 0.5 },
					},
					size = 0.25,
					position = "bottom",
				},
				{
					elements = {
						"watches",
						{ id = "breakpoints", size = 0.5 },
					},
					size = 0.2,
					position = "left",
				},
			},
			controls = {
				-- Requires Neovim nightly (or 0.8 when released)
				enabled = false,
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

		persistent_breakpoints.setup({
			load_breakpoints_event = "BufReadPost",
		})

		require("nvim-dap-repl-highlights").setup()

		-- Install golang specific config
		require("dap-go").setup({
			delve = {
				-- On Windows delve must be run attached or it crashes.
				-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
				detached = vim.fn.has("win32") == 0,
			},
		})
	end,
	init = function()
		-- Catppuccin integration
		local sign = vim.fn.sign_define
		local icons = require("faith.icons")

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
	end,
}
