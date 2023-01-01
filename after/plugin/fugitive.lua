local fk = require('faith.keymap')
local nnoremap = fk.nnoremap
local desc = fk.desc

local options = { noremap = true, silent = true}

nnoremap("<leader>gl", "<cmd>diffget //3<CR>",
	desc(options, "[g]et [right]: Use change from buffer to the right."))
nnoremap("<leader>gh", "<cmd>diffget //2<CR>",
	desc(options, "[g]et [left]: Use change from buffer to the left."))
nnoremap("<leader>gs", "<cmd>G<CR>",
	desc(options, "[g]it [s]tatus: Open git status window."))
