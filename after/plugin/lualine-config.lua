M = {}

local navic_status_ok, navic = pcall(require, "nvim-navic")
if not navic_status_ok then
	return
end
local colors = require('catppuccin.palettes').get_palette()

vim.cmd [[
function! MyTabLine()
	let leftSep			 = ''
	let rightSep		 = ' '
	let modifiedFlag = ''
	let close = ''
	let s = ''
	" let s = '%#WinBarWinNum# Tabs  %#WinBarWinNumEnd#%*  '
	" loop through each tab page
	let tabHL = ''
	let tabSepHL = ''
	let tabNumHL = ''
	let tabModHL = ''
	let tabCloseHL = ''
	for i in range(tabpagenr('$'))
		if i + 1 == tabpagenr()
			let tabNumHL	 = '%#TabLineSel#'
			let tabModHL	 = '%#TabModifiedSelected#'
			let tabHL			 = '%#TabLineSel#'
			let tabSepHL	 = '%#TabLineSelSep#'
			let tabCloseHL = '%#TabLineSelClose#'
		else
			let tabNumHL	 = '%#TabLineNum#'
			let tabModHL	 = '%#TabModified#'
			let tabHL			 = '%#TabLine#'
			let tabSepHL	 = '%#TabLineSep#'
			let tabCloseHL = '%#TabLineClose#'
		endif

		" let s .= tabSepHL
		" let s .= leftSep
		let s .= tabHL
		let s .= tabNumHL

		" let numMap = {
		"				\ '0': '🯰',
		"				\ '1': '🯱',
		"				\ '2': '🯲',
		"				\ '3': '🯳',
		"				\ '4': '🯴',
		"				\ '5': '🯵',
		"				\ '6': '🯶',
		"				\ '7': '🯷',
		"				\ '8': '🯸',
		"				\ '9': '🯹'
		"				\}
		" set the tab page number (for mouse clicks)
		let s .= '%' . (i + 1) . 'T '

		" set page number string
		" for n in split(i + 1, '\zs')
		"		let s .= numMap[n]
		" endfor

		let s .= i + 1 . ' '
		" let s .= ' '

		let n = ''	" temp str for buf names
		let m = 0		" &modified counter
		" get buffer names and statuses
		let buflist = tabpagebuflist(i + 1)
		" loop through each buffer in a tab
		for b in buflist
			let buf = getbufvar(b, "&buftype")
			if buf == 'nofile'
				continue
			elseif buf == 'prompt'
				continue
			elseif buf == 'help'
				let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//') . ', '
			elseif buf == 'quickfix'
				let n .= '[Q]'
			elseif getbufvar(b, "&modifiable")
				let n .= fnamemodify(bufname(b), ':t') . ', ' " pathshorten(bufname(b))
			endif
			if getbufvar(b, "&modified")
				let m += 1
			endif
		endfor
		" let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
		let n = substitute(n, ', $', '', '')
		" add modified label
		if m > 0
			let s .= tabModHL
			let s .= modifiedFlag
			let s .= ' '
			let s .= tabHL
			" let s .= '[' . m . '+]'
		endif

		let tabooName = TabooTabName(i + 1)
		if tabooName != ""
			let s .= tabooName
			" let s .= ' '
			" let s .= ' ¦ '
		else
			" add buffer names
			if n == ''
				let s.= '[New]'
			else
				let s .= n
			endif
		endif

		let s .= tabHL
		" switch to no underlining and add final space
		" let s .= ' '
		" let s .= tabCloseHL
		" let s .= '%999X' . close
		" let s .= tabHL
		let s .= ' '
		" let s .= tabSepHL
		" let s .= rightSep
	endfor
	" let s .= '%#TabLineFill#%T'



	"right-aligned close button
	" if tabpagenr('$') > 1
	"		let s .= '%=%#TabLineFill#%999X '
	" endif
	return s
endfunction
]]
-- vim.opt.rulerformat = "%17(%l/%L:%c%)"

