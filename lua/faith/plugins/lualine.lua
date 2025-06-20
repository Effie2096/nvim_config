local M = {}

local colors = require("catppuccin.palettes").get_palette()
local icons = require("faith.icons")
local spinner = require("faith.ui.spinner")

local ui_filetypes = {
	"help",
	"packer",
	"vim-plug",
	"neogitstatus",
	"NvimTree",
	"trouble",
	"lir",
	"Outline",
	"spectre_panel",
	"toggleterm",
	"DressingSelect",
	"TelescopePrompt",
	"lspinfo",
	"lsp-installer",
	"mason",
	"neo-tree",
	"lazy",
	"",
}

local winbar_ft_ignore = {
	"Avante",
	"AvanteInput",
	"AvanteSelectedFiles",
	"DiffviewFiles",
	"Outline",
	"OverseerList",
	"dap-repl",
	"dapui_breakpoints",
	"dapui_console",
	"dapui_scopes",
	"dapui_stacks",
	"dapui_watches",
	"fugitive",
	"help",
	"neo-tree",
	"oil",
	"qf",
	"undotree",
	"neotest-summary",
}

local winbar_bt_ignore = {
	"nofile",
	"terminal",
	"quickfix",
}

local winbar_ft_icons = {
	dapui_watches = {
		hl = "DAPUIWatchesValue",
		icon = icons.ui.Watches,
	},
	dapui_breakpoints = {
		hl = "DapBreakpoint",
		icon = icons.ui.Bug,
	},
	dapui_stacks = {
		hl = "DAPUISource",
		icon = icons.ui.Stacks,
	},
	dapui_scopes = {
		hl = "DAPUIScope",
		icon = icons.ui.Scopes,
	},
	["dap-repl"] = {
		icon = icons.ui.Repeat,
		name = "REPL",
	},
	dapui_console = {
		hl = "DevIconTerminal",
		icon = require("nvim-web-devicons").get_icon_by_filetype(
			"terminal",
			{}
		),
	},
	DiffviewFiles = {
		icon = icons.git.Diff,
		name = "Diffview",
	},
	Outline = {
		icon = icons.ui.BulletList,
		name = "Outline",
	},
	trouble = {
		icon = " ",
		name = "",
	},
	toggleterm = {
		hl = "DiagnosticCheck",
		icon = icons.ui.Term,
		name = function()
			local name = {}
			name.name = "Terminal"
			name.data = vim.b.toggle_number
			return name
		end,
	},
	terminal = {
		hl = "DevIconTerminal",
		icon = require("nvim-web-devicons").get_icon_by_filetype(
			"terminal",
			{ default = false }
		) .. " ",
		name = "Terminal",
	},
	OverseerList = {
		hl = "DiagnosticCheck",
		icon = icons.ui.StatusList,
		name = "Overseer",
	},
	undotree = {
		hl = "DiagnosticCheck",
		icon = icons.ui.Undo,
		name = "Undo",
	},
	Avante = {
		icon = icons.ui.Chat,
		name = "Avante",
	},
	AvanteSelectedFiles = {
		name = "Context",
	},
	AvanteInput = {
		name = "Ask Avante",
	},
	["neo-tree"] = {
		name = "NeoTree",
	},
	qf = {},
	fugitive = {
		hl = "DevIconGit",
		icon = require("nvim-web-devicons").get_icon_by_filetype("git", {}),
		name = "Fugitive",
	},
	["neotest-summary"] = {
		hl = "DiagnosticCheck",
		icon = icons.ui.Beaker,
		name = "Tests",
	},
	oil = {
		hl = "OilDir",
		icon = icons.ui.Project,
		name = function()
			local name = {}
			name.name = "Oil"
			name.data =
				require("oil").get_url_for_path(nil, false):gsub("oil://", "")
			return name
		end,
	},
}

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(str, trunc_width, trunc_len, hide_width, no_ellipsis)
	local win_width = vim.fn.winwidth(0)
	if hide_width and win_width < hide_width then
		return ""
	elseif
		trunc_width
		and trunc_len
		and win_width < trunc_width
		and #str > trunc_len
	then
		return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
	end
	return str
end

-- check if value in table
local function contains(t, value)
	for _, v in pairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

