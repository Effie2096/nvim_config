vim.pack.add(
	{ { src = "https://github.com/nmac427/guess-indent.nvim" } },
	{ load = false }
)

local function config()
	require("guess-indent").setup({
		on_tab_options = {
			["expandtab"] = false,
		},
		on_space_options = {
			["expandtab"] = true,
			["tabstop"] = "detected",
			["softtabstop"] = "detected",
			["shiftwidth"] = "detected",
		},
	})
end

local function load()
	if package.loaded["guess-indent"] then
		return
	end

	vim.cmd.packadd("guess-indent.nvim")

	config()
end

vim.api.nvim_create_autocmd("BufEnter", {
	once = true,
	callback = load,
})
