local fn = vim.fn
local api = vim.api

local f = require('faith.functions')
local utils = require('faith.modules.statusline.utils')

local icons = require('faith.icons')

M = {}

M.options = {
	tabs = {
		list_buffers = false,
		show_tab_dir = false,
		equal_label_width = true, -- whether tab labels should all be the same width
		max_label_width = 21, -- max length of tab labels. Ignored if `equal_label_width` is false
		close_button = false,
		tab_seperator = 'slant',
		tab_spacer = true
	},
}

M.colors = {
	path = {
		icon = "TabLineProject",
		folder = "TabLinePath",
		seperator = "TabLinePathSep"
	},
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

local active_sep = 'arrow'

M.trunc_width = setmetatable({
	tabs = 140
}, {
	__index = function ()
		return 80 -- handle edge cases
	end
})

function M.is_truncated(_, width)
	local current_width = api.nvim_win_get_width(0)
	return current_width < width
end

function M.set_tab_number(tabnr)
	return '%' .. tabnr .. 'T'
end

function M.get_tab_name(tabnr)
	if fn.exists('g:loaded_taboo') ~= 0 then
		return fn.TabooTabName(tabnr)
	end
	return ''
end

function M.get_tab_buffers(self, tabnr)
	local tab_buffers = ''

	local buffers
	if self.options.tabs.list_buffers then
		buffers = fn.tabpagebuflist(tabnr)
	else
		buffers = {fn.tabpagebuflist(tabnr)[fn.tabpagewinnr(tabnr)]}
	end

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
	tab_buffers = utils.stl_escape(tab_buffers)
	return tab_buffers == '' and '[New]' or tab_buffers
end

function M.get_tab_modified(tabnr)
	local icon = icons.ui.Dot

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
		return icon
	end

	return ' '
end

function M.get_tab_label(self, tabnr)
	local tab_name = self.get_tab_name(tabnr)
	if tab_name ~= '' then
		return utils.stl_escape(tab_name)
	else
		return self.get_tab_buffers(self, tabnr)
	end
end

function M.get_dir_root()
	return fn.fnamemodify(fn.getcwd(-1, -1), ':t')
end

function M.get_tab_directory(self, tabnr)
	local tab_dir = fn.fnamemodify(fn.getcwd(-1, tabnr), ':t')
	if tab_dir ~= self.get_dir_root() then
		return fn.fnamemodify(fn.getcwd(-1, tabnr), ':.')
	end
	return ''
end

function M.create_tab_path(self, tabnr)
	if not self.options.tabs.show_tab_dir then
		return
	end
	local tab_dir = self.get_tab_directory(self, tabnr)
	if f.isempty(tab_dir) then
		return
	end
	tab_dir = utils.stl_escape(tab_dir)

	local dir_til_root = fn.fnamemodify(tab_dir, ':p:h')
	local home = os.getenv('HOME')
	dir_til_root = fn.substitute(dir_til_root, home, icons.ui.House, '')
	local short_folders = fn.pathshorten(dir_til_root)

	return '[' .. short_folders .. ']'
end

function M.file_path_is_too_long(self, path, trunc_width, seperator_padding)
	local root_width = fn.strdisplaywidth(self.get_dir_root()) + 8
	local file_path_width = fn.strdisplaywidth(path)
	return root_width + file_path_width
		-- also accounts for seperators because includes slashes which aren't removed yet
		+ ((seperator_padding * 2) * fn.count(path, '/'))
		> trunc_width
end

function M.get_file_path(self)
	local path_seperator = icons.separators.arrow_bracket.left
	local window_has_different_root = false

	local path_from_root = fn.expand('%:h', false)
	local path_breadcrumbs = ''

	-- current window has a working dir that differs from nvim's global working dir
	if fn.haslocaldir(0,0) == 1 then
		window_has_different_root = true
		local window_working_directory = fn.fnamemodify(vim.fn.getcwd(0, 0), ':r')
		local window_directory_tail = fn.fnamemodify(window_working_directory, ':t')

		if not f.isempty(window_directory_tail) then
			window_directory_tail = utils.stl_escape(window_directory_tail)
			path_from_root = string.insert(path_from_root, window_directory_tail .. '/', 0)
		end
	end

	if f.isempty(path_from_root) or path_from_root == '.' then
		return '', window_has_different_root
	end
	path_from_root = utils.stl_escape(path_from_root)

	local filetype = f.get_buf_option("filetype")
	if filetype == "toggleterm" then
		return path_seperator .. ' Terminal ', window_has_different_root
	end

	local half_nvim_width = math.floor(api.nvim_get_option('columns') * 0.5) - 8
	local seperator_padding = 1
	if self.file_path_is_too_long(self, path_from_root, half_nvim_width, seperator_padding)
	then
		path_from_root = fn.pathshorten(path_from_root)
		if
			self.file_path_is_too_long(self, path_from_root, half_nvim_width, seperator_padding)
		then
			path_from_root = string.gsub(path_from_root, '/.*$', '')
			.. '/' .. icons.ui.Ellipses
			.. '/' .. fn.fnamemodify(path_from_root, ':t')
		end
	end

	local folders = fn.split(path_from_root, '/')
	if folders[#folders] == '.' then
		table.remove(folders, #folders)
	end

	local seperator = utils.apply_padding(
		path_seperator,
		seperator_padding
	)
	if not window_has_different_root then
		path_breadcrumbs = path_breadcrumbs .. seperator
	end
	path_breadcrumbs = path_breadcrumbs
	..table.concat(
		folders,
		seperator,
		1,
		#folders
	)

	return path_breadcrumbs .. ' ', window_has_different_root
end

function M.create_path(self)
	local folder_icon = utils.highlight_str(
		utils.apply_padding(
			icons.ui.Project
		),
		self.colors.path.icon
	)
	local seperator = utils.highlight_str(
		icons.separators[active_sep]['left'],
		self.colors.path.seperator
	)
	local path_breadcrumbs, diff_root = self.get_file_path(self)
	local root_padding = (f.isempty(path_breadcrumbs) or diff_root) and 1 or 0
	local root_dir = folder_icon..
	utils.highlight_str(
		utils.apply_padding(
			utils.stl_escape(
				self.get_dir_root()
			),
			{ right = root_padding }
		),
		self.colors.path.folder
	)
	local a = utils.highlight_str(
			'%<' .. path_breadcrumbs,
		self.colors.path.folder
		)
	if diff_root then
		return root_dir .. seperator
			..utils.highlight_str(
				utils.apply_padding(
					icons.separators[active_sep]['left'],
					{ right = 1 }
				),
				self.colors.path.folder
			)
			.. a .. seperator
	else
		return root_dir ..  a .. seperator
	end
end

function M.create_close_button(tabnr)
	return '%' .. tabnr .. 'X' .. icons.ui.Close .. '%X'
end

function M.create_tab(self, tabnr, colors, seperators)
	local tab_number = utils.highlight_str(
		utils.apply_padding(
			tostring(tabnr)
		),
		colors.number
	)
	local tab_dir = utils.highlight_str(
		utils.apply_padding(
			self.create_tab_path(self, tabnr) or '',
			{ right = 1 } ),
		colors.label
	)
	local tab_modified = utils.highlight_str(
		utils.apply_padding(
			self.get_tab_modified(tabnr),
			0
		),
		colors.modified
	)

	local label_value = self.get_tab_label(self, tabnr)
	local display_label
	if self.options.tabs.equal_label_width then
		local max_label_width = self.options.tabs.max_label_width
		local label_width = fn.strdisplaywidth(label_value)
		if label_width > max_label_width then
			display_label = string.sub(label_value, 1, (max_label_width - 1)) .. icons.ui.Ellipses
		else
			local label_pad = math.floor((max_label_width - label_width) * 0.5)
			local offset = (label_pad * 2) + label_width == max_label_width and 0 or 1
			display_label = utils.apply_padding(
				label_value,
				{ left = (label_pad) - 1, right = (label_pad + offset) + 1 }
			)
		end
	else
		display_label = label_value
	end

	local tab_label = utils.highlight_str(
		utils.apply_padding(
			display_label,
			{ left = 1, right = 1 }
		),
		colors.label
	)

	local tab_close = ''
	if self.options.tabs.close_button then
		tab_close = utils.highlight_str(
			utils.apply_padding(
				self.create_close_button(tabnr),
				{ right = 1 }
			),
			colors.close
		)
	end

	local l_seperator = utils.highlight_str(
		seperators.right,
		colors.seperator
	)
	local r_seperator = utils.highlight_str(
		seperators.left,
		colors.seperator
	)

	local tab = string.format(
		'%s%s%s%s%s%s%s%s',
		self.set_tab_number(tabnr),
		l_seperator,
		tab_number,
		tab_dir,
		tab_modified,
		tab_label,
		tab_close,
		r_seperator
	)

	return tab
end

function M.get_visible_tabs(self)
	local nvim_width = api.nvim_get_option('columns')
	local half_nvim_width = math.floor(nvim_width * 0.5)
	local tab_label_width = self.options.tabs.max_label_width
	-- arbitrary estimate of display width for other tab elements i.e. number,
	-- modified, seperators. Not perfect/deterministic but too complicated actually
	-- obtaining this from the tabs because stl characters like highlights :c
	local wiggle_room = 8

	local i = 1
	repeat
		i = i + 1
	until (((tab_label_width * i) + (wiggle_room * i)) > half_nvim_width)
	return i - 1 == 0 and 1 or i - 1
end

vim.cmd([[
function! PreviousTab(minwid, clicks, mouse, mods)
	if a:clicks == 2 | execute "tabfirst" | return | endif
	execute "tabprevious"
endfunction
function! NextTab(minwid, clicks, mouse, mods)
	if a:clicks == 2 | execute "tablast" | return | endif
	execute "tabnext"
endfunction
]])

function M.get_tabline(self)
	local colors = self.colors
	local tab_seperators = icons.separators[self.options.tabs.tab_seperator] or 'slant'
	local tabline = ''
	local tabs = {}

	for i = 1, fn.tabpagenr('$'), 1 do
		local tab_colors = {}

		if i == fn.tabpagenr() then
			tab_colors = colors.tab.active
		else
			tab_colors = colors.tab.inactive
		end

		table.insert(tabs, self.create_tab(self, i, tab_colors, tab_seperators))
	end

	tabline = self.create_path(self) .. '%*' .. tabline .. '%='
	if fn.tabpagenr('$') > 1 then
		local visible_tabs = self.get_visible_tabs(self)
		local start_tab, end_tab
		if fn.tabpagenr('$') > visible_tabs then
				local current_tab_number = fn.tabpagenr()
			if visible_tabs == 1 then
				start_tab, end_tab = current_tab_number, current_tab_number
			else
				if current_tab_number == 1 then
					start_tab, end_tab = 1, visible_tabs
				elseif current_tab_number == #tabs then
					start_tab, end_tab = #tabs - (visible_tabs - 1), #tabs
				else
					local half_visible_tabs = math.ceil(visible_tabs * 0.5)
					local offset = visible_tabs % 2 == 0 and 1 or 2
					if current_tab_number < math.ceil(#tabs * 0.5) then
						start_tab, end_tab = current_tab_number - (half_visible_tabs - offset), current_tab_number + half_visible_tabs
					elseif current_tab_number == math.ceil(#tabs * 0.5) then
						local offset2 = visible_tabs % 2 == 0 and offset or offset - 1
						offset = offset - 1
						start_tab, end_tab = current_tab_number - (half_visible_tabs - offset), current_tab_number + (half_visible_tabs - offset2)
					else
						start_tab, end_tab = current_tab_number - half_visible_tabs, current_tab_number + (half_visible_tabs - offset)
					end
				end
			end
		else
			start_tab, end_tab = 1, #tabs
		end
		if start_tab > 1 then
			tabline = tabline .. string.format('%s', fn.tabpagenr() == 1 and '' or start_tab - 1 .. ' %@PreviousTab@' .. icons.ui.ArrowNavLeft .. '%X')
		end
		tabline = tabline .. table.concat(
			tabs,
			self.options.tabs.tab_spacer and ' ' or '',
			start_tab, end_tab
		)
		if (fn.tabpagenr('$') > visible_tabs) then
			tabline = tabline .. string.format('%s', fn.tabpagenr() == #tabs and '' or '%@NextTab@' .. icons.ui.ArrowNavRight .. '%X' .. fn.tabpagenr('$') - end_tab)
		end
		-- tabline = tabline .. string.format('%s/%s', #tabs - visible_tabs - 1, #tabs)
	end

	return tabline
end

Tabline = setmetatable(M, {
	__call = function (tabline)
		return tabline:get_tabline()
	end
})

local group = api.nvim_create_augroup("Tabline", { clear = true })
api.nvim_create_autocmd(
	{ "CursorMoved","CursorMovedI", "CursorHold", "InsertEnter",
		"BufWinEnter", "BufFilePost", "BufWritePost", "TabClosed",
		"VimResized" },
	{
		group = group,
		callback = function ()
			-- vim.cmd[[setlocal tabline=%!v:lua.Tabline()]]
			api.nvim_set_option_value("tabline", Tabline(), {scope = 'global'})
		end
	}
)
