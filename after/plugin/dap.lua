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

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<F5>", require'dap'.continue, opts)
vim.keymap.set("n", "<F10>", require'dap'.step_over, opts)
vim.keymap.set("n", "<F11>", require'dap'.step_into, opts)
vim.keymap.set("n", "<F12>", require'dap'.step_out, opts)
vim.keymap.set("n", "<Leader>db", require'dap'.toggle_breakpoint, opts)
vim.keymap.set("n", "<Leader>dB", function () require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts)
vim.keymap.set("n", "<Leader>dp", function () require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, opts)
-- vim.keymap.set("n", "<Leader>dr", require'dap'.repl.open, opts)

-- vim.keymap.set("v", "<M-k", require('dapui').eval(), opts)

function GotoWindow(id)
	vim.call("win_gotoid", id)
	vim.cmd("MaximizerToggle")
end

local home = os.getenv "HOME"
dap.adapters.cppdbg = {
	id = 'cppdbg',
	type = 'executable',
	command = home .. '/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}
dap.configurations.cpp = {
	{
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
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
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

vim.keymap.set("n", "<Leader>do", require("dapui").open, opts)
vim.keymap.set("n", "<Leader>dc", require("dapui").close, opts)
vim.keymap.set("n", "<Leader>m", ":MaximizerToggle!<CR>", opts)
vim.keymap.set("n", "<Leader>dw", function() GotoWindow(vim.call("bufwinid", 'DAP Watches')) end, opts)
vim.keymap.set("n", "<Leader>dS", function() GotoWindow(vim.call("bufwinid", 'DAP Stacks')) end, opts)
-- vim.keymap.set("n", "<Leader>db", function() GotoWindow(vim.call("bufwinid", 'DAP Breakpoints')) end, opts)
vim.keymap.set("n", "<Leader>ds", function() GotoWindow(vim.call("bufwinid", 'DAP Scopes')) end, opts)
vim.keymap.set("n", "<Leader>dr", function() GotoWindow(vim.call("bufwinid", 'dap-repl')) end, opts)
vim.keymap.set("n", "<Leader>dt", function() GotoWindow(vim.call("bufwinid", 'dap-terminal')) end, opts)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Catppuccin integration
local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = ""})
sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})

dap_vt.setup {
	only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
	all_references = true,                -- show virtual text on all all references of the variable (not only definitions)
}

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
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


