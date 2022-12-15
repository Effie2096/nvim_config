local status_ok, color_picker = pcall(require, 'color-picker')
if not status_ok then
	return
end

local fk = require('faith.keymap')
local nnoremap = fk.nnoremap
local inoremap = fk.inoremap

local opts = { noremap = true, silent = true }
nnoremap("<Leader>cp", "<cmd>PickColor<cr>", opts)
inoremap("<M-c>", "<cmd>PickColorInsert<cr>", opts)

color_picker.setup()
