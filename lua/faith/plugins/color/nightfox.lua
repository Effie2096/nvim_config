local nightfox = require("nightfox")

vim.api.nvim_create_augroup("nightfox_auto_compile", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "nightfox.lua" },
	callback = function()
		local path = vim.fn.stdpath("config")
		vim.cmd(
			"luafile " .. vim.fn.glob(path .. "/lua/faith/plugins/color/nightfox.lua")
		)
		vim.cmd.NightfoxCompile()
		return true
	end,
	group = "nightfox_auto_compile",
})

nightfox.setup({
	options = {
		-- Compiled file's destination location
		compile_path = vim.fn.stdpath("cache") .. "/nightfox",
		compile_file_suffix = "_compiled", -- Compiled file suffix
		transparent = false, -- Disable setting background
		terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
		dim_inactive = false, -- Non focused panes set to alternative background
		module_default = true, -- Default enable value for modules
		styles = { -- Style to be applied to different syntax groups
			comments = "italic", -- Value is any valid attr-list value `:help attr-list`
			conditionals = "NONE",
			constants = "NONE",
			functions = "NONE",
			keywords = "NONE",
			numbers = "NONE",
			operators = "NONE",
			strings = "italic",
			types = "NONE",
			variables = "NONE",
		},
	},
})
