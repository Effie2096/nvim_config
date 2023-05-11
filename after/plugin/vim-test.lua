local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local desc = fk.desc

local opts = { silent = true, noremap = true }
nnoremap("<leader>t", "<Cmd>TestNearest<CR>", desc(opts, "[t]est nearest."))
nnoremap("<leader>T", "<Cmd>TestFile<CR>", desc(opts, "[T]est file."))
nnoremap("<leader>ta", "<Cmd>TestSuite<CR>", desc(opts, "[t]est [a]ll"))
nnoremap("<leader>tl", "<Cmd>TestLast<CR>", desc(opts, "[t]est [l]ast."))
nnoremap("<leader>tg", "<Cmd>TestVisit<CR>", desc(opts, "[t]est [g]o: Go to last file tests were ran."))