local indent = {
	function()
		local space_pat = [[\v^ +]]
		local tab_pat = [[\v^\t+]]
		local space_indent = vim.fn.search(space_pat, 'nwc')
		local tab_indent = vim.fn.search(tab_pat, 'nwc')
		local mixed = (space_indent > 0 and tab_indent > 0)
		local mixed_same_line
		if not mixed then
			mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
			mixed = mixed_same_line > 0
		end
		if not mixed then return '' end
		if mixed_same_line ~= nil and mixed_same_line > 0 then
			return 'hix@' .. mixed_same_line
		end
		local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
		local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
		if space_indent_cnt > tab_indent_cnt then
			return 'tab@' .. tab_indent
		else
			return 'spc@' .. space_indent
		end
	end
}

local trailing_space = {
	function()
		local space = vim.fn.search([[\s\+$]], 'nwc')
		return space ~= 0 and "trailing: " .. space or ""
	end
}

local encoding = {
	"fileformat",
	padding = { left = 0, right = 1 },
	fmt = function(str)
		if str == '' then -- only show if *not* unix format
			return ''
		end
		return str
	end
}

local fileformat = {
	"encoding",
	padding = { left = 0, right = 1 },
	fmt = function(str)
		if str == 'utf-8' then -- only show if *not* utf-8
			return ''
		end
		return str
	end
}

local trans_flag = {
	{ '" "', color = { bg = '#5bcffa', --[[fg = '#FF1B8D',]] }, padding = 0, separator = { left = '', right = '' }, },
	{ '" "', color = { bg = '#ffb5cd', --[[fg = '#FF1B8D',]] }, padding = 0, },
	{ '" "', color = { bg = '#ffffff', --[[fg = '#FFDA00',]] }, padding = 0, },
	{ '" "', color = { bg = '#ffb5cd', --[[fg = '#1BB3FF',]] }, padding = 0, },
	{ '" "', color = { bg = '#5bcffa', --[[fg = '#1BB3FF',]] }, padding = 0, },
}

function SetWinbarNavic()
	local location = navic.get_location()
	if (navic.is_available()) and (location ~= "") then
		local data = vim.fn.substitute(location, "(.*)", "", "")
		return " %#WinBarFileSep# %#WinBarNavic#" .. data .. " %#WinBarNavicEnd#"
	else
		return ''
	end
end

function GetFileTypeIcon()
	---@diagnostic disable-next-line: missing-parameter
	local file = vim.fn.expand('%')
	if (package.loaded['nvim-web-devicons']) and (file ~= '') then
		---@diagnostic disable-next-line: missing-parameter
		local icon, color = require 'nvim-web-devicons'.get_icon(file, vim.fn.expand('%:e'), { default = true })
		return { icon, color }
	else
		return { '', nil }
	end
end

function WinBarDir()
	local f = require('faith.functions')
	local seperator = '' --❯

	local path_breadcrumbs = ''
	---@diagnostic disable-next-line: missing-parameter
	local path_from_root = vim.fn.expand('%:h', false)

local filetype = f.get_buf_option "filetype"
	if filetype == "java" then
		path_from_root = vim.fn.substitute(path_from_root, '.*\\ze\\<com\\>', '', '')
		path_breadcrumbs = path_breadcrumbs .. seperator .. " … "
elseif filetype == "toggleterm" then
		path_from_root = ""
	end

	local folders = vim.fn.split(path_from_root, '/')

	for _, value in pairs(folders) do
		if value == '.' then goto continue end
		path_breadcrumbs = path_breadcrumbs .. seperator .. " "
		path_breadcrumbs = path_breadcrumbs .. value .. " "
		::continue::
	end

	return path_breadcrumbs
end

function WinBarRoot()
	local root = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
	local win_root = ""
	-- win_root = win_root .. ' '
	win_root = win_root .. root
	return win_root
end

function WinBarFile()
	---@diagnostic disable-next-line: missing-parameter
	local file = vim.fn.expand('%:t:r')
	local string = ""
	if file ~= "" then
		local f = require('faith.functions')
		local icon = GetFileTypeIcon()

		if string.find(file, ';#toggleterm#') then
			file = "ToggleTerm"
			icon[2] = "DevIconTerminal"
			icon[1] = ""
		end

		string = string .. "%#WinBarFileEnd#%#WinBarFile#"
		-- string = string .. WinBarDir()
		string = string .. "%#Winbar" .. icon[2] .. "#" .. icon[1] .. "%#WinBarFile# " .. file
		if f.get_buf_option "mod" then
			string = string .. '%#WinBarFileModified# '
			string = string .. ''
		end
		if SetWinbarNavic() ~= "" then
			string = string .. SetWinbarNavic()
		else
			string = string .. " %#WinBarFileEnd#%*"
		end
	end
	return string
