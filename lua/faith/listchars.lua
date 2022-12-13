vim.opt.list = true

local icons = require('faith.icons')

local empty_chars = "eol: ,extends: ,nbsp: ,precedes: ,space: ,tab:  ,trail:" .. icons.characters.trail
local listchars =
	[[eol:]] .. icons.characters.eol
	.. [[,extends:]] .. icons.characters.extends
	.. [[,nbsp:]] .. icons.characters.nbsp
	.. [[,precedes:]] .. icons.characters.precedes
	.. [[,space:]] .. icons.characters.space
	.. [[,tab:]] .. icons.characters.tab
	.. [[,trail:]] .. icons.characters.trail

local cycle_list = function ()
	---@diagnostic disable-next-line: undefined-field
	if vim.opt.listchars._value == empty_chars then
		vim.opt.listchars = listchars
		vim.cmd('IndentBlanklineDisable')
		vim.notify("List characters set.")
	else
		vim.opt.listchars = empty_chars
		vim.cmd('IndentBlanklineEnable')
		vim.notify("List characters cleared.")
	end
end

vim.opt.listchars = empty_chars

vim.api.nvim_create_user_command("ToggleListChars", cycle_list, {})
