vim.opt.list = true

-- vim.opt.listchars:append("eol = '﬋', tab = '»»', space = '•'")
--▸▸﬋

empty_chars = "eol: ,extends: ,nbsp: ,precedes: ,space: ,tab:  ,trail:×"
listchars = "eol:﬋,extends:›,nbsp:␣,precedes:‹,space:•,tab:▸▸,trail:×"

-- empty_chars = { eol = ' ', tab = '  ', trail = '×', space = ' ', extends = ' ', precedes = ' ', nbsp = ' ' }
-- listchars = { eol = '﬋', tab = '▸▸', trail = '×', space = '•', extends = '›', precedes = '‹', nbsp = '␣' }

local cycle_list = function ()
	if vim.opt.listchars._value == empty_chars then
		vim.opt.listchars = listchars
		print("List characters set.")
	else
		vim.opt.listchars = empty_chars
		print("List characters cleared.")
	end
end

vim.opt.listchars = empty_chars

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>ll", cycle_list, opts)
