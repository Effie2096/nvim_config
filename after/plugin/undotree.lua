if vim.fn.exists('g:loaded_undotree') == 0 then
	return
end

local fk = require('faith.keymap')
local nnoremap = fk.nnoremap
local desc = fk.desc

local opts = {silent=true}
nnoremap("<leader>u", vim.cmd.UndotreeToggle,
	desc(opts, "[u]ndo tree: Open undo history for current file."))

vim.g.undotree_WindowLayout = 3
vim.g.undotree_SplitWidth = 40
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_Helpline = 0
