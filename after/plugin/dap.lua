local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end
local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end
local dap_virtual_text_status_ok, dap_vt = pcall(require, "nvim-dap-virtual-text")
if not dap_virtual_text_status_ok then
	return
end
local has_nvim_dap_repl_highlights, nvim_dap_repl_highlights = pcall(require, "nvim-dap-repl-highlights")
if not has_nvim_dap_repl_highlights then
	return
end

require("dap.ext.vscode").load_launchjs()

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local desc = fk.desc

local icons = require("faith.icons")

local opts = { noremap = true, silent = true }
nnoremap("<F6>", require("dap").continue, opts)
nnoremap("<F7>", require("dap").step_over, opts)
nnoremap("<F8>", require("dap").step_into, opts)
nnoremap("<F9>", require("dap").step_out, opts)

local has_persisten_breakpoints, persistent_breakpoints = pcall(require, "persistent-breakpoints")
if has_persisten_breakpoints then
	persistent_breakpoints.setup({
		load_breakpoints_event = "BufReadPost",
	})
	vim.keymap.set(
		"n",
		"<Leader>db",
		require("persistent-breakpoints.api").toggle_breakpoint,
		desc(opts, "[d]ebug [b]reakpoint: Toggle debugger breakpoint on current line.")
	)
	vim.keymap.set(
		"n",
		"<Leader>dB",
		require("persistent-breakpoints.api").set_conditional_breakpoint,
		desc(opts, "[d]ebug [B]reakpoint conditional: Toggle conditional breakpoint on current line.")
	)
else
	vim.keymap.set(
		"n",
		"<Leader>db",
		require("dap").toggle_breakpoint,
		desc(opts, "[d]ebug [b]reakpoint: Toggle debugger breakpoint on current line.")
	)
	vim.keymap.set("n", "<Leader>dB", function()
		require("dap").set_breakpoint(vim.fn.input({ prompt = "Breakpoint condition: " }))
	end, desc(opts, "[d]ebug [B]reakpoint conditional: Toggle conditional breakpoint on current line."))
end
vim.keymap.set("n", "<Leader>dp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input({ prompt = "Log point message: " }))
end, desc(opts, "[d]ebug log [p]oint: Add logging breakpoint on current line."))

vim.keymap.set(
	{ "n", "v" },
	"<leader>de",
	require("dapui").eval,
	vim.tbl_extend("force", opts, { desc = "[d]ebug [e]valuate: Evaluate <word> under cursor or selection." })
)

function GotoWindow(id)
	vim.fn["win_gotoid"](id)
	vim.cmd("MaximizerToggle")
end

local has_goto_breakpoints, _ = pcall(require, "goto-breakpoints")
if has_goto_breakpoints then
	vim.keymap.set(
		"n",
		"]D",
		require("goto-breakpoints").next,
		vim.tbl_extend("force", opts, { desc = "Next debug breakpoint." })
	)
	vim.keymap.set(
		"n",
		"[D",
		require("goto-breakpoints").prev,
		vim.tbl_extend("force", opts, { desc = "Previous debug breakpoint." })
	)
	vim.keymap.set(
		"n",
		"]S",
		require("goto-breakpoints").stopped,
		vim.tbl_extend("force", opts, { desc = "Goto debug stop point." })
	)
end

local home = os.getenv("HOME")
dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = vim.fn.glob(
		home .. "/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
	),
}
dap.adapters.codelldb = {
	type = "server",
	port = "1234",
	executable = {
		command = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/adapter/codelldb",
		args = { "--port", "1234" },
		detached = vim.uv.os_uname().sysname:find("Windows"),
	},
}
local function cxx_executable_path()
	local user_input = vim.fn.input({
		prompt = "Path to executable: ",
		completion = "file",
	})
	return user_input ~= "" and user_input or "${workspaceFolder}/Debug/${workspaceFolderBasename}"
end

