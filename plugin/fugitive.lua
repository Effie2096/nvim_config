vim.pack.add(
	{ { src = "https://github.com/tpope/vim-fugitive" } },
	{ load = false }
)

local function load()
	if vim.g.loaded_fugitive == 1 then
		return
	end

	vim.cmd.packadd("vim-fugitive")
end

vim.keymap.set(
	{ "n" },
	"<leader>gs",
	vim.cmd.G,
	{ desc = "[g]it [s]tatus: Open git status window." }
)

vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = load,
})
