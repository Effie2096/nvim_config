vim.opt.statusline = " "

local hl_string = function(str, hl)
	return ("%%#%s#%s%%*"):format(hl, str)
end

function Status_Folder_Icon()
	local folder = vim.fn.fnamemodify( vim.fn.getcwd(), ":t")
	local icon, hl, _ = MiniIcons.get("directory", folder)
		return ("%s %s"):format(hl_string(icon, hl), folder)
end
vim.opt.statusline:append("%{%v:lua.Status_Folder_Icon()%}")

vim.opt.statusline:append("%=")

vim.api.nvim_set_hl(0, "Trans_Blue", {fg = "#5bcffa"})
vim.api.nvim_set_hl(0, "Trans_Pink", {fg = "#ffb5cd"})
vim.api.nvim_set_hl(0, "Trans_White", {fg = "#ffffff"})

function Trans_Flag()
	return string.format(
		"%s%s%s%s%s",
		hl_string("█", "Trans_Blue"),
		hl_string("█", "Trans_Pink"),
		hl_string("█", "Trans_White"),
		hl_string("█", "Trans_Pink"),
		hl_string("█", "Trans_Blue")
	)
end
vim.opt.statusline:append("%{%v:lua.Trans_Flag()%}")


vim.opt.winbar = " "

vim.opt.winbar:append("%(%{%v:lua.vim.api.nvim_win_get_number(0)%}%)")

vim.opt.winbar:append("%=")

function Status_File_Icon()
	local icon, hl, is_default = MiniIcons.get("file", vim.api.nvim_buf_get_name(0))
	if not is_default then
		return hl_string(icon, hl)
	end
	return ""
end
vim.opt.winbar:append("%{%v:lua.Status_File_Icon()%}")
vim.opt.winbar:append(" %t ")
vim.opt.winbar:append("%m%r%h%w")
vim.opt.winbar:append("%=")


vim.opt.winbar:append("%l/%L:%c")
