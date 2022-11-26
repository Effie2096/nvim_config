local fn = vim.fn
local api = vim.api

local utils = require('faith.modules.statusline.utils')

local icons = require('faith.icons')

M = {}

M.colors = {
	winbar = {
		active = {
			number = {
				label = 'WinBarWinNum',
				seperator = 'WinBarWinNumEnd'
			},
			file = {
				label = 'WinBarFile',
				seperator = 'WinBarFileEnd',
				file_to_navic = 'WinBarFileSep'
			},
			navic = {
				label = 'WinBarNavic',
				seperator = 'WinBarNavicEnd'
			},
			modified = 'WinBarFileModified',
			diagnostic = {
				error = 'DiagnosticError',
				warn = 'DiagnosticWarn',
				info = 'DiagnosticInfo',
				hint = 'DiagnosticHint',
			}
		}
	}
}

M.winbar_filetype_exclude = {
	-- "help",
	"startify",
	"dashboard",
	"packer",
	"vim-plug",
	"neogitstatus",
	"NvimTree",
	"Trouble",
	"TelescopePrompt",
	"alpha",
	"lir",
	"Outline",
	"spectre_panel",
	-- "toggleterm",
	"DressingSelect",
	"Jaq",
	"harpoon",
	-- "dapui_scopes",
	-- "dapui_breakpoints",
	-- "dapui_stacks",
	-- "dapui_watches",
	"dap-repl",
	"dap-terminal",
	"dapui_console",
	"lab",
	"Markdown",
	"",
}

local excludes = function (self, win)
	local bufnr = api.nvim_win_get_buf(win)
	local filetype = api.nvim_buf_get_option(bufnr, 'filetype')
	return vim.tbl_contains(self.winbar_filetype_exclude or {}, filetype)
end

M.win_number = function (self, win)
	local seperators = icons.separators.rounded
	local color = self.colors.winbar.active.number
	local sepHL, hl = color.seperator, color.label

	local winnr = api.nvim_win_get_number(win)

	return utils.highlight_str(seperators.right, sepHL)
		.. utils.highlight_str(winnr, hl)
		.. utils.highlight_str(seperators.left, sepHL)
end

M.get_filename = function (self, win)
	local icons = icons
	local bufnr = api.nvim_win_get_buf(win)
	local filename = fn.fnamemodify(api.nvim_buf_get_name(bufnr), ":t")
	local extension = fn.fnamemodify(api.nvim_buf_get_name(bufnr), ":e")
	local filetype = api.nvim_buf_get_option(bufnr, 'filetype')

	local file_icon, color
	local hl_group

	-- Filetypes with no associated web-devicon hl
	if filetype == "dapui_breakpoints" then
		hl_group = "DapBreakpoint"
		file_icon = icons.ui.Bug
		goto continue
	end

	if filetype == "dapui_stacks" then
		hl_group = "DAPUISource"
		file_icon = icons.ui.Stacks
		goto continue
	end

	if filetype == "dapui_scopes" then
		hl_group = "DAPUIScope"
		file_icon = icons.ui.Scopes
		goto continue
	end

	if filetype == "dapui_watches" then
		hl_group = "DAPUIWatchesValue"
		file_icon = icons.ui.Watches
		goto continue
	end

	-- Gets skipped by above conditions
	file_icon, color = require('nvim-web-devicons').get_icon(filename, extension, {default = true})
	hl_group = color

	-- These come after devicon api call because they alter the filename
	if filetype == "toggleterm" then
		filename = "ToggleTerm"
		hl_group = "DevIconTerminal"
		file_icon = require('nvim-web-devicons').get_icon_by_filetype("terminal", {})
	end

	if filetype == "java" and extension == "class" then
		hl_group = "DevIconJava"
		file_icon = require('nvim-web-devicons').get_icon_by_filetype(filetype, {})
	end

	if filetype == "fugitive" then
		filename = "Fugitive"
		hl_group = "DevIconGitLogo"
		file_icon = require('nvim-web-devicons').get_icon_by_filetype('git', {})
	end

	-- ..get_icon('COMMIT_EDITMSG', 'gitcommit', ...) does return something
	-- but I don't like the color + setting a nicer file name
	if filename == "COMMIT_EDITMSG" then
		filename = "Commit"
		hl_group = "DevIconGitLogo"
		file_icon = require('nvim-web-devicons').get_icon_by_filetype('git', {})
	end

	::continue::

	-- create custom hl for file icon
	local winbar_icon_hl = 'Winbar' .. hl_group
	if fn.hlexists(winbar_icon_hl) == 0 then
		local bg_hl = api.nvim_get_hl_by_name(self.colors.winbar.active.file.label, true)
		local fg_hl = api.nvim_get_hl_by_name(hl_group, true)
		api.nvim_set_hl(0, winbar_icon_hl, { bg = bg_hl.background, fg = fg_hl.foreground })
	end

	hl_group = winbar_icon_hl

	filename = utils.stl_escape(filename)

	return utils.highlight_str(file_icon .. ' ', hl_group)
		.. utils.highlight_str(filename .. ' ', self.colors.winbar.active.file.label)
end

M.get_file_modified = function (self, win)
	local icon = icons.ui.Dot

	local bufnr = api.nvim_win_get_buf(win)
	if api.nvim_buf_get_option(bufnr, 'mod') then
		return icon
	end
	return ''
end

M._navic_cache = {}

