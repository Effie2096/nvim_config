vim.pack.add(
	{ { src = "https://github.com/esmuellert/codediff.nvim" } },
	{ load = false }
)

local function config()
	vim.api.nvim_create_autocmd("User", {
		pattern = "CodeDiffOpen",
		callback = function()
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				vim.wo[win].cursorline = false
			end
		end,
	})
end

local function load()
	if package.loaded.codediff then
		return
	end

	vim.cmd.packadd("codediff.nvim")

	config()
end

vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = load,
})
