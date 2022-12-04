local status_ok, color_picker = pcall(require, 'color-picker')
if not status_ok then
	return
end

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>cp", "<cmd>PickColor<cr>", opts)
vim.keymap.set("i", "<M-c>", "<cmd>PickColorInsert<cr>", opts)

color_picker.setup()
