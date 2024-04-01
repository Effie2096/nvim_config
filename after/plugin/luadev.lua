local has_luadev, luadev = pcall(require, "luadev")
if not has_luadev then
	return
end

local luadev_group = vim.api.nvim_create_augroup("luadev_maps", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = luadev_group,
	pattern = { "*.lua" },
	callback = function(args)
		local opts = { silent = true, noremap = true, buffer = args.buf }
		vim.keymap.set({ "n" }, "<M-e>", "<CMD>Luadev<CR><Plug>(Luadev-RunLine)", opts)
		vim.keymap.set({ "n", "v" }, "<C-e>", "<CMD>Luadev<CR><Plug>(Luadev-Run)", opts)
	end,
})
