M = {}

local lualine_status_ok, lualine = pcall(require, 'lualine')
if not lualine_status_ok then
	return
end

local icons = require('faith.icons')

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
			return 'mix@' .. mixed_same_line
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
	padding = { left = 1, right = 1 },
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
			---@diagnostic disable-next-line: missing-parameter
			vim.list_extend(client_names, formatter)
		end
		if linter ~= nil then
			---@diagnostic disable-next-line: missing-parameter
			vim.list_extend(client_names, linter)
		end

		table.sort(client_names)

		--remove duplicate entries
		--only want to know which clients are active. not how many times they've attached
		local hash = {}
		local res = {}

		for _, v in ipairs(client_names) do
			if (not hash[v]) then
				res[#res+1] = v
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
			language_servers =
				" "
				.. icons.seperators.rounded_bracket.left
				.. client_names_str
				.. icons.seperators.rounded_bracket.right
				.. " "
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

		return icons.ui.Tab .. shiftwidth .. space
	end,
	padding = 1,
	-- separator = "%#SLSeparator#" .. " │" .. "%*",
	-- cond = hide_in_width_100,
}

local git = {
	'b:gitsigns_head',
	color = 'lualine_a_normal',
	icon = { '', align = 'left' },
}

--[[ local mode = {
	'mode',
	fmt = function(str) return str:sub(1,1) end
} ]]

local workspace_diagnostics = {
	'diagnostics',
	sources = { 'nvim_workspace_diagnostic' },
	symbols = icons.diagnostic,
	update_in_insert = true,
}

local location = {
	"%11(%l/%L:%c%) " --'%l/%L:%c'
}

lualine.setup {
	options = {
		icons_enabled = true,
		theme = 'catppuccin',
		-- component_separators = { left = '', right = ''},
		-- section_separators = { left = '', right = ''},
		component_separators = { left = icons.separators.straight.left, right = icons.separators.straight.right },
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
		lualine_a = { git },
		lualine_b = { workspace_diagnostics },
		lualine_c = { language_server, },
		lualine_x = { location },
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
	--[[ winbar = winbar,
	inactive_winbar = winbar, ]]
	tabline = {},
	extensions = {
		'fugitive',
		'nvim-dap-ui',
		'quickfix'
	},
}
