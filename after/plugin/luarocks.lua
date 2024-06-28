local has_luarocks_nvim, luarocks_nvim = pcall(require, "luarocks-nvim")
if not has_luarocks_nvim then
	return
end

luarocks_nvim.setup({
	rocks = {
		"magick", -- for 3rd/image.nvim
	},
})