local function cxx_find_exe()
	return coroutine.create(function(coro)
		local picker_opts = {
			sorting_strategy = "ascending",
			default_text = "Debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
		}
		require("telescope.pickers")
			.new(picker_opts, {
				prompt_title = "Path to executable",
				prompt_prefix = icons.ui.Search .. " ",
				selection_caret = icons.ui.Caret_Arrow,
				finder = require("telescope.finders").new_oneshot_job(
					{ "fd", "--hidden", "--no-ignore", "--type", "x" },
					{}
				),
				sorter = require("telescope.config").values.generic_sorter(picker_opts),
				attach_mappings = function(buffer_number)
					local actions = require("telescope.actions")
					actions.select_default:replace(function()
						actions.close(buffer_number)
						coroutine.resume(coro, require("telescope.actions.state").get_selected_entry()[1])
					end)
					return true
				end,
				layout_config = require("faith.telescope.layouts").layout_configs.centered_compact.layout_config,
				borderchars = require("faith.telescope.layouts").layout_configs.centered_compact.borderchars,
			})
			:find()
	end)
end

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = cxx_find_exe,
		args = function()
			local args_string = vim.fn.input("Args: ")
			return vim.split(args_string, " ")
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = true,
		setupCommands = {
			{
				text = "-enable-pretty-printing",
				description = "enable pretty printing",
				ignoreFailures = false,
			},
		},
	},
	{
		name = "Attach to gdbserver :1234",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		miDebuggerServerAddress = "localhost:1234",
		miDebuggerPath = "/usr/bin/gdb",
		cwd = "${workspaceFolder}",
		program = cxx_find_exe,
		args = function()
			local args_string = vim.fn.input("Args: ")
			return vim.split(args_string, " ")
		end,
		setupCommands = {
			{
				text = "-enable-pretty-printing",
				description = "enable pretty printing",
				ignoreFailures = false,
			},
		},
	},
}
dap.configurations.c = dap.configurations.cpp

dap.configurations.rust = {
	{
		name = "Launch",
		type = "codelldb",
		request = "launch",
		cwd = "${workspaceFolder}",
		program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
		stopAtEntry = true,
		initCommands = function()
			-- Find out where to look for the pretty printer Python module
			local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

			local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
			local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

			local commands = {}
			local file = io.open(commands_file, "r")
			if file then
				for line in file:lines() do
					table.insert(commands, line)
				end
				file:close()
			end
			table.insert(commands, 1, script_import)

			return commands
		end,
	},
}

nnoremap("<Leader>do", function()
	require("dapui").toggle({ reset = true })
	vim.cmd("DapVirtualTextForceRefresh")
end, desc(opts, "[d]ebug ui [o]pen: Toggle debugger ui."))
nnoremap(
	"<leader>dt",
	"<cmd>lua require('dapui').toggle({layout = 2})<CR>",
	desc(opts, "[d]ebug [t]est view: Open repl and console for test output.")
)
nnoremap("<Leader>m", ":MaximizerToggle!<CR>", desc(opts, "[m]aximize: Toggle fullscreen current window."))

--[[ dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end ]]

-- Catppuccin integration
local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = icons.debug.Breakpoint, texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign(
	"DapBreakpointCondition",
	{ text = icons.debug.BreakpointCond, texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
)
sign("DapLogPoint", { text = icons.debug.BreakpointLog, texthl = "DapLogPoint", linehl = "", numhl = "" })

dap_vt.setup({
	enable_commands = true,
	only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
	all_references = false, -- show virtual text on all all references of the variable (not only definitions)
	highlight_changed_variables = true,
})

dapui.setup({
	icons = { expanded = icons.ui.ArrowFillOpen, collapsed = icons.ui.ArrowFillClosed },
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
	-- Layouts define sections of the screen to place windows.
	-- The position can be "left", "right", "top" or "bottom".
	-- The size specifies the height/width depending on position. It can be an Int
	-- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
	-- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
	-- Elements are the elements shown in the layout (in order).
	-- Layouts are opened in order so that earlier layouts take priority in window sizing.
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

nvim_dap_repl_highlights.setup()

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	group = vim.api.nvim_create_augroup("dap_ui_winbars", { clear = true }),
	pattern = "*",
	callback = function(_)
		local filetype = vim.api.nvim_get_option_value("filetype", { scope = "local" })
		if string.match(filetype, "dapui") ~= nil then
			local winid = vim.api.nvim_get_current_win()
			local win_bar = string.format(
				"%s%s%s",
				"%#CatAccentInverse#" .. icons.separators.rounded.right .. "%*",
				"%#CatAccent#" .. string.gsub(filetype:gsub("dapui_", ""), "^%l", string.upper) .. "%*",
				"%#CatAccentInverse#" .. icons.separators.rounded.left .. "%*"
			)
			vim.wo[winid].winbar = win_bar
		end
	end,
})
