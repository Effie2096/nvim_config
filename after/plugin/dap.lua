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

local fk = require('faith.keymap')
local nnoremap = fk.nnoremap
local desc = fk.desc

local opts = { noremap = true, silent = true }
nnoremap("<F5>", require'dap'.continue, opts)
nnoremap("<F10>", require'dap'.step_over, opts)
nnoremap("<F11>", require'dap'.step_into, opts)
nnoremap("<F12>", require'dap'.step_out, opts)
nnoremap("<Leader>db", require'dap'.toggle_breakpoint,
	desc(opts, "[d]ebug [b]reakpoint: Toggle debugger breakpoint on current line."))
nnoremap("<Leader>dB", function () require'dap'.set_breakpoint(vim.fn.input({prompt = 'Breakpoint condition: '})) end,
	desc(opts, "[d]ebug [B]reakpoint conditional: Toggle conditional breakpoint on current line."))
nnoremap("<Leader>dp", function () require'dap'.set_breakpoint(nil, nil, vim.fn.input({prompt = 'Log point message: '})) end,
	desc(opts, "[d]ebug log [p]oint: Add logging breakpoint on current line."))
-- nnoremap("<Leader>dr", require'dap'.repl.open, opts)

-- vnoremap("<M-k", require('dapui').eval(), opts)

function GotoWindow(id)
	vim.fn["win_gotoid"](id)
	vim.cmd("MaximizerToggle")
end

local home = os.getenv "HOME"
dap.adapters.cppdbg = {
	id = 'cppdbg',
	type = 'executable',
	command = vim.fn.glob(home .. '/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7'),
}
dap.configurations.cpp = {
	{
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input({prompt = 'Path to executable: ', text = vim.fn.glob(vim.fn.getcwd() .. '/'), completion = 'file'})
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
			return vim.fn.input({prompt = 'Path to executable: ', text = vim.fn.glob(vim.fn.getcwd() .. '/'), completion = 'file'})
    end,
  },
}

nnoremap("<Leader>do", require("dapui").toggle,
	desc(opts, "[d]ebug ui [o]pen: Toggle debugger ui."))
nnoremap("<leader>dt", "<cmd>lua require('dapui').toggle({layout = 2})<CR>",
	desc(opts, "[d]ebug [t]est view: Open repl and console for test output."))
nnoremap("<Leader>m", ":MaximizerToggle!<CR>",
	desc(opts, "[m]aximize: Toggle fullscreen current window."))
--[[ nnoremap("<Leader>dw", function() GotoWindow(vim.fn['bufwinid']('DAP Watches')) end, opts)
nnoremap("<Leader>dS", function() GotoWindow(vim.fn['bufwinid']('DAP Stacks')) end, opts)
-- nnoremap("<Leader>db", function() GotoWindow(vim.fn['bufwinid']('DAP Breakpoints')) end, opts)
nnoremap("<Leader>ds", function() GotoWindow(vim.fn['bufwinid']('DAP Scopes')) end, opts)
nnoremap("<Leader>dr", function() GotoWindow(vim.fn['bufwinid']('dap-repl')) end, opts)
nnoremap("<Leader>dt", function() GotoWindow(vim.fn['bufwinid']('dap-terminal')) end, opts) ]]

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
local icons = require('faith.icons')

sign("DapBreakpoint", { text = icons.debug.Breakpoint, texthl = "DapBreakpoint", linehl = "", numhl = ""})
sign("DapBreakpointCondition", { text = icons.debug.BreakpointCond, texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
sign("DapLogPoint", { text = icons.debug.BreakpointLog, texthl = "DapLogPoint", linehl = "", numhl = ""})

dap_vt.setup {
	only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
	all_references = true,                -- show virtual text on all all references of the variable (not only definitions)
}

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
  expand_lines = vim.fn.has("nvim-0.7"),
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
      size = 0.4,
      position = "right",
    },
    {
      elements = {
				"repl",
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
		{
			elements = {
				"watches",
				"breakpoints",
			},
			size = 0.2,
			position = "left"
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
  }
})


