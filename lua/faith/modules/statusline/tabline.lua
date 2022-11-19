local fn = vim.fn
local api = vim.api

local f = require('faith.functions')
M = {}

M.icons = require('faith.icons')

M.colors = {
	tab = {
		active = {
			number    = 'TabLineSel',
			modified  = 'TabModifiedSelected',
			label     = 'TabLineSel',
			seperator = 'TabLineSelSep',
			close     = 'TabLineSelClose',
		},
		inactive = {
			number    = 'TabLineNum',
			modified  = 'TabModified',
			label     = 'TabLine',
			seperator = 'TabLineSep',
			close     = 'TabLineClose',
		}
	}
}

local default_padding = 1
local active_sep = 'arrow'

M.trunc_width = setmetatable({
	tabs = 140
}, {
	__index = function ()
		return 80 -- handle edge cases
	end
})

M.is_truncated = function (_, width)
	local current_width = api.nvim_win_get_width(0)
	return current_width < width
end

M.set_tab_number = function (tabnr)
	return '%' .. tabnr .. 'T'
end

M.get_tab_name = function (tabnr)
	if fn.exists('g:loaded_taboo') ~= 0 then
		return fn.TabooTabName(tabnr)
	end
	return ''
end

---Escape % in str so it doesn't get picked as stl item.
---@param str string
---@return string
function M.stl_escape(str)
  if type(str) ~= 'string' then
    return str
  end
  return str:gsub('%%', '%%%%')
end

M.get_tab_buffers = function (self, tabnr)
	local tab_buffers = ''

	local buffers = fn.tabpagebuflist(tabnr)

	for _, buffer in pairs(buffers) do
		local buf = api.nvim_buf_get_option(buffer, 'buftype')
		if buf == 'nofile' then
			goto continue
		elseif buf == 'prompt' then
			goto continue
		elseif buf == 'help' then
			tab_buffers = tab_buffers .. '[H]' .. fn.fnamemodify(fn.bufname(buffer), ':t:s/.txt$//') .. ', '
		elseif buf == 'quickfix' then
			tab_buffers = tab_buffers .. '[Q]' .. fn.getqflist({title = 1}).title
		elseif fn.getbufvar(buffer, "&modifiable") then
			local name = api.nvim_buf_get_name(buffer)
			if not f.isempty(name) then
				if string.match(name, "fugitive://(.*)%.git%/%/$") then
					tab_buffers = tab_buffers .. '[Git]Status, '
				elseif string.match(name, "fugitive://(.*)%.git%/%/[^\n]") then
					tab_buffers = tab_buffers .. '[Git]Diff, '
				else
					tab_buffers = tab_buffers .. fn.fnamemodify(fn.bufname(buffer), ':t') .. ', '
				end
			else
				tab_buffers = tab_buffers .. '[New], '
			end
		end
		::continue::
	end

	tab_buffers = fn.substitute(tab_buffers, ', $', '', '')
	tab_buffers = self.stl_escape(tab_buffers)
	return tab_buffers == '' and '[New]' or tab_buffers
end

M.get_tab_modified = function (self, tabnr)
	local icon = self.icons.ui.Dot

	local buffers = fn.tabpagebuflist(tabnr)
	local modified_count = 0

	for _, buffer in pairs(buffers) do
		local buf = api.nvim_buf_get_option(buffer, 'buftype')

		if api.nvim_buf_get_option(buffer, "mod") then
			if buf == 'prompt' then
				goto continue
			end
			modified_count = modified_count + 1
		end
		::continue::
	end

	if modified_count > 0 then
		return icon .. ' '
	end

	return ''
end

M.get_tab_label = function (self, tabnr)
	local tab_name = self.get_tab_name(tabnr)
	if tab_name ~= '' then
		return self.stl_escape(tab_name)
	else
		return self.get_tab_buffers(self, tabnr)
	end
end

M.get_dir_root = function ()
	return fn.fnamemodify(fn.getcwd(0, 0), ':t')
end