end

function WinBarGitStatus()
	local git_dict = vim.api.nvim_eval("get(b:,'gitsigns_status_dict', '')")
	-- local seperators = { '', '' }
	local addSign = "+"
	local changeSign = "~"
	local removeSign = "-"

	local diff_status = ""

	if git_dict ~= "" then
		local git_added = git_dict['added']
		local git_changed = git_dict['changed']
		local git_removed = git_dict['removed']

		if (git_added ~= nil) or (git_changed ~= nil) or (git_removed ~= nil) then
			if (git_added ~= 0) or (git_changed ~= 0) or (git_removed ~= 0) then

				-- diff_status = diff_status .. '%#WinBarDiffSep#' .. seperators[1]
				if git_added ~= 0 then
					diff_status = diff_status .. '%#WinBarDiffAdd#'
					diff_status = diff_status .. addSign
					diff_status = diff_status .. vim.fn.string(git_dict['added'])
				end
				if git_changed ~= 0 then
					diff_status = diff_status .. '%#WinBarDiffChange# '
					diff_status = diff_status .. changeSign
					diff_status = diff_status .. vim.fn.string(git_dict['changed'])
				end
				if git_removed ~= 0 then
					diff_status = diff_status .. '%#WinBarDiffDelete# '
					diff_status = diff_status .. removeSign
					diff_status = diff_status .. vim.fn.string(git_dict['removed'])
				end
				-- diff_status = diff_status .. '%#WinBarDiffSep#' .. seperators[2]
			end
		end
	end
	return diff_status
end

function MyWinBar()
	local winNum = WinBarNumber()
	local winGit = WinBarGitStatus()
	local winFile = WinBarFile()

	local winbar = ' ' .. winNum
	winbar = winbar .. winGit
	winbar = winbar .. ' ' .. winFile

	return winbar
end

function WinBarNumber()
	local seperators = { '', '' }
	local sepHL = '%#WinBarWinNumEnd#'
	local hl = '%#WinBarWinNum#'
	local winNumber = vim.fn.tabpagewinnr(vim.fn.tabpagenr())
	return sepHL .. seperators[1] .. hl .. winNumber .. sepHL .. seperators[2] .. '%*'
end

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed
		}
	end
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

local hide_in_width = function()
  return vim.o.columns > 80
end

local hl_str = function(str, hl)
  return "%#" .. hl .. "#" .. str .. "%*"
end

