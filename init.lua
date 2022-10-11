require("faith")

-- vim.cmd[[source ~/.config/nvim/treesitter-folds.vim]]
vim.cmd [[source ~/.config/nvim/jsonc.vim]]
vim.cmd [[source ~/.config/nvim/after/tabline.vim]]

-- LSP
require("faith.lsp")


vim.notify = require("notify")

require("faith.catppuccin")

--[[ vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function()
		vim.cmd("Catppuccin " .. (vim.v.option_new == "light" and "latte" or "mocha"))
	end,
}) ]]
--[[ function SetColorTheme()
	local timer = vim.loop.new_timer()
	timer:start(0, 600, vim.schedule_wrap(function()
		local hour = tonumber(os.date('%H'))
		-- You can change color scheme here.
		local bg = (hour > 8 and hour < 19) and 'light' or 'dark'
		if vim.o.bg ~= bg then vim.o.bg = bg end
	end))
end ]]
