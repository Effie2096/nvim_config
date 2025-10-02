if not vim.g.neovide then
	return
end

vim.o.guifont = "Lilex_Nerd_Font,FiraCode_Nerd_Font:h10"

vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_size = 0.2
-- vim.g.neovide_fullscreen = true
vim.opt.linespace = -3
-- vim.g.neovide_transparency = 0.9

vim.keymap.set({ "n" }, "<F11>", function()
	if vim.g.neovide_fullscreen == false then
		vim.g.neovide_fullscreen = true
	else
		vim.g.neovide_fullscreen = false
	end
end, { silent = true })

local resize = function(increase)
	local font = vim.o.guifont
	local font_size_flag = font:match(":h%d+")
	local font_size = tonumber(font_size_flag:sub(3, -1))
	font_size = increase and (font_size + 1) or (font_size - 1)
	local font_string =
		font:gsub(font_size_flag, string.format(":h%d", font_size))
	vim.notify("Font size: " .. font_size)
	vim.cmd([[set guifont=]] .. font_string)
end
vim.keymap.set({ "n", "i" }, "<C-->", function()
	resize(false)
end, { silent = true })

vim.keymap.set({ "n", "i" }, "<C-=>", function()
	resize(true)
end, { silent = true })

vim.cmd.cd(os.getenv("HOME") .. "/Documents")