M.get_file_path = function (self)
	local path_seperator = self.icons.separators.arrow_bracket.left
	local path_from_root = fn.expand('%:h', false)
	path_from_root = self.stl_escape(path_from_root)
	local path_breadcrumbs = ''

	local filetype = f.get_buf_option("filetype")
	filetype = self.stl_escape(filetype)

	if filetype == "java" then
		path_from_root = fn.substitute(path_from_root, '.*\\ze\\<com\\>', '', '')
		path_breadcrumbs = path_breadcrumbs .. path_seperator
		path_breadcrumbs = path_breadcrumbs .. self.apply_padding(
			self.icons.ui.Ellipses,
			1
		)
	elseif filetype == "toggleterm" then
		path_from_root = ""
	end

	local folders = fn.split(path_from_root, '/')

	for _, value in pairs(folders) do
		if value == '.' then goto continue end
		path_breadcrumbs = path_breadcrumbs .. path_seperator .. " "
		path_breadcrumbs = path_breadcrumbs .. value .. " "
		::continue::
	end

	return path_breadcrumbs
end

M.create_path = function (self)
	local folder_icon = self.apply_padding(
		self.icons.ui.Project
	)
	local root_dir = self.apply_padding(
		self.get_dir_root(),
		{ right = 1 }
	)
	local path_breadcrumbs = self.get_file_path(self)

	local a = self.highlight_str(
		folder_icon .. root_dir .. path_breadcrumbs,
		"@text.note"
	)
	local seperator = self.highlight_str(
		self.icons.separators[active_sep]['left'],
		"Function"
	)
	return a .. seperator
end

M.apply_padding = function (content, padding)
	local element = content
	local pad = padding
	local l_padding, r_padding

	if f.isempty(pad) then
		pad = default_padding
	end

	if type(pad) == 'number' then
		l_padding, r_padding = pad, pad
	elseif type(pad) == 'table' then
		l_padding, r_padding = pad.left, pad.right
	end

	if l_padding then
		element = string.insert(element, string.rep(' ', l_padding), 0)
	end
	if r_padding then
		element = string.insert(element, string.rep(' ', r_padding), #element)
	end

	return element
end

M.highlight_str = function (str, highlight)
	return '%#' .. highlight .. '#' .. str .. '%*'
end

M.create_tab = function (self, tabnr, colors, seperators)
	local tab_number = self.highlight_str(
		self.apply_padding(
			tostring(tabnr)
		),
		colors.number
	)
	local tab_modified = self.highlight_str(
		self.apply_padding(
			self.get_tab_modified(self, tabnr),
			0
		),
		colors.modified
	)
	local tab_label = self.highlight_str(
		self.apply_padding(
			self.get_tab_label(self, tabnr),
			{ left = 0, right = 1 }
		),
		colors.label
	)

	local l_seperator = self.highlight_str(
		seperators.right,
		colors.seperator
	)
	local r_seperator = self.highlight_str(
		seperators.left,
		colors.seperator
	)

	local tab = string.format(
		'%s%s%s%s%s%s',
		self.set_tab_number(tabnr),
		l_seperator,
		tab_number,
		tab_modified,
		tab_label,
		r_seperator
	)

	return tab
end

M.get_tabline = function (self)
	local colors = self.colors
	local tabline = ''
	local tabs = {}

	for i = 1, fn.tabpagenr('$'), 1 do
		local tab_colors = {}

		if i == fn.tabpagenr() then
			tab_colors = colors.tab.active
		else
			tab_colors = colors.tab.inactive
		end

		table.insert(tabs, self.create_tab(self, i, tab_colors, self.icons.separators.slant))
	end

	tabline = tabline .. self.create_path(self) .. '%*'
	if fn.tabpagenr('$') > 1 then
		tabline = tabline .. '%=' .. table.concat(tabs, ' ', 1, #tabs)
	end

	return tabline
end

Tabline = setmetatable(M, {
	__call = function (tabline)
		return tabline:get_tabline()
	end
})

local group = api.nvim_create_augroup("Tabline", {})
api.nvim_create_autocmd(
	{ "CursorMoved","CursorMovedI", "CursorHold", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost", "TabClosed" },
	{
		group = group,
		callback = function ()
			-- vim.cmd[[setlocal tabline=%!v:lua.Tabline()]]
			api.nvim_set_option_value("tabline", Tabline(), {scope = 'global'})
		end
	}
)
