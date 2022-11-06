vim.opt.list = true

local empty_chars = "eol: ,extends: ,nbsp: ,precedes: ,space: ,tab:  ,trail:×"
local listchars = "eol:﬋,extends:›,nbsp:␣,precedes:‹,space:•,tab:▸▸,trail:×"

local cycle_list = function ()
	if vim.opt.listchars._value == empty_chars then
		vim.opt.listchars = listchars
		vim.notify("List characters set.")
	else
		vim.opt.listchars = empty_chars
		vim.notify("List characters cleared.")
	end
end

vim.opt.listchars = empty_chars

vim.api.nvim_create_user_command("ToggleListChars", cycle_list, {})
