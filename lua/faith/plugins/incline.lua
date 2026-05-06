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
		floating_wins = true,
		unlisted_buffers = false,
		wintypes = {
			-- "",
			"autocmd",
			"command",
			-- 'loclist',
			"popup",
			"preview",
			-- 'quickfix',
			"unknown",
		},
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
				"terminal",
				"prompt",
			}, bt)
		then
			return
		end

		local ft = vim.api.nvim_get_option_value("filetype", { buf = props.buf })
		local win_number = {
			(" %d "):format(vim.api.nvim_win_get_number(props.win)),
			group = "AccentInverse",
		}

		if bt == "nofile" and not vim.tbl_contains({ "OverseerList" }, ft) then
			return
		end

		if bt == "quickfix" then
			return {
				" ",
				utils.qf_title(),
				" ",
				win_number,
				" ",
				utils.qf_label(),
				" ",
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
				win_number,
				" Tasks ",
				group = "WinBar",
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
			win_number,
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
			group = "WinBar",
		}
	end,
})
