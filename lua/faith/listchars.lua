vim.opt.list = true

local icons = require('faith.icons')
local fk = require('faith.keymap')
local nnoremap = fk.nnoremap
local desc = fk.desc

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
	if vim.opt_local.listchars._value == empty_chars or vim.opt_local.listchars._value == "" then
		vim.opt_local.listchars = listchars
		if package.loaded.indent_blankline ~= nil then
			vim.cmd('IndentBlanklineDisable')
		end
		vim.notify("List characters set.")
	else
		vim.opt_local.listchars = empty_chars
		if package.loaded.indent_blankline ~= nil then
			vim.cmd('IndentBlanklineEnable')
		end
		vim.notify("List characters cleared.")
	end
end

vim.opt.listchars = empty_chars

local opts = { noremap = true, silent = true }
vim.api.nvim_create_user_command("ToggleListChars", cycle_list, {})
nnoremap("<leader>lc", "<cmd>ToggleListChars<CR>",
	desc(opts, "[l]ist [c]hars: Toggle showing listchar indicators."))
