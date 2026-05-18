local incline = require("incline")
local helpers = require("incline.helpers")

local icons = require("faith.icons")
local utils = require("faith.statusline.utils")

local mini_icons = require("mini.icons")
incline.setup({
	window = {
		placement = {
			vertical = "top",
			horizontal = "right",
		},
		padding = 0,
		margin = { horizontal = 0, vertical = 0 },
		overlap = {
			borders = true,
			statusline = false,
			tabline = false,
			winbar = false,
		},
	},
	hide = {
		cursorline = "smart",
	},
	ignore = {
		buftypes = {},
		filetypes = {},
		floating_wins = false,
		wintypes = function(winid, wintype)
			local zen_view = package.loaded["zen-mode.view"]
			if zen_view and zen_view.is_open() then
				return winid ~= zen_view.win
			end
			return vim.tbl_contains({
				-- "",
				"autocmd",
				"command",
				-- 'loclist',
				"popup",
				"preview",
				-- 'quickfix',
				"unknown",
			}, wintype)
		end,
		unlisted_buffers = false,
	},
	---@param props {buf: integer, focused: boolean, win: integer}
	render = function(props)
		local bt = vim.api.nvim_get_option_value("buftype", { buf = props.buf })
		if
			vim.tbl_contains({
				-- '',
				"acwrite",
				-- 'help',
				-- "nofile",
				"nowrite",
				-- "quickfix",
				-- "terminal",
				-- "prompt",
			}, bt)
		then
			return
		end

		local ft = vim.api.nvim_get_option_value("filetype", { buf = props.buf })
		local win_number = {
			(" %d "):format(vim.api.nvim_win_get_number(props.win)),
			group = "AccentInverse",
		}

		-- if bt == "nofile" and not vim.tbl_contains({ "OverseerList" }, ft) then
		-- 	return
		-- end
		if bt == "terminal" then
			return {
				win_number,
				group = "WinBar",
			}
		end

		if bt == "quickfix" then
			return {
				" ",
				utils.qf_title(),
				" ",
				utils.qf_label(),
				" ",
				win_number,
				group = "WinBar",
			}
		end

		if ft == "OverseerList" then
			local task_data =
				require("faith.statusline.components.overseer").get_data()
			local tasks = vim
				.iter(task_data)
				:map(function(status, task)
					return {
						task.icon,
						task.count,
						" ",
						group = task.group,
					}
				end)
				:totable()
			return {
				#tasks > 0 and " " or "",
				tasks,
				" Tasks ",
				win_number,
				group = "WinBar",
			}
		end
		if
			vim.list_contains({
				"dap-repl",
				"dapui_breakpoints",
				"dapui_console",
				"dapui_scopes",
				"dapui_stacks",
				"dapui_watches",
			}, ft)
		then
			if ft == "dap-repl" then
				return {
					" Repl ",
					win_number,
				}
			end
			return {
				" ",
				string.gsub(ft:gsub("dapui_", ""), "^%l", string.upper),
				" ",
				win_number,
			}
		end

		local filename =
			vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if filename == "" then
			filename = "[No Name]"
		end
		local ft_icon, ft_color = mini_icons.get("file", filename)
		local modified = vim.bo[props.buf].modified

		local function get_diagnostic_label()
			local diag_icons = {
				hint = icons.diagnostic.hint,
				info = icons.diagnostic.info,
				warning = icons.diagnostic.warn,
				error = icons.diagnostic.error,
			}
			local label = {}

			for severity, icon in pairs(diag_icons) do
				local n = #vim.diagnostic.get(
					props.buf,
					{ severity = vim.diagnostic.severity[string.upper(severity)] }
				)
				if n > 0 then
					table.insert(
						label,
						{ icon .. n .. " ", group = "WinBarDiagnosticSign" .. severity }
					)
				end
			end

			if #label > 0 then
				table.insert(label, 1, { " " })
			end

			return label
		end

		return {
			get_diagnostic_label(),
			ft_icon and {
				" ",
				ft_icon,
				" ",
				group = ft_color,
			} or " ",
			{
				filename,
				group = modified and "DiagnosticError" or "WinBar",
				gui = modified and "bold,italic" or "bold",
			},
			" ",
			win_number,
			group = "WinBar",
		}
	end,
})
