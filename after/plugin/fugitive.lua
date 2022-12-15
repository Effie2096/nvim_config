local fk = require('faith.keymap')
local nnoremap = fk.nnoremap

local options = { noremap = true, silent = true}

nnoremap("<leader>gl", "<cmd>diffget //3<CR>", options)
nnoremap("<leader>gh", "<cmd>diffget //2<CR>", options)
nnoremap("<leader>gs", "<cmd>G<CR>", options)
