local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local desc = fk.desc

local options = { noremap = true, silent = true }

nnoremap("<leader>gl", "<cmd>diffget //3<CR>", desc(options, "[g]et [right]: Use change from buffer to the right."))
nnoremap("<leader>gh", "<cmd>diffget //2<CR>", desc(options, "[g]et [left]: Use change from buffer to the left."))
nnoremap("<leader>gs", "<cmd>G<CR>", desc(options, "[g]it [s]tatus: Open git status window."))

vim.api.nvim_create_user_command("Review", function()
	-- vim.api.nvim_command([[tabdo Gvdiffsplit dev:%]])
	vim.api.nvim_command([[tabdo :execute 1 .. "wincmd w"]])
	vim.api.nvim_command([[tabdo :Gitsigns toggle_signs"]])
end, {})