local winbar = {
	lualine_a = {
		{
			"%{%v:lua.WinBarNumber()%}",
			padding = { left = 0, right = 1 }, separator = { left = '', right = '' },
			color = 'lualine_b_diagnostics'
		},
	},
	lualine_b = {
		{
			'diff',
			source = diff_source,
			separator = { left = '', right = '' },
			padding = { left = 0, right = 0 },
		},
		--[[ {
				"%{%v:lua.WinBarGitStatus()%}",
				padding = { left = 0, right = 0 },
				separator = { left = '', right = '' },
			}, ]]
		{
			'diagnostics',
			sources = { 'nvim_diagnostic' },
			symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
			padding = { left = 1, right = 0 },
			-- separator = { right = '' },
			separator = { left = '', right = '' },
			update_in_insert = true,
		},
	},
	lualine_c = {
		{
			"%{%v:lua.WinBarFile()%}",
			color = 'lualine_b_diagnostics'
		},
		{
			"%*",
			padding = { left = 0, right = 0 },
			separator = { left = '', right = '' },
		},
	},
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
			"Trouble",
			"lir",
			"Outline",
			"spectre_panel",
			"toggleterm",
			"DressingSelect",
			"TelescopePrompt",
			"lspinfo",
			"lsp-installer",
			"",
		}

		if contains(ui_filetypes, buf_ft) then
			if M.language_servers == nil then
				return ""
			else
				return M.language_servers
			end
		end

		local clients = vim.lsp.get_active_clients()
		local client_names = {}

		-- add client
		for _, client in pairs(clients) do
			if client.name ~= "null-ls" then
				table.insert(client_names, client.name)
			end
		end

		-- add formatter
		local s = require "null-ls.sources"
		local available_sources = s.get_available(buf_ft)
		local registered = {}
		for _, source in ipairs(available_sources) do
			for method in pairs(source.methods) do
				registered[method] = registered[method] or {}
				table.insert(registered[method], source.name)
			end
		end

		local formatter = registered["NULL_LS_FORMATTING"]
		local linter = registered["NULL_LS_DIAGNOSTICS"]
		if formatter ~= nil then
			vim.list_extend(client_names, formatter)
		end
		if linter ~= nil then
			vim.list_extend(client_names, linter)
		end

		-- join client names with commas
		local client_names_str = table.concat(client_names, ", ")

		-- check client_names_str if empty
		local language_servers = ""
		local client_names_str_len = #client_names_str
		if client_names_str_len ~= 0 then
			-- TODO: alphabetise client names so they always appear same order <Effie2096 havealittlefaith2096@gmail.com> 
			language_servers = " " .. client_names_str .. " "
		end

		if client_names_str_len == 0 then
			return ""
		else
			M.language_servers = language_servers
			return language_servers:gsub(", anonymous source", "")
		end
	end,
	padding = 0,
}

local spaces = {
  function()
    local buf_ft = vim.bo.filetype

    local ui_filetypes = {
      "help",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "lir",
      "Outline",
      "spectre_panel",
      "DressingSelect",
      "",
    }
    local space = ""

    if contains(ui_filetypes, buf_ft) then
      space = " "
    end

    local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")

    if shiftwidth == nil then
      return ""
    end

    -- TODO: update codicons and use their indent
    return " " .. shiftwidth .. space
  end,
  padding = 1,
  -- separator = "%#SLSeparator#" .. " │" .. "%*",
  -- cond = hide_in_width_100,
}

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'catppuccin',
		-- component_separators = { left = '', right = ''},
		-- section_separators = { left = '', right = ''},
		component_separators = '|',
		section_separators = { left = '', right = '' },
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 120,
			tabline = 240,
			winbar = 120
		}
	},
	sections = {
		lualine_a = {
			{
				'b:gitsigns_head',
				color = 'lualine_a_normal',
				icon = { '', align = 'left' },
				-- color = { fg = colors.blue }
			},
			--[[ {
				'mode',
				fmt = function(str) return str:sub(1,1) end
			}, ]]
		},
		lualine_b = {
			{
				'diagnostics',
				-- sources = { 'nvim_workspace_diagnostic' },
				sources = { 'nvim_workspace_diagnostic' },
				symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
				update_in_insert = true,
			},

		},
		lualine_c = {
			language_server,
		},
		lualine_x = {
			{
				"%11(%l/%L:%c%) " --'%l/%L:%c'
			},
		},
		lualine_y = { encoding, fileformat, spaces, indent, trailing_space },
		lualine_z = trans_flag,
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	winbar = winbar,
	inactive_winbar = winbar,
	tabline = {
		lualine_a = {
			{
				"%{%v:lua.WinBarRoot()%}",
				color = 'lualine_a_normal',
				icon = { '', align = 'left', color = { fg = colors.yellow } },
				padding = { left = 1, right = 0 },
				separator = { right = '' },
				-- color = { fg = colors.pink }
			},
			{
				"%{%v:lua.WinBarDir()%}",
				color = 'lualine_a_normal',
				padding = { left = 1, right = 0 },
				separator = { right = '' },
				-- color = { fg = colors.pink }
			},
		},
		lualine_z = {
			{
				'MyTabLine',
				max_length = vim.o.columns * 3 / 5,
				padding = { left = 0, right = 0 },
				cond = function()
					return vim.fn.tabpagenr('$') >= 2
				end,
			}
		},
	},
	extensions = {
		'fugitive',
		'nvim-dap-ui',
		'quickfix'
	},
}
