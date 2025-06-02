M = {}

local colors = require("catppuccin.palettes").get_palette()
local icons = require("faith.icons")
local spinner = require("faith.spinner")

local ft_ignore = {
	"dapui_watches",
	"dapui_breakpoints",
	"dapui_console",
	"dapui_stacks",
	"dapui_scopes",
	"dap-repl",
	"DiffviewFiles",
	"Outline",
	"terminal",
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

local fileformat = {
	"fileformat",
	padding = { left = 1, right = 2 },
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
		separator = { left = "", right = "" },
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

-- check if value in table
local function contains(t, value)
	for _, v in pairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

local lint_spinner = spinner:new(100)
local lint_progress = {
	function()
		local linters = require("lint").get_running()
		if #linters == 0 then
			return "%#DiagnosticCheck#󰦕%*"
		end
		return "%#BarDiagInfo#󱉶 %*"
			.. table.concat(linters, ", ")
			.. lint_spinner:update_spinner()
	end,
	padding = { left = 1, right = 0 },
	separator = { left = "", right = "" },
}

local language_server = {
	function()
		local buf_ft = vim.bo.filetype
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
			"",
		}

		if contains(ui_filetypes, buf_ft) then
			if M.language_servers == nil then
				return ""
			else
				return M.language_servers
			end
		end

		local clients = vim.lsp.get_clients()
		local client_names = {}

		-- add client
		for _, client in pairs(clients) do
			local name = client.name
			if name ~= "null-ls" then
				if client.name.match(client.name, "otter") then
					name = client.name:gsub("%[%d+%]", "")
				end
				table.insert(client_names, name)
			end
		end

		if package.loaded.conform ~= nil then
			local conform_formatters = require("conform").list_formatters()
			for _, f in pairs(conform_formatters) do
				if f.available then
					table.insert(client_names, f.name)
				end
			end
		end

		table.sort(client_names)

		--remove duplicate entries
		--only want to know which clients are active. not how many times they've attached
		local hash = {}
		local res = {}

		for _, v in ipairs(client_names) do
			if not hash[v] then
				res[#res + 1] = v
				hash[v] = true
			end
		end

		client_names = res

		-- join client names with commas
		local client_names_str = table.concat(client_names, ", ")

		-- check client_names_str if empty
		local language_servers = ""
		local client_names_str_len = #client_names_str
		if client_names_str_len ~= 0 then
			language_servers = "(" .. client_names_str .. ")"
		end

		if client_names_str_len == 0 then
			return ""
		else
			M.language_servers = language_servers
			return language_servers:gsub(", anonymous source", "")
		end
	end,
	padding = { left = 1, right = 0 },
	separator = { left = "", right = "" },
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
}

local workspace_diagnostics = {
	"diagnostics",
	sources = { "nvim_workspace_diagnostic" },
	symbols = require("faith.icons").diagnostic,
	update_in_insert = true,
}

local location = {
	"%11(%l/%L:%c%) ", --'%l/%L:%c'
}

---@diagnostic disable-next-line: unused-local
local filetype = {
	"filetype",
	colored = true,
	icon = { align = "left" },
}

local format_on_save = {
	function()
		return not (
					vim.g.disable_autoformat or vim.b.disable_autoformat
				)
				and "Format: On"
			or "Format: Off"
	end,
	padding = 1,
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
		local color = require("resession").get_current_session_info() ~= nil
				and "%#DiagnosticCheck#"
			or "%#BarDiagError#"
		return color .. icons.ui.Session .. "%* in"
	end,
	separator = { left = "", right = "" },
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
	separator = { left = "", right = "" },
	padding = { left = 1, right = 0 },
}

local buffers = {
	"buffers",
	show_filename_only = true, -- Shows shortened relative path when set to false.
	hide_filename_extension = false, -- Hide filename extension when set to true.
	show_modified_status = true, -- Shows indicator when the buffer is modified.
	icons_enabled = false,
	padding = { left = 1, right = 1 },
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
		modified = " " .. icons.ui.Dot, -- Text to show when the buffer is modified
		alternate_file = "#", -- Text to show to identify the alternate file
		directory = icons.kind.Folder, -- Text to show when the buffer is a directory
	},
	fmt = function(str, ctx)
		local is_current = ctx.bufnr == vim.api.nvim_get_current_buf()
		local ft = vim.bo.filetype

		if str:find("Scratch") then
			str = "Scratch"
		elseif str:len() > 20 then
			-- split filename and extension
			local name = vim.fn.fnamemodify(str, ":t:r")
			local ext = vim.fn.fnamemodify(str, ":e:e")
			-- truncate name so that name + "..." + ext equals 20 chars
			str = string.format("%s...%s", name:sub(1, 20 - ext:len() - 3), ext)
		end
		local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(
			ft,
			{ default = true }
		)
		-- merge current tab background highlight with icon foreground highlight

		return string.format(
			"%%#%s#%s %s %%*%%#%s#%s",
			(is_current and "TabLineSel" or "AccentInverse"),
			ctx.buf_index,
			string.format("%%#%s#%s", (is_current and "TabLineSel" or hl), icon),
			(is_current and "TabLineSel" or "TabLine"),
			str
		)
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
		return math.floor(vim.o.columns * 3 / 3) - 5
	end, -- Maximum width of buffers component,
	padding = { left = 1, right = 0 },
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
			"%%#%s#%s %%*%%#%s#%s%s",
			(is_current and "TabLineSel" or "AccentInverse"),
			context.tabnr,
			(is_current and "TabLineSel" or "TabLine"),
			tab_name,
			path
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

local windsurf_spinner = spinner:new(100)
local windsurf = {
	function()
		local status = require("codeium.virtual_text").status()

		if status.state == "idle" then
			-- Output was cleared, for example when leaving insert mode
			return "%#DiagnosticCheck#" .. "✓"
		end

		if status.state == "waiting" then
			-- Waiting for response
			return windsurf_spinner:update_spinner() .. " "
		end

		if status.state == "completions" and status.total > 0 then
			return string.format("%d/%d", status.current, status.total)
		end

		return " 0 "
	end,
	icon = { icons.ui.Brain, color = "DiagnosticCheck" },
	cond = function()
		return package.loaded["codeium"] ~= nil
	end,
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

local winbar = {
	lualine_a = {
		{
			function()
				return format_bubble(vim.api.nvim_win_get_number(0))
			end,
			padding = 0,
			separator = { left = "", right = "" },
		},
	},
	lualine_c = {
		{ -- fill space to center filename
			"%=",
			separator = { left = "", right = "" },
			padding = { left = 0, right = 0 },
			fmt = function(str)
				local ft = vim.bo.filetype
				if
					contains({
						"dap-repl",
						"DiffviewFiles",
						"Outline",
						"OverseerList",
						"undotree",
						"neo-tree",
						"oil",
						"qf",
						"AvanteInput",
						"AvanteSelectedFiles",
					}, ft) or string.match(ft, "dapui") ~= nil
				then
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
			separator = { left = "", right = "" },
			fmt = function(str)
				local ft = vim.bo.filetype
				if ft == "dapui_watches" then
					str = "%#DAPUIWatchesValue#" .. icons.ui.Watches .. "%*"
				end
				if ft == "dapui_breakpoints" then
					str = "%#DapBreakpoint#" .. icons.ui.Bug .. "%*"
				end
				if ft == "dapui_console" then
					str = "%#DevIconTerminal#"
						.. require("nvim-web-devicons").get_icon_by_filetype(
							"terminal",
							{}
						)
						.. " %*"
				end
				if ft == "dapui_stacks" then
					str = "%#DAPUISource#" .. icons.ui.Stacks .. "%*"
				end
				if ft == "dapui_scopes" then
					str = "%#DAPUIScope#" .. icons.ui.Scopes .. " %*"
				end
				if ft == "dap-repl" then
					str = icons.ui.Repeat .. "%*"
				end
				if ft == "DiffviewFiles" then
					str = icons.git.Diff .. "%*"
				end
				if ft == "Outline" then
					str = icons.ui.BulletList .. "%*"
				end
				if ft == "trouble" then
					str = " "
				end
				if ft == "toggleterm" then
					str = "%#DiagnosticCheck#" .. icons.ui.Term .. "%*"
				end
				if ft == "fugitive" then
					str = "%#DevIconGit#"
						.. require("nvim-web-devicons").get_icon_by_filetype(
							"git",
							{}
						)
						.. " %*"
				end
				if ft == "OverseerList" then
					str = "%#DiagnosticCheck#" .. icons.ui.StatusList .. "%*"
				end
				if ft == "undotree" then
					str = "%#DiagnosticCheck#" .. icons.ui.Undo .. "%*"
				end
				if ft == "Avante" then
					str = icons.ui.Chat
				end
				if ft == "neo-tree" or ft == "qf" then
					str = ""
				end

				return trunc(str, 10, 0, 5, true)
			end,
			cond = function()
				local ft = vim.bo.filetype
				return string.match(ft, "dapui") == nil
					and not contains({
						"dap-repl",
						"DiffviewFiles",
						"Outline",
						"trouble",
						"toggleterm",
						"fugitive",
						"OverseerList",
						"undotree",
						"neo-tree",
						"oil",
						"qf",
						"AvanteInput",
						"AvanteSelectedFiles",
					}, ft)
			end,
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
			separator = { left = "", right = "" },
			fmt = function(str)
				local name = str
				local ft = vim.bo.filetype
				if ft == "dap-repl" then
					name = format_bubble("REPL")
					goto continue
				end
				if ft == "DiffviewFiles" then
					name = format_bubble("Diffview")
					goto continue
				end
				if ft == "Outline" then
					name = format_bubble("Outline")
					goto continue
				end
				if ft == "trouble" then
					name = ""
					goto continue
				end
				if ft == "toggleterm" then
					name = "Terminal (" .. vim.b.toggle_number .. ")"
					goto continue
				end
				if ft == "fugitive" then
					name = "Fugitive"
					goto continue
				end
				if ft == "OverseerList" then
					name = format_bubble("Overseer")
					goto continue
				end
				if ft == "undotree" then
					name = format_bubble("UndoTree")
					goto continue
				end
				if ft == "neo-tree" then
					name = format_bubble("NeoTree")
					goto continue
				end
				if ft == "oil" then
					name = format_bubble("Oil")
					goto continue
				end
				if ft == "Avante" then
					name = format_bubble("Avante")
					goto continue
				end
				if ft == "AvanteSelectedFiles" then
					name = format_bubble("Context")
					goto continue
				end
				if ft == "AvanteInput" then
					name = format_bubble("Ask Avante")
					goto continue
				end
				if ft == "qf" then
					name = string.format(
						"%s %s",
						format_bubble(qf_label()),
						qf_title()
					)
				end
				if string.match(ft, "dapui") ~= nil then
					name = format_bubble(
						string.gsub(ft:gsub("dapui_", ""), "^%l", string.upper)
					)
				end
				::continue::
				return trunc(name, 10, 0, 5, true)
			end,
		},
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
				local total = 0
				if ctx.last_diagnostics_count[1] then
					for _, value in pairs(ctx.last_diagnostics_count[1]) do
						total = total + value
					end
				end

				if
					string.match(ft, "dapui") ~= nil
					or contains({
						"dap-repl",
						"Outline",
						"OverseerList",
						"undotree",
						"neo-tree",
						"help",
						"qf",
						"fugitive",
						"oil",
						"Avante",
						"AvanteSelectedFiles",
						"AvanteInput",
					}, ft)
					or contains({ "terminal", "nofile", "quickfix" }, bt)
				then
					return "%#DiagnosticCheck# %*"
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
		},
	},
}

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end

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
						winbar = {
							"Avante",
							"AvanteInput",
							"AvanteSelectedFiles",
						},
					},
					-- disabled_filetypes = {
					-- 	statusline = {},
					-- 	winbar = {
					-- 		"dapui_watches",
					-- 		"dapui_breakpoints",
					-- 		"dapui_console",
					-- 		"dapui_stacks",
					-- 		"dapui_scopes",
					-- 		"dap-repl",
					-- 	},
					-- },
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						resession,
						root,
						git,
						workspace_diagnostics,
						git_conflict,
						-- language_server,
						lint_progress,
						windsurf,
						asyncrun_status,
						overseer,
					},
					lualine_x = {
						buffers,
					},
					lualine_y = {
						show_macro_recording,
						-- location,
					},
					lualine_z = {},
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
					-- lualine_a = { root },
					lualine_b = { tabs },
					lualine_c = {},
					lualine_x = { harpoon },
				},
				inactive_tablines = {},
				extensions = {
					"fugitive",
					"lazy",
					"mason",
					"neo-tree",
					"nvim-dap-ui",
					"oil",
					"overseer",
					"quickfix",
					"symbols-outline",
					"toggleterm",
					"trouble",
				},
			}

			return opts
		end,
	},
}
