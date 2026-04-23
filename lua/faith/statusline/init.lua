local histr = require("faith.statusline.utils").histr
vim.opt.statusline = " "

vim.opt.statusline:append("%{%v:lua.require('faith.statusline.components.session')()%} ")

vim.opt.statusline:append("%{fnamemodify(getcwd(), ':t')}")

vim.opt.statusline:append("%=")

vim.opt.statusline:append(" %{%v:lua.require('faith.statusline.components.harpoon')()%}")

vim.opt.statusline:append("%=")

function Trans_Flag()
	return string.format(
		"%s%s%s%s%s",
		histr("█", "Trans_Blue"),
		histr("█", "Trans_Pink"),
		histr("█", "Trans_White"),
		histr("█", "Trans_Pink"),
		histr("█", "Trans_Blue")
	)
end
vim.opt.statusline:append("%{%v:lua.Trans_Flag()%}")


vim.opt.winbar = " "

vim.opt.winbar:append("%#Accent#%(%{%v:lua.vim.api.nvim_win_get_number(0)%}%)%*")

vim.opt.winbar:append("%=")

function Status_File_Icon()
	local icon, hl, is_default = require("mini.icons").get("file", vim.api.nvim_buf_get_name(0))
	if not is_default then
		return histr(icon, hl)
	end
	return ""
end
vim.opt.winbar:append("%{%v:lua.Status_File_Icon()%}")
vim.opt.winbar:append(" %t ")
vim.opt.winbar:append("%m%r%h%w")
vim.opt.winbar:append("%=")


vim.opt.winbar:append(" %l/%L:%c")
