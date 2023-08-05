local has_harpoon, harpoon = pcall(require, "harpoon")
if not has_harpoon then
	return
end

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap

local opts = { noremap = true, silent = true }

nnoremap("<leader>ma", require("harpoon.mark").add_file, opts)

nnoremap("<C-h>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", opts)
nnoremap("<C-j>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", opts)
nnoremap("<C-k>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", opts)
nnoremap("<C-l>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", opts)
nnoremap("<Left>", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", opts)
nnoremap("<Down>", "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", opts)
nnoremap("<Up>", "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", opts)
nnoremap("<Right>", "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", opts)

harpoon.setup({
	tabline = false,
	-- tabline_prefix = " " .. icons.ui.BookMark .. " ",
	-- tabline_suffix = "	  ",
})
