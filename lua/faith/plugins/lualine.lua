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

local winbar_widths = {}
local status_widths = {}

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

-- check width of current component and add to maps
local function add_width(str, name, tally)
	if not str or str == "" then
		tally[name] = 0
		return str
	end
	tally[name] = #vim.api.nvim_eval_statusline(str, {}).str
	return str
end

-- fill space bweteen left-most components and middle of terminal
local function fill_space(tally)
	local used_space = 0
	for _, width in pairs(tally) do
		used_space = used_space + width
	end

	local filetype_w = tally["filetype"] or 0
	local filename_w = tally["filename"] or 0

	used_space = used_space - (filename_w + filetype_w)

	local term_width = vim.fn.winwidth(0)

	local fill = string.rep(
		" ",
		math.floor((term_width - filename_w - filetype_w) / 2) - used_space
	)
	return fill
end

local function get_component_pos(component, tally)
	local used_space = 0
	for comp, width in pairs(tally) do
		if comp == tally[component] then
			return used_space
		end
		used_space = used_space + width
	end
end

-- local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
-- local spinner_frames =
-- 	{ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- local spinner = 1
--
-- local function update_spinner()
-- 	local frame = spinner_frames[spinner]
-- 	spinner = (spinner % #spinner_frames) + 1
-- 	vim.defer_fn(update_spinner, 100)
-- 	return frame
-- end

local encoding = {
	"fileformat",
	padding = { left = 1, right = 2 },
	fmt = function(str)
		if str == "" then -- only show if *not* unix format
			return ""
		end
		return str
	end,
}

local fileformat = {
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
		return "%#BarDiagInfo#󱉶%*"
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
	fmt = function(str)
		return add_width(str, "language_server", status_widths)
	end,
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
	color = "lualine_a_normal",
	icon = { icons.git.Branch, align = "left" },
	fmt = function(str)
		return add_width(str, "git", status_widths)
	end,
}

local workspace_diagnostics = {
	"diagnostics",
	sources = { "nvim_workspace_diagnostic" },
	symbols = require("faith.icons").diagnostic,
	update_in_insert = true,
	fmt = function(str)
		return add_width(str, "workspace_diagnostics", status_widths)
	end,
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
	fmt = function(str)
		return add_width(str, "obsession", status_widths)
	end,
}

local root = {
	function()
		return string.format(
			"%s %s",
			icons.ui.Project,
			vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
		)
	end,
}

local tabs = {
	"tabs",
	mode = 2,
	max_length = vim.o.columns / 2,
	fmt = function(name, context)
		local tab_dir =
			vim.fn.fnamemodify(vim.fn.getcwd(-1, context.tabnr), ":t")
		local show_dir = not (
			tab_dir == vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
		)
		local title = name
		if vim.fn.exists("g:loaded_taboo") then
			title = vim.fn.TabooTabTitle(context.tabnr)
		end
		return string.format("%s%s", show_dir and tab_dir .. ": " or "", title)
	end,
	cond = function()
		return vim.fn.tabpagenr("$") > 1
	end,
}
local harpoon = {
	function()
		local harpoon = require("harpoon")
		local marks = harpoon:list().items or {}

		local section_prefix = "%#HarpoonNumberActive#"
			.. icons.ui.BookMark
			.. "%*"

		local prefix = ""
		local suffix = " "

		local tabline = ""

		local next = next
		if next(marks) ~= nil then
			for i, mark in ipairs(marks) do
				local is_current = vim.fn.fnamemodify(
					vim.api.nvim_buf_get_name(0),
					":p:."
				) == mark.value

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

				if i <= #keys then
					local key = keys[i]

					if is_current then
						tabline = tabline
							.. "%#HarpoonNumberActive# "
							.. prefix
							.. key
							.. " %*"
							.. "%#HarpoonActive#"
					else
						tabline = tabline
							.. "%#HarpoonNumberInactive#"
							.. (i == 1 and " " or icons.separators.bar.left)
							.. prefix
							.. key
							.. " %*"
							.. "%#HarpoonInactive#"
					end

					tabline = tabline .. label .. suffix .. "%*"
				else
					extra_marks = extra_marks + 1
					tabline = tabline
						.. "%#HarpoonNumberActive#"
						.. " +"
						.. extra_marks
						.. "%*"
						.. "%#HarpoonActive#"
				end
			end
		end

		return section_prefix .. tabline
	end,
	cond = function()
		return package.loaded.harpoon ~= nil
			and next(require("harpoon"):list().items) ~= nil
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
	fmt = function(str)
		return add_width(str, "git_conflict", status_widths)
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
	fmt = function(str)
		return add_width(str, "windsurf", status_widths)
	end,
}

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
			fmt = function(str)
				return add_width(str, "winnum", winbar_widths)
			end,
		},
	},
	lualine_c = {
		{ -- fill space to center filename
			function()
				return fill_space(winbar_widths)
			end,
			separator = { left = "", right = "" },
			padding = { left = 0, right = 0 },
			fmt = function(str)
				local ft = vim.bo.filetype
				if
					ft == "dap-repl"
					or string.match(ft, "dapui") ~= nil
					or ft == "DiffviewFiles"
					or ft == "Outline"
				then
					return " "
				end
				return trunc(str, 10, 0, 5, true)
			end,
		},
		{
			function()
				local ft = vim.bo.filetype
				local icon = ""
				if ft == "dapui_watches" then
					icon = "%#DAPUIWatchesValue#" .. icons.ui.Watches .. "%*"
				end
				if ft == "dapui_breakpoints" then
					icon = "%#DapBreakpoint#" .. icons.ui.Bug .. "%*"
				end
				if ft == "dapui_console" then
					icon = "%#DevIconTerminal#"
						.. require("nvim-web-devicons").get_icon_by_filetype(
							"terminal",
							{}
						)
						.. " %*"
				end
				if ft == "dapui_stacks" then
					icon = "%#DAPUISource#" .. icons.ui.Stacks .. "%*"
				end
				if ft == "dapui_scopes" then
					icon = "%#DAPUIScope#" .. icons.ui.Scopes .. " %*"
				end
				if ft == "dap-repl" then
					icon = icons.ui.Repeat .. "%*"
				end
				if ft == "DiffviewFiles" then
					icon = icons.git.Diff .. "%*"
				end
				if ft == "Outline" then
					icon = icons.ui.BulletList .. "%*"
				end
				if ft == "trouble" then
					icon = " "
				end
				return icon
			end,
			padding = { left = 0, right = 0 },
			separator = { left = "", right = "" },
			fmt = function(str)
				return add_width(
					trunc(str, 10, 0, 5, true),
					"filetype",
					winbar_widths
				)
			end,
			-- cond = function()
			-- 	return vim.bo.filetype == "dap-repl" or string.match(vim.bo.filetype, "dapui") ~= nil
			-- end,
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
				return add_width(
					trunc(str, 10, 0, 5, true),
					"filetype",
					winbar_widths
				)
			end,
			cond = function()
				local ft = vim.bo.filetype
				return ft ~= "dap-repl"
					and string.match(ft, "dapui") == nil
					and ft ~= "DiffviewFiles"
					and ft ~= "Outline"
					and ft ~= "trouble"
			end,
		},
		{
			"filename",
			file_status = true, -- Displays file status (readonly status, modified status)
			newfile_status = true, -- Display new file status (new file means no write after created)
			path = 4, -- 0: Just the filename
			-- 1: Relative path
			-- 2: Absolute path
			-- 3: Absolute path, with tilde as the home directory
			-- 4: Filename and parent dir, with tilde as the home directory

			shorting_target = 40, -- Shortens path to leave 40 spaces in the window
			-- for other components. (terrible name, any suggestions?)
			symbols = {
				modified = "%#BarDiagError#" .. icons.ui.Dot .. "%*", -- Text to show when the file is modified.
				readonly = "%#BarDiagError#" .. icons.ui.Lock .. "%*", -- Text to show when the file is non-modifiable or readonly.
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
				if string.match(ft, "dapui") ~= nil then
					name = format_bubble(
						string.gsub(ft:gsub("dapui_", ""), "^%l", string.upper)
					)
				end
				::continue::
				return add_width(
					trunc(name, 10, 0, 5, true),
					"filename",
					winbar_widths
				)
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
				local total = 0
				if ctx.last_diagnostics_count[1] then
					for _, value in pairs(ctx.last_diagnostics_count[1]) do
						total = total + value
					end
				end

				if ft == "dap-repl" or string.match(ft, "dapui") ~= nil then
					return ""
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
					lualine_a = { git },
					lualine_b = {
						obsession,
						workspace_diagnostics,
						git_conflict,
					},
					lualine_c = {
						language_server,
						lint_progress,
						windsurf,
						asyncrun_status,
						overseer,
					},
					lualine_x = {
						show_macro_recording,
						location,
						"SleuthIndicator",
						fileformat,
						encoding,
					},
					lualine_y = { format_on_save },
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
					lualine_a = { root },
					lualine_c = { tabs },
					lualine_x = { harpoon },
				},
				extensions = {
					"fugitive",
					"nvim-dap-ui",
					"quickfix",
					"lazy",
					"mason",
					"nvim-dap-ui",
					"oil",
					"overseer",
					"trouble",
				},
			}

			return opts
		end,
	},
}
