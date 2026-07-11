vim.pack.add(
	{ { src = "https://github.com/folke/todo-comments.nvim" } },
	{ load = false }
)

local function config()
	require("todo-comments").setup({
		signs = true,
		sign_priority = 15,
	})
end

local function load()
	if package.loaded["todo-comments"] then
		return
	end
	vim.cmd.packadd("todo-comments.nvim")

	config()
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = load,
})
