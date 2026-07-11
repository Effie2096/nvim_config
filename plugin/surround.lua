vim.pack.add(
	{
		{
			src = "https://github.com/kylechui/nvim-surround",
			version = vim.version.range("4.x"),
		},
	},
	{ load = false }
)

local function config()
	require("nvim-surround").setup({
		hightlight = {
			duration = 40,
		},
	})
end

local function load()
	if package.loaded["nvim-surround"] then
		return
	end

	vim.cmd.packadd("nvim-surround")

	config()
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	once = true,
	callback = load,
})