M.get_navic = function (self, win)
	local bufnr = api.nvim_win_get_buf(win)
	local f = require("faith.functions")

	local client_active = self.is_client_attached(bufnr)
	if not client_active then return "" end

	local current_win = api.nvim_get_current_win()
	if current_win == win then

		local status_navic_ok, navic = pcall(require, 'nvim-navic')
		if not status_navic_ok then
			return ""
		end

		if not navic.is_available() then
			return ""
		end

		local navic_data = navic.get_data()
		local next = next
		if not f.isempty(navic_data) then
			if next(navic_data) ~= nil then
				local gps = ''
				local i = 0
				for _, value in pairs(navic_data) do
					i = i + 1
					gps = gps .. utils.highlight_str(value.icon, 'WinbarNavicIcons' .. value.type)
					gps = gps .. utils.highlight_str(
						vim.fn.substitute(value.name, '(.*)','',''),
						self.colors.winbar.active.navic.label
					)
					if i ~= #navic_data then
						gps = gps .. utils.highlight_str(
							utils.apply_padding(icons.separators.arrow_bracket.left),
							'WinbarNavicSeparator'
						)
					end
				end
				gps = gps .. utils.highlight_str(' ', self.colors.winbar.active.navic.label)
				self._navic_cache[win] = gps
				return gps
			else
				return ""
			end
		else
			return ""
		end
	else
		if f.exists("self._navic_cache[win]") then
			if not f.isempty(self._navic_cache[win]) then
				return self._navic_cache[win]
			end
			return ""
		end
		return ""
	end
end

M.is_client_attached = function (bufnr)
	for _, client in pairs(vim.lsp.get_active_clients()) do
		local attached_buffers = client["attached_buffers"]
		if attached_buffers[bufnr] then
			return true
		end
	end
	return false
end

M.get_buffer_diagnostics = function (self, win, levels)
	local diagnostics = { error = '', warn = '', info = '', hint = '', }

	local bufnr = api.nvim_win_get_buf(win)
	local client_active = self.is_client_attached(bufnr)

	if client_active then
		local icons = icons.diagnostic
		local colors = self.colors.winbar.active.diagnostic
		local enabled_levels

		if type(levels) == 'table' then
			enabled_levels = levels
		else
			enabled_levels = { error = true, warn = true, info = true, hint = true, }
		end

		for level, value in pairs(enabled_levels) do
			if value then
				local count = #vim.diagnostic.get(
					bufnr,
					{ severity = vim.diagnostic.severity[string.upper(level)] }
				)
				local part = utils.highlight_str(
					utils.apply_padding(
						icons[level] .. count,
						{ left = 1 }
					),
					colors[level]
				)

				diagnostics[level] = part
			end
		end
	end

	return diagnostics["error"]
		.. diagnostics["warn"]
		.. diagnostics["info"]
		.. diagnostics["hint"]
end

M.get_winbar = function (self, win)
	if excludes(self, win) then
		return
	end
	local colors = self.colors.winbar.active
	local f = require('faith.functions')
	local winbar

	local win_number = utils.apply_padding(self.win_number(self, win), 0)
	local filename = utils.apply_padding(
		self.get_filename(self, win),
		0
	)
	local file_modified = utils.highlight_str(
		utils.apply_padding(
			self.get_file_modified(self, win),
			{ right = 1 }
		),
		colors.modified
	)

	local file_start = utils.highlight_str(
		utils.apply_padding(
			icons.separators.rounded.right,
			{ left = 1 }
		),
		colors.file.seperator
	)

	local file_end = utils.highlight_str(
		icons.separators.arrow.left,
		colors.file.seperator
	)

	local diagnostics = utils.apply_padding(
		self.get_buffer_diagnostics(self, win, { error = true, warn = true, info = true})
	)

	local navic_sep = ''
	local navic = self.get_navic(self, win)
	if not f.isempty(navic) then
		navic_sep = utils.highlight_str(
			utils.apply_padding(
			icons.separators.arrow.left,
				{ right = 1 }
			),
			colors.file.file_to_navic
		)
		file_end = utils.highlight_str(
			icons.separators.arrow.left,
			colors.navic.seperator
		)
	end

	if not f.isempty(filename) then
		winbar = string.format(
			'%s%s%s%s%s%s%s%s%s%s',
			win_number,
			file_start,
			file_modified,
			filename,
			navic_sep,
			'%<',
			navic,
			file_end,
			'%=',
			diagnostics
		)
	end

	return winbar
end

Winbar = setmetatable(M, {
	__call = function (winbar, winnr)
		return winbar:get_winbar(winnr)
	end
})

local group = api.nvim_create_augroup("Winbar", { clear = true })
api.nvim_create_autocmd(
	{ "CursorMoved", "CursorMovedI", "CursorHold", "CursorHoldI", "BufRead", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost", "TabClosed" },
	{
		group = group,
		callback = function ()
			-- we're only concerned with the current tab
			local curtab = api.nvim_get_current_tabpage()
			local tab_wins = api.nvim_tabpage_list_wins(curtab)

			-- loop through all wins in tab, setting their winbar
			for _, win in ipairs(tab_wins) do
				-- ignore all floating windows
				if api.nvim_win_get_config(win).zindex then
					goto continue
				end

				local bufnr = api.nvim_win_get_buf(win)
				-- skip lsp floating windows
				local status_ok, _ = pcall(api.nvim_buf_get_var, bufnr, 'lsp_floating_window')
				if not status_ok then
					local winbar_content = Winbar(win)
					-- check returned winbar isn't empty. (causes error in tostring())
					if require('faith.functions').isempty(winbar_content) then
						goto continue
					end
					api.nvim_win_set_option(win, 'winbar', tostring(winbar_content))
				end
				::continue::
			end
		end
	}
)
