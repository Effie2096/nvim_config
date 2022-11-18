local fn = vim.fn
local api = vim.api

M = {}

M.seperators = {
	slant = { left = '', right = '' },
	rounded = { left = '', right = '' },
	arrow = { left = '', right = '' },
	arrow_bracket = { left = '', right = ''},
	rounded_bracket = { left = '', right = '' },
	blank = { left = '', right = '' },
}

M.icons = {
	modified = '',
	ui = {
		Bug = "",
		Stacks = " ",
		Scopes = "",
		Watches = "",
		Chevron_Right = ''
	},
	diagnostic = {
		error = ' ',
		warn = ' ',
		info = ' ',
		hint = ' ',
	},
}

M.colors = {
	winbar = {
		active = {
			number = {
				label = 'WinBarWinNum',
				seperator = 'WinBarWinNumEnd'
			},
			file = {
				label = 'WinBarFile',
				seperator = 'WinBarFileEnd'
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

local default_padding = 1

local excludes = function (self, win)
	local bufnr = api.nvim_win_get_buf(win)
	local filetype = api.nvim_buf_get_option(bufnr, 'filetype')
	return vim.tbl_contains(self.winbar_filetype_exclude or {}, filetype)
end

M.highlight_str = function (str, highlight)
	return '%#' .. highlight .. '#' .. str .. '%*'
end

M.apply_padding = function (content, padding)
	local f = require('faith.functions')
	local l_padding, r_padding

	-- use default if padding not specified
	if f.isempty(padding) then
		padding = default_padding
	end

	-- check if padding is a number or a table
	if type(padding) == 'number' then
		l_padding, r_padding = padding, padding
	elseif type(padding) == 'table' then
		if f.exists("pad.left") then
			if type(padding.left) == 'number' then
				l_padding = padding.left
			end
		end
		if f.exists("pad.right") then
			if type(padding.right) == 'number' then
				r_padding = padding.right
			end
		end
	end

	-- don't pad empty elements
	if not f.isempty(content) then
		if l_padding then
			content = string.insert(content, string.rep(' ', l_padding), 0)
		end
		if r_padding then
			content = string.insert(content, string.rep(' ', r_padding), #content)
		end
	end

	return content
end

M.win_number = function (self, win)
	local seperators = self.seperators.rounded
	local color = self.colors.winbar.active.number
	local sepHL, hl = color.seperator, color.label

	local winnr = api.nvim_win_get_number(win)

	return self.highlight_str(seperators.right, sepHL)
		.. self.highlight_str(winnr, hl)
		.. self.highlight_str(seperators.left, sepHL)
end

M.get_filename = function (self, win)
	-- local colors = self.colors.winbar.active
	local icons = self.icons.ui
	--[[ local filename = fn.expand("%:t")
	local extension = fn.expand("%:e") ]]
	local bufnr = api.nvim_win_get_buf(win)
	local filename = fn.fnamemodify(api.nvim_buf_get_name(bufnr), ":t")
	local extension = api.nvim_buf_get_option(bufnr, 'filetype')
	local f = require('faith.functions')

		local file_icon, file_icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
		local hl_group = "FileIconColor" .. extension

		api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
		-- filename = self.highlight_str(filename, colors.file.label)

		if extension == "dapui_breakpoints" then
			file_icon = icons.Bug
		end

		if extension == "dapui_stacks" then
			file_icon = icons.Stacks
		end

		if extension == "dapui_scopes" then
			file_icon = icons.Scopes
		end

		if extension == "dapui_watches" then
			file_icon = icons.Watches
		end

		if extension == "toggleterm" then
			filename = "ToggleTerm"
			hl_group = "DevIconTerminal"
			file_icon = ""
		end

		if extension == "fugitive" then
			filename = "Fugitive"
			hl_group = "DevIconGitLogo"
			file_icon = ""
		end

		if filename == "COMMIT_EDITMSG" then
			filename = "Commit"
			hl_group = "DevIconGitLogo"
			file_icon = require('nvim-web-devicons').get_icon_by_filetype('git', {})
		end

		return self.highlight_str(file_icon, hl_group) .. ' ' .. filename
end

M.get_file_modified = function (self, win)
	local icon = self.icons.modified

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

		local status_ok, navic_location = pcall(navic.get_location, {})
		if not status_ok then
			return ""
		end

		if not navic.is_available() or navic_location == 'error' then
			return ""
		end

		if not f.isempty(navic_location) then
			self._navic_cache[win] = navic_location
			return navic_location
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
		return "hi"
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
		local icons = self.icons.diagnostic
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
				local part = self.highlight_str(
					self.apply_padding(
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

-- TODO: Add container which user can scroll when truncated <17-11-22, Effie2096>
--[[ M.create_section = function (segments, seperator, max_length)
	local section = table.concat(segments, seperator, 1, #segments)
	local section_length = fn.strdisplaywidth(section)

	if section_length > max_length then
		return "too long lol"
	end
	return section
end ]]

M.get_winbar = function (self, win)
	if excludes(self, win) then
		return
	end
	local colors = self.colors.winbar.active
	local f = require('faith.functions')
	local winbar

	local win_number = self.apply_padding(self.win_number(self, win), 0)
	local filename = self.apply_padding(
		self.get_filename(self, win),
		{ left = 1 }
	)
	local file_modified = self.highlight_str(
		self.apply_padding(
			self.get_file_modified(self, win),
			{ left = 1 }
		),
		colors.modified
	)
	local diagnostics = self.apply_padding(
		self.get_buffer_diagnostics(self, win, { error = true, warn = true, info = true})
	)

	local navic_sep = ''
	local navic = self.get_navic(self, win)
	if not f.isempty(navic) then
		navic_sep = self.apply_padding(
			self.icons.ui.Chevron_Right,
			1
		)
	end

	if not f.isempty(filename) then
		winbar = string.format(
			'%s%s%s%s%s%s%s%s',
			win_number,
			file_modified,
			filename,
			navic_sep,
			'%<',
			navic,
			'%=',
			diagnostics
		)
		-- local win_width = api.nvim_win_get_width(api.nvim_get_current_win())
		-- local winbar_text_width = string.len(winbar)
		-- local navic_width = win_width - winbar_text_width
	end

	return winbar
end

Winbar = setmetatable(M, {
	__call = function (winbar, winnr)
		return winbar:get_winbar(winnr)
	end
})

local group = api.nvim_create_augroup("Winbar", {})
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