local winbar_ignore = function()
	return not (
		contains(winbar_ft_ignore, vim.bo.filetype)
		or (contains(winbar_bt_ignore, vim.bo.buftype))
	)
end

local function format_bubble(str)
	return string.format(
		"%s%s%s%s%s%s%s",
		"%#AccentInverse#",
		icons.separators.rounded.right,
		"%#Accent#",
		str,
		"%#AccentInverse#",
		icons.separators.rounded.left,
		"%*"
	)
end

local fileformat = {
	"fileformat",
	padding = { left = 1, right = 1 },
	fmt = function(str)
		if str == "" then -- only show if *not* unix format
			return ""
		end
		return str
	end,
}

local encoding = {
	"encoding",
	padding = { left = 0, right = 1 },
	fmt = function(str)
		if str == "utf-8" then -- only show if *not* utf-8
			return ""
		end
		return str
	end,
}

local trans_flag = {
	{
		'" "',
		color = {
			bg = "#5bcffa", --[[fg = '#FF1B8D',]]
		},
		padding = 0,
	},
	{
		'" "',
		color = {
			bg = "#ffb5cd", --[[fg = '#FF1B8D',]]
		},
		padding = 0,
	},
	{
		'" "',
		color = {
			bg = "#ffffff", --[[fg = '#FFDA00',]]
		},
		padding = 0,
	},
	{
		'" "',
		color = {
			bg = "#ffb5cd", --[[fg = '#1BB3FF',]]
		},
		padding = 0,
	},
	{
		'" "',
		color = {
			bg = "#5bcffa", --[[fg = '#1BB3FF',]]
		},
		padding = 0,
	},
}

local lint_spinner = spinner:new("lualine_lint_spinner", "dots_negative", 1)
local linger_timer = nil -- Timer to handle lingering names
local linger_duration = 5000 -- Duration in milliseconds for names to linger
local lint_progress = {
	function()
		local linters = require("lint").get_running()

		if #linters == 0 then
			lint_spinner:stop()

			-- If no linters are running, start the linger timer if not already active
			if not linger_timer then
				linger_timer = vim.uv.new_timer()
				linger_timer:start(
					linger_duration,
					0, -- No repeat
					vim.schedule_wrap(function()
						M.linters = nil -- Clear the names after the delay
						linger_timer:close()
						linger_timer = nil
					end)
				)
			end

			return "%#DiagnosticCheck#󰦕 %*" .. (M.linters or "")
		else
			if linger_timer then
				linger_timer:stop()
				linger_timer:close()
				linger_timer = nil
			end

			M.linters = table.concat(linters, ", ")
		end

		lint_spinner:start()
		return string.format("%%#BarDiagInfo#%s %%*", lint_spinner:get_frame())
			.. M.linters
	end,
	cond = function()
		return require("lint").linters_by_ft[vim.bo.filetype] ~= nil
	end,
	padding = { left = 1, right = 0 },
	separator = "",
}

---@diagnostic disable-next-line: unused-function
local get_clients = function()
	local clients = vim.lsp.get_clients()
	local client_names = {}

	-- should just be lsps
	local names = vim.iter(pairs(clients))
		:filter(function(_, client)
			return not client.name:find("anonymous source")
		end)
		:map(function(_, client)
			return client.name
		end)
		:totable()

	client_names["lsp"] = vim.iter(names)
		:filter(function(name)
			return not name:match("otter")
		end)
		:totable()
	client_names["otter"] = vim.iter(names)
		:filter(function(name)
			return name:match("otter")
		end)
		:totable()
	if require("lint").linters_by_ft[vim.bo.filetype] ~= nil then
		client_names["lint"] = require("lint").linters_by_ft[vim.bo.filetype]
	end

	return client_names
end

---@diagnostic disable-next-line: unused-function
local flatten_clients = function(client_map)
	local folded = {}
	if client_map then
		for client_type, clients in pairs(client_map) do
			if clients then
				for _, client in ipairs(clients) do
					table.insert(folded, client)
				end
			end
		end
	end
	return folded
end

---@diagnostic disable-next-line: unused-function
local get_formatters = function()
	if package.loaded.conform ~= nil then
		return vim.iter(require("conform").list_formatters())
			:filter(function(formatter)
				return formatter.available
			end)
			:totable()
	end
	return {}
