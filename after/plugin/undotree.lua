if vim.fn.exists('g:loaded_undotree') == 0 then
	return
end

local nnoremap = require('faith.keymap').nnoremap

nnoremap("<leader>u", vim.cmd.UndotreeToggle, { silent = true })

vim.g.undotree_WindowLayout = 3
vim.g.undotree_SplitWidth = 40
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_Helpline = 0
