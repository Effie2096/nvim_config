local apply_theme_overrides =
	require("faith.plugins.color.overrides").apply_theme_overrides

vim.api.nvim_create_augroup("kanagawa_auto_compile", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "kanagawa.lua" },
	callback = function()
		local path = vim.fn.stdpath("config")
		vim.cmd(
			"luafile "
				.. vim.fn.glob(path .. "/lua/faith/plugins/color/themes/kanagawa.lua")
		)
		vim.cmd.KanagawaCompile()
		return true
	end,
	group = "kanagawa_auto_compile",
})

return {
	"rebelot/kanagawa.nvim",
	opts = {
		compile = true,
	},
	init = function()
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = {
				"kanagawa-wave",
				"kanagawa-dragon",
				"kanagawa-lotus",
			},
			callback = function(args)
				apply_theme_overrides("kanagawa", args.match:gsub("kanagawa%-", ""))
			end,
		})
	end,
}
