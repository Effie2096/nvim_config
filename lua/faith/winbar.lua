local M = {}

M.winbar_filetype_exclude = {
  "help",
  "startify",
  "dashboard",
  "packer",
  "neogitstatus",
  "NvimTree",
  "Trouble",
  "alpha",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",
  "DressingSelect",
  "Jaq",
  "harpoon",
  "dapui_scopes",
  "dapui_breakpoints",
  "dapui_stacks",
  "dapui_watches",
  "dap-repl",
  "dap-terminal",
  "dapui_console",
  "lab",
  "Markdown",
	""
}

local excludes = function()
  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

local get_win_number = function()
	local seperators = { '', '' }
	local sepHL = '%#WinBarWinNumEnd#'
	local hl = '%#WinBarWinNum#'
	local winNumber = vim.fn.tabpagewinnr(vim.fn.tabpagenr())
	return sepHL .. seperators[1] .. hl .. winNumber .. sepHL .. seperators[2] .. '%*'
end

-- local get_navic = function()
-- 	local status_navic_ok, navic = pcall(require, "nvim-navic")
-- 	if not status_navic_ok then
-- 		return ""
-- 	end
--
-- 	local status_location_ok, location = pcall(navic.get_location(), {})
-- 	if not status_location_ok then
-- 		return ""
-- 	end
--
-- 	if not navic.is_available() or location == "error" then
-- 		return ""
-- 	end
--
-- 	if (location ~= "") or (location ~= nil) then
-- 		local data = vim.fn.substitute(location, "(.*)", "", "")
-- 		return " %#WinBarFileSep# " .. data .. "%#WinBarNavic# %#WinBarNavicEnd#"
-- 	else
-- 		return ''
-- 	end
-- end

--[[ local get_file_type_icon = function()
	---@diagnostic disable-next-line: missing-parameter
	local file = vim.fn.expand('%')
	if ( package.loaded['nvim-web-devicons'] ) and (file ~= '') then
		---@diagnostic disable-next-line: missing-parameter
		local icon, color = require'nvim-web-devicons'.get_icon(file, vim.fn.expand('%:e'), { default = true })
		return { icon, color }
	else
		return { '', '' }
	end
end

local get_file = function()
	---@diagnostic disable-next-line: missing-parameter
	local file = vim.fn.expand('%:t:r')
	local f = require("faith.functions")
	local winbar_file = ""

	if not f.isempty(file) then
		local icon = get_file_type_icon()
		local file_icon = icon[1]
		local file_icon_hl_name = icon[2]
		if f.isempty(file_icon) then
			file_icon = ""
			file_icon_hl_name = ""
		end

		winbar_file = winbar_file .. "%#WinBarFileEnd#%#WinBarFile#"
		-- string = string .. WinBarDir()
		winbar_file = winbar_file .. "%#Winbar" .. file_icon_hl_name .. "#" .. file_icon .. "%#WinBarFile# " .. file
		if get_navic() ~= "" then
			winbar_file = winbar_file .. get_navic()
		else
			winbar_file = winbar_file.. " %#WinBarFileEnd#%*"
		end
	end
	return winbar_file
end ]]


M.get_winbar = function ()
	if excludes() then
		return
	end

	-- local f = require("faith.functions")
	local number = get_win_number()
	-- local file = get_file()

	local winbar_contents = number
	-- if not f.isempty(winbar_contents) and f.get_buf_option "mod" then
	-- 	local mod = "modified"
	-- end

	local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", winbar_contents, { scope = "local" })
	if not status_ok then
		return
	end
end

M.create_winbar = function ()
	vim.api.nvim_create_augroup("_winbar", {})
	vim.api.nvim_create_autocmd(
		{ "CursorMoved", "CursorHold", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost", "TabClosed" },
		{
			group = "_winbar",
			callback = function ()
				-- local status_ok, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
    --       if not status_ok then
            require("faith.winbar").get_winbar()
          -- end
			end,
		}
	)
end

M.create_winbar()

-- function WinBarDir()
-- 	local seperator = '  '
-- 	---@diagnostic disable-next-line: missing-parameter
-- 	local path_from_root = vim.fn.expand('%:h', false)
-- 	local folders = vim.fn.split(path_from_root, '/')
-- 	local path_breadcrumbs = ''
--
-- 	for _, value in pairs(folders) do
-- 		if value == '.' then goto continue end
-- 		path_breadcrumbs = path_breadcrumbs .. value
-- 		path_breadcrumbs = path_breadcrumbs .. seperator
-- 		::continue::
-- 	end
--
-- 	return path_breadcrumbs
-- end
--
-- function WinBarGitStatus()
-- 	local git_dict = vim.api.nvim_eval("get(b:,'gitsigns_status_dict', '')")
-- 	local seperators = { '', '' }
-- 	local addSign = "+"
-- 	local changeSign = "~"
-- 	local removeSign = "-"
--
-- 	local diff_status = ""
--
-- 	if git_dict ~= "" then
-- 		local git_added = git_dict['added']
-- 		local git_changed = git_dict['changed']
-- 		local git_removed = git_dict['removed']
--
-- 		if (git_added ~= nil) or (git_changed ~= nil) or (git_removed ~= nil) then
-- 			if (git_added ~= 0) or (git_changed ~= 0) or (git_removed ~= 0) then
--
-- 				diff_status = diff_status .. ' %#WinBarDiffSep#' .. seperators[1]
-- 				if git_added ~= 0 then
-- 					diff_status = diff_status .. '%#WinBarDiffAdd#'
-- 					diff_status = diff_status .. addSign
-- 					diff_status = diff_status .. vim.fn.string(git_dict['added'])
-- 				end
-- 				if git_changed ~= 0 then
-- 					diff_status = diff_status .. '%#WinBarDiffChange# '
-- 					diff_status = diff_status .. changeSign
-- 					diff_status = diff_status .. vim.fn.string(git_dict['changed'])
-- 				end
-- 				if git_removed ~= 0 then
-- 					diff_status = diff_status .. '%#WinBarDiffDelete# '
-- 					diff_status = diff_status .. removeSign
-- 					diff_status = diff_status .. vim.fn.string(git_dict['removed'])
-- 				end
-- 				diff_status = diff_status .. '%#WinBarDiffSep#' .. seperators[2]
-- 			end
-- 		end
-- 	end
-- 	return diff_status
-- end
--
-- function MyWinBar()
-- 	local winNum = WinBarNumber()
-- 	local winGit = WinBarGitStatus()
-- 	local winFile = WinBarFile()
--
-- 	local winbar = ' ' .. winNum
-- 	winbar = winbar .. winGit
-- 	winbar = winbar .. ' ' .. winFile
--
-- 	return winbar
-- end

-- vim.opt.winbar = "%{%v:lua.MyWinBar()%}"
return M