end

local language_server = {
	function()
		local buf_ft = vim.bo.filetype

		if contains(ui_filetypes, buf_ft) then
			if M.language_servers == nil then
				return ""
			else
				return string.format(
					"%s%s",
					icons.ui.Server,
					#flatten_clients(M.language_servers)
				)
			end
		end

		local clients = get_clients()
		local client_names = flatten_clients(clients)

		--remove duplicate entries
		--only want to know which clients are active. not how many times they've attached
		-- local hash = {}
		-- local res = {}
		-- for _, v in ipairs(client_names) do
		-- 	if not hash[v] then
		-- 		res[#res + 1] = v
		-- 		hash[v] = true
		-- 	end
		-- end
		--
		-- client_names = res

		if #client_names ~= 0 then
			M.language_servers = clients
		end

		if #client_names == 0 then
			return ""
		else
			return string.format(
				"%s%s",
				icons.ui.Server,
				#flatten_clients(M.language_servers)
			)
		end
	end,
	padding = { left = 1, right = 0 },
	separator = {
		left = icons.separators.straight.left,
		right = "",
	},
	color = "@lsp.type.type",
	-- cond = function()
	-- 	return #flatten_clients(M.language_servers) ~= 0
	-- end,
	on_click = function(_, _, _)
		local clients = flatten_clients(M.language_servers)
		table.sort(clients)
		local msg = vim.iter(clients):join(", ")
		if msg ~= "" then
			vim.notify(msg, vim.log.levels.INFO, {
				title = "Active Clients",
			})
		end
	end,
}

local lsp = {
	"lsp_status",
	icon = "", -- f013
	symbols = {
			-- Standard unicode symbols to cycle through for LSP progress:
			-- stylua: ignore
			spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
		-- Standard unicode symbol for when LSP is done:
		done = "✓",
		-- Delimiter inserted between LSP names:
		separator = "  ",
	},
	-- List of LSP names to ignore (e.g., `null-ls`):
	ignore_lsp = { "" },
}

local asyncrun_status = {
	function()
		return table.concat(vim.tbl_values(vim.tbl_map(function(job)
			if job.status == "running" then
				return "⏳"
			end
			return (job.status == "success" and "✅" or "❌")
		end, vim.g.asyncrun_job_status or {})))
	end,
}

local git = {
	"b:gitsigns_head",
	fmt = function(str)
		return string.format(
			"on %%#BranchIndicator#%s%s%%*",
			icons.git.Branch,
			str
		)
	end,
	padding = { left = 1, right = 1 },
	separator = {
		left = icons.separators.straight.left,
		right = icons.separators.straight.right,
	},
	cond = function()
		return vim.b.gitsigns_head ~= nil
	end,
}

local branch = {
	"branch",
	icon = { "" },
	color = "WinBar",
	padding = { left = 0, right = 1 },
	separator = {
		left = "",
		right = icons.separators.straight.right,
	},
	fmt = function(str)
		return string.format(
			"on %%#BranchIndicator#%s%s%%*",
			icons.git.Branch,
			str
		)
	end,
}

local workspace_diagnostics = {
	"diagnostics",
	sources = { "nvim_workspace_diagnostic" },
	symbols = require("faith.icons").diagnostic,
	update_in_insert = false,
	padding = { left = 0, right = 1 },
	separator = {
		left = icons.separators.straight.left,
		right = "",
	},
}

local location = {
	"%11(%l/%L:%c%) ", --'%l/%L:%c'
}

local format_on_save = {
	function()
		local formatters = get_formatters()
		local names = vim.iter(formatters)
			:map(function(f)
				return f.name
			end)
			:join(", ")
		if #formatters > 1 then
			names = names:format("(%s)")
		end

		return (
			not (vim.g.disable_autoformat or vim.b.disable_autoformat)
			and #get_formatters() ~= 0
		)
				and string.format("%s: %%#DiagnosticCheck#On%%*", names)
			or string.format("%s: %%#DiagnosticError#Off%%*", names)
	end,
	padding = 1,
	cond = function()
		return #get_formatters() ~= 0
	end,
}

local obsession = {
	function()
		local record = "[Session]"
		local stop = record
		local indicator = vim.fn["ObsessionStatus"](record, stop)
		return indicator
	end,
	color = function()
		return {
			fg = vim.fn.exists("g:this_obsession") == 1 and colors.green
				or colors.red,
		}
	end,
	cond = function()
		return vim.fn.exists("g:loaded_obsession") == 1 -- plug installed and loaded
			and vim.fn["ObsessionStatus"]() ~= "" -- session loaded
	end,
}

local resession = {
	function()
		local session_state = require("resession").get_current_session_info()
		if session_state == nil then
			return ""
		end
		-- if it's auto, make it yellow
		local color = session_state.dir:find("/auto/") ~= nil
				and "%#SessionAuto#"
			or "%#DiagnosticCheck#"
		return color .. icons.ui.Session .. "%* in"
	end,
	padding = { left = 1, right = 0 },
	cond = function()
		return require("resession").get_current_session_info() ~= nil
	end,
}

local root = {
	function()
		return vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
	end,
	color = "AccentInverse",
	padding = { left = 1, right = 0 },
}

local buffers = {
	"buffers",
	show_filename_only = true, -- Shows shortened relative path when set to false.
	hide_filename_extension = true, -- Hide filename extension when set to true.
	show_modified_status = true, -- Shows indicator when the buffer is modified.
	icons_enabled = true,
	padding = { left = 1, right = 0 },
	separator = { left = "", right = "" },
	mode = 0,
	-- 0: Shows buffer name
	-- 1: Shows buffer index
	-- 2: Shows buffer name + buffer index
	-- 3: Shows buffer number
	-- 4: Shows buffer name + buffer number

	max_length = function()
		return vim.o.columns * 6 / 3
	end, -- Maximum width of buffers component,
	-- it can also be a function that returns
	-- the value of `max_length` dynamically.
	filetype_names = {
		TelescopePrompt = "Telescope",
		dashboard = "Dashboard",
		packer = "Packer",
		fzf = "FZF",
		alpha = "Alpha",
	}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

	-- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
	use_mode_colors = false,

	buffers_color = {
		-- Same values as the general color option can be used here.
		active = "TabLineSel", -- Color for active buffer.
		inactive = "TabLine", -- Color for inactive buffer.
	},
	symbols = {
		modified = icons.ui.Dot, -- Text to show when the buffer is modified
		alternate_file = "#", -- Text to show to identify the alternate file
		directory = icons.kind.Folder, -- Text to show when the buffer is a directory
	},
	fmt = function(str, ctx)
		local is_current = ctx.bufnr == vim.fn.bufnr()

		if str:find("Scratch") then
			str = "Scratch"
		elseif str:len() > 20 then
			-- split filename and extension
			local name = vim.fn.fnamemodify(str, ":t:r")
			-- local ext = vim.fn.fnamemodify(str, ":e:e")
			-- truncate name so that name + "..." + ext equals 20 chars
			-- str = string.format("%s...%s", name:sub(1, 20 - ext:len() - 3), ext)
			str = string.format("%s...", name:sub(1, 20 - 3))
		end

		return string.format(
			"%%#%s# %s %%#%s#%s %%*",
			(is_current and "TabLineSel" or "TabLine"),
			str,
			(is_current and "TabIndexSel" or "TabIndex"),
			ctx.buf_index
		)
	end,
}

local buffer_count = {
	function()
		local buffers_count = 0
		for b = 1, vim.fn.bufnr("$") do
			if
				vim.fn.buflisted(b) ~= 0
				and vim.api.nvim_buf_get_option(b, "buftype") ~= "quickfix"
			then
				buffers_count = buffers_count + 1
			end
		end
		return buffers_count > 0 and format_bubble(buffers_count) or ""
	end,
	padding = { left = 1, right = 0 },
	separator = "",
}

local alt_buffer = {
	function()
		local alt_buf = vim.fn.bufname("#")
		if alt_buf == "" then
			return ""
		end

		local alt_buf_name = vim.fn.fnamemodify(alt_buf, ":t")
		if alt_buf_name:len() > 20 then
			alt_buf_name = alt_buf_name:sub(1, 20) .. "..."
		end

		return alt_buf_name
	end,
	color = "AccentInverse",
	icon = "#",
	padding = { left = 1, right = 0 },
	separator = "",
	cond = function()
		return vim.fn.bufname("#") ~= ""
	end,
}

local tab_count = {
	function()
		return string.format("[%s]", vim.fn.tabpagenr("$"))
	end,
	color = "AccentInverse",
	separator = icons.separators.straight.right,
	padding = 0,
	cond = function()
		return vim.fn.tabpagenr("$") > 6
	end,
}

local tabs = {
	"tabs",
	-- 0: Shows tab_nr
	-- 1: Shows tab_name
	-- 2: Shows tab_nr + tab_name
	mode = 1,
	-- 0: just shows the filename
	-- 1: shows the relative path and shorten $HOME to ~
	-- 2: shows the full path
	-- 3: shows the full path and shorten $HOME to ~
	path = 0,
	max_length = function()
		return math.floor(vim.o.columns * 3 / 2) - 5
	end,
	padding = { left = 0, right = 0 },
	tabs_color = {
		-- Same values as the general color option can be used here.
		active = "TabLineSel", -- Color for active tab.
		inactive = "TabLine", -- Color for inactive tab.
	},
	show_modified_status = false, -- Shows a symbol next to the tab name if the file has been modified.
	symbols = {
		modified = icons.ui.Dot, -- Text to show when the file is modified.
	},
	fmt = function(name, context)
		local is_current = context.tabnr == vim.fn.tabpagenr()
		local tab_dir =
			vim.fn.fnamemodify(vim.fn.getcwd(-1, context.tabnr), ":t")
		local show_dir = tab_dir
			~= vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")

		local tabname = vim.fn.gettabvar(context.tabnr, "tabname")

		local tab_name = (type(tabname) == "string" and tabname ~= "")
				and string.format("%s ", string.upper(tabname))
			or ""

		local path = (
			show_dir and string.format("%s %s/", icons.kind.Folder, tab_dir)
			or ""
		)

		return string.format(
			"%%#%s# %s %%*%%#%s#%s%s%%#%s#",
			(is_current and "TabLineSel" or "AccentInverse"),
			context.tabnr,
			(is_current and "TabLineSel" or "TabLine"),
			tab_name,
			path,
			(is_current and "TabLineSel" or "TabLine")
		)
	end,
	-- cond = function()
	-- 	return vim.fn.tabpagenr("$") > 1
	-- end,
}
local harpoon = {
	function()
		local harpoon = require("harpoon")
		local marks = harpoon:list(
			string.format("%s%d", "tab", vim.fn.tabpagenr())
		).items or {}

		local buf = vim.api.nvim_buf_get_name(0)

		local extra_marks = 0

		local keys = {
			[1] = "h",
			[2] = "j",
			[3] = "k",
			[4] = "l",
			[5] = icons.arrows.left,
			[6] = icons.arrows.down,
			[7] = icons.arrows.up,
			[8] = icons.arrows.right,
		}
		local result = {}

		if next(marks) ~= nil then
			table.insert(result, {
				text = icons.ui.BookMark,
				link = "HarpoonNumberActive",
			})

			for i, mark in ipairs(marks) do
				local is_current = (
					(
						vim.fn.glob(vim.fn.fnamemodify(buf, ":p:.")) -- relative
						== vim.fn.glob(mark.value)
					)
					or (
						vim.fn.glob(vim.fn.fnamemodify(buf, ":p"))
						== vim.fn.glob(mark.value)
					) -- or absolute
				)

				local label
				if mark.value == "" or mark.value == "(empty)" then
					label = "(empty)"
					is_current = false
				else
					label = string.format(
						"%s",
						vim.fn.fnamemodify(mark.value, ":t")
					)
				end

				if i <= #keys then
					if not is_current then
						table.insert(result, {
							text = (
								i == 1 and " "
								or icons.separators.bar.left
							),
							link = "HarpoonSeparator",
						})
					end
					table.insert(result, {
						text = string.format(
							"%s%s",
							(is_current and " " or ""),
							keys[i]
						),
						link = is_current and "HarpoonNumberActive"
							or "HarpoonNumberInactive",
					})
					table.insert(result, {
						text = string.format(" %s ", label),
						link = is_current and "HarpoonActive"
							or "HarpoonInactive",
					})
				else
					extra_marks = extra_marks + 1
					table.insert(result, {
						text = string.format(" %s%s", "+", extra_marks),
						link = "HarpoonNumberActive",
					})
				end
			end

			return vim.iter(result)
				:map(function(v)
					return string.format("%%#%s#%s%%*", v.link, v.text)
				end)
				:join("")
		end
	end,
	cond = function()
		return package.loaded.harpoon ~= nil
			and next(
					require("harpoon"):list(
						string.format("%s%d", "tab", vim.fn.tabpagenr())
					).items
				)
				~= nil
	end,
}

local show_macro_recording = {
	function()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return ""
		else
			return "Recording @" .. recording_register
		end
	end,
}

local git_conflict = {
	function()
		return "%#lualine_b_diagnostics_error_normal#"
			.. "Conflicts: "
			.. require("git-conflict").conflict_count()
	end,
	cond = function()
		return require("git-conflict").conflict_count() > 0
	end,
}

local overseer = {
	"overseer",
	label = "",
	colored = true,
	unique = true,
}

local windsurf_spinner = spinner:new("windsurf_spinner", "dots")
local windsurf = {
	function()
		local status = require("codeium.virtual_text").status()

		if status.state == "idle" then
			-- Output was cleared, for example when leaving insert mode
			windsurf_spinner:stop()
			return "%#DiagnosticCheck#" .. icons.ui.Brain
		end

		if status.state == "waiting" then
			-- Waiting for response
			windsurf_spinner:start()
			return windsurf_spinner:get_frame() .. " "
		end

		if status.state == "completions" and status.total > 0 then
			windsurf_spinner:stop()
			return string.format("%d/%d", status.current, status.total)
		end

		return " 0 "
	end,
	cond = function()
		return package.loaded["windsurf"] ~= nil
	end,
}

local copilot = {
	"copilot",
	-- Default values
	symbols = {
		status = {
			icons = {
				enabled = " ",
				sleep = " ", -- auto-trigger disabled
				disabled = " ",
				warning = " ",
				unknown = " ",
			},
			hl = {
				enabled = require("copilot-lualine.colors").get_hl_value(
					0,
					"DiagnosticCheck",
					"fg"
				),
				sleep = require("copilot-lualine.colors").get_hl_value(
					0,
					"WinBar",
					"fg"
				),
				disabled = require("copilot-lualine.colors").get_hl_value(
					0,
					"NonText",
					"fg"
				),
				warning = require("copilot-lualine.colors").get_hl_value(
					0,
					"DiagnosticWarn",
					"fg"
				),
				unknown = require("copilot-lualine.colors").get_hl_value(
					0,
					"DiagnosticError",
					"fg"
				),
			},
		},
		spinners = "dots", -- has some premade spinners
		spinner_color = "#6272A4",
	},
	show_colors = true,
	show_loading = true,
	separator = "",
	padding = { left = 1, right = 0 },
}

local function is_loclist()
	return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

local function qf_label()
	return is_loclist() and "Location List" or "Quickfix List"
end

local function qf_title()
	if is_loclist() then
		return vim.fn.getloclist(0, { title = 0 }).title
	end
	return vim.fn.getqflist({ title = 0 }).title
end

local function parse_control_element(element)
	local e = element:match("(.*)%%#0#$")
	local color, action_element = e:match("^(.-)#%%(.+)$")
	color = color:gsub("^%%#", "")
	return color, "%" .. action_element
end

local function get_color_codes(name)
	local hl = vim.api.nvim_get_hl(0, { name = name })
	local fg = string.format("#%06x", hl.fg and hl.fg or 0)
	local bg = string.format("#%06x", hl.bg and hl.bg or 0)
	return fg, bg
end

local function merge_colors(foreground, background)
	local new_name = foreground .. background
	local fg, _ = get_color_codes(foreground)
	local _, bg = get_color_codes(background)
	vim.api.nvim_set_hl(0, new_name, { fg = fg, bg = bg })
	return string.format("%%#%s#", new_name)
end

local function inverse_color(name)
	local fg, bg = get_color_codes(name)
	local new_name = name .. "_inversed"
	vim.api.nvim_set_hl(0, new_name, { fg = bg, bg = fg })
	return string.format("%%#%s#", new_name)
end

local lualine_color = "WinBar"
local default_color = lualine_color
local color_start = "%#"
local color_end = "#"
local function get_dap_repl_winbar(separator, active)
	local background_color = lualine_color
	local controls_string = color_start .. default_color .. color_end
	for control_element in require("dapui.controls").controls():gmatch("%S+") do
		local color, action_element = parse_control_element(control_element)
		-- local new_color = merge_colors(color, default_color)
		local out = color_start
			.. background_color
			.. color_end
			.. separator
			.. color_start
			.. color
			.. color_end
			.. " "
			.. action_element
		controls_string = controls_string .. " " .. out
	end
	return controls_string
end

local winbar = {
	lualine_a = {
		{
			function()
				return format_bubble(vim.api.nvim_win_get_number(0))
			end,
			padding = 0,
		},
	},
	lualine_c = {
		{ -- fill space to center filename
			"%=",
			padding = { left = 0, right = 0 },
			separator = "",
			fmt = function(str)
				if not winbar_ignore() then
					return " "
				end
				return trunc(str, 10, 0, 5, true)
			end,
		},
		{
			"filetype",
			colored = true, -- Displays filetype icon in color if set to true
			icon_only = true, -- Display only an icon for filetype
			icon = { align = "right" }, -- Display filetype icon on the right hand side
			-- icon =    {'X', align='right'}
			-- Icon string ^ in table is ignored in filetype component
			padding = { left = 0, right = 0 },
			separator = "",
			fmt = function(str)
				local ft = vim.bo.filetype
				local bt = vim.bo.buftype

				if winbar_ft_icons[ft] ~= nil or winbar_ft_icons[bt] then
					local ico = winbar_ft_icons[ft] or winbar_ft_icons[bt]
					str = string.format(
						"%s%s%%*",
						(string.format("%%#%s#", (ico.hl or "WinBar")) or ""),
						(ico.icon .. " " or "")
					)
				end

				return trunc(str, 10, 0, 5, true)
			end,
			cond = winbar_ignore,
		},
		{
			"filename",
			file_status = true, -- Displays file status (readonly status, modified status)
			newfile_status = true, -- Display new file status (new file means no write after created)
			path = 1, -- 0: Just the filename
			-- 1: Relative path
			-- 2: Absolute path
			-- 3: Absolute path, with tilde as the home directory
			-- 4: Filename and parent dir, with tilde as the home directory

			shorting_target = 40, -- Shortens path to leave 40 spaces in the window
			-- for other components. (terrible name, any suggestions?)
			symbols = {
				modified = "%#BarDiagError#" .. icons.ui.Dot, -- Text to show when the file is modified.
				readonly = "%#BarDiagError#" .. icons.ui.Lock, -- Text to show when the file is non-modifiable or readonly.
				unnamed = "[No Name]", -- Text to show for unnamed buffers.
				newfile = "[New]", -- Text to show for newly created file before first write
			},
			padding = { left = 0, right = 0 },
			separator = "",
			fmt = function(str)
				local name = str
				local ft = vim.bo.filetype
				local bt = vim.bo.buftype

				if winbar_ft_icons[ft] ~= nil or winbar_ft_icons[bt] ~= nil then
					local file_spec = winbar_ft_icons[ft] or winbar_ft_icons[bt]

					if ft == "dap-repl" then
						name = format_bubble(file_spec.name)
							.. get_dap_repl_winbar("", true)
						goto continue
					end

					local spec_name = type(file_spec.name) == "function"
							and string.format(
								"%s: %s",
								file_spec.name()["name"],
								file_spec.name()["data"]
							)
						or file_spec.name

					if file_spec.name and not file_spec.icon then
						name = format_bubble(file_spec.name)
					elseif file_spec.name and file_spec.icon then
						name = string.format(
							"%s%s%s",
							("%%#%s #"):format(file_spec.hl or ""),
							file_spec.icon .. " " or "",
							format_bubble(spec_name)
						)
					else
						name = format_bubble(ft:gsub("^(%l)", string.upper))
							or ""
					end
				end
				if ft == "qf" then
					name = string.format(
						"%s %s",
						format_bubble(qf_label()),
						qf_title()
					)
					goto continue
				end
				if string.match(ft, "dapui") ~= nil then
					name = format_bubble(
						string.gsub(ft:gsub("dapui_", ""), "^%l", string.upper)
					)
					goto continue
				end
				::continue::
				return trunc(name, 10, 0, 5, true)
			end,
		},
	},
	lualine_x = {
		"SleuthIndicator",
		vim.tbl_extend("force", fileformat, {
			cond = winbar_ignore,
		}),
		vim.tbl_extend("force", encoding, {
			cond = winbar_ignore,
		}),
	},
	lualine_y = {
		{
			"diagnostics",
			sources = { "nvim_diagnostic" },
			-- Displays diagnostics for the defined severity types
			sections = { "error", "warn", "info", "hint" },
			diagnostics_color = {
				-- Same values as the general color option can be used here.
				error = "BarDiagError", -- Changes diagnostics' error color.
				warn = "BarDiagWarn", -- Changes diagnostics' warn color.
				info = "BarDiagInfo", -- Changes diagnostics' info color.
				hint = "BarDiagHint", -- Changes diagnostics' hint color.
			},
			symbols = require("faith.icons").diagnostic,
			colored = true, -- Displays diagnostics status in color if set to true.
			update_in_insert = true, -- Update diagnostics in insert mode.
			always_visible = false, -- Show diagnostics even if there are none.
			fmt = function(str, ctx)
				local ft = vim.bo.filetype
				local bt = vim.bo.buftype

				if
					contains(winbar_ft_ignore, ft)
					or contains(winbar_bt_ignore, bt)
				then
					return "%#DiagnosticCheck# %*"
				end

				local total = 0
				if ctx.last_diagnostics_count[3] then
					for _, value in pairs(ctx.last_diagnostics_count[3]) do
						total = total + value
					end
				end

				return total == 0
						and string.format(
							"%s%s%s",
							"%#DiagnosticCheck#",
							icons.ui.Check,
							"%*"
						)
					or str
			end,
			separator = { left = "", right = "" },
		},
	},
}

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
		init = function()
			local buf_next = function(next, count)
				if count ~= 0 then
					vim.cmd([[LualineBuffersJump! ]] .. count)
				else
					vim.cmd(next and "bnext" or "bprevious")
				end
			end

			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<Tab>", function()
				buf_next(true, vim.v.count)
			end, opts)
			vim.keymap.set("n", "<S-Tab>", function()
				buf_next(false, vim.v.count)
			end, opts)
		end,
		opts = function()
			local opts = {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = {
						left = icons.separators.straight.left,
						right = icons.separators.straight.right,
					},
					section_separators = { left = "", right = "" },
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					},
					disabled_filetypes = {
						-- 	statusline = {},
						winbar = {
							-- "dapui_watches",
							-- "dapui_breakpoints",
							-- "dapui_console",
							-- "dapui_stacks",
							-- "dapui_scopes",
							-- "dap-repl",
							"Avante",
							"AvanteInput",
							"AvanteSelectedFiles",
						},
					},
				},
				sections = {
					lualine_a = {},
					lualine_b = {
						resession,
						root,
						branch,
					},
					lualine_c = {
						workspace_diagnostics,
						git_conflict,

						language_server,
						windsurf,
						copilot,

						lint_progress,
						asyncrun_status,
						overseer,
					},
					lualine_x = {
						-- buffers,
						format_on_save,
						show_macro_recording,
					},
					lualine_y = {
						-- location,
					},
					lualine_z = trans_flag,
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				winbar = winbar,
				inactive_winbar = winbar,
				tabline = {
					lualine_a = { tab_count, tabs },
					lualine_b = { buffer_count, alt_buffer },
					lualine_c = {},
					lualine_x = { harpoon },
				},
				extensions = {
					-- "fugitive",
					"lazy",
					"mason",
					-- "neo-tree",
					-- "nvim-dap-ui",
					"oil",
					-- "overseer",
					-- "quickfix",
					-- "symbols-outline",
					-- "toggleterm",
					-- "trouble",
					-- require("faith.plugins.statusline.extensions.nvim-dap-ui").setup({
					-- 	active_separator = ">",
					-- 	inactive_separator = "|",
					-- }),
				},
			}

			return opts
		end,
	},
}
