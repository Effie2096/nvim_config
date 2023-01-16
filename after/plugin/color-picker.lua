local status_ok, color_picker = pcall(require, "color-picker")
if not status_ok then
	return
end

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local inoremap = fk.inoremap
local desc = fk.desc

local opts = { noremap = true, silent = true }
nnoremap("<Leader>cp", "<cmd>PickColor<cr>", desc(opts, "[c]olor [p]icker: Open color picker."))
inoremap("<M-c>", "<cmd>PickColorInsert<cr>", desc(opts, "[c]olor picker: Open color picker."))

color_picker.setup()
