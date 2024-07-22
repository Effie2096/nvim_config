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
