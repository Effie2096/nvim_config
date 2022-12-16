local status_ok, zen_mode = pcall(require, 'zen-mode')
if not status_ok then
	return
end

zen_mode.setup {
	window = {
		backdrop = 0,
		width = 80,
		height = 1,
		options = {
			number = true,
			relativenumber = true,
			foldcolumn = "0",
			winbar = "",
			signcolumn = "no",
		},
	},
	plugins = {
		options = {
			enabled = true,
			ruler = false,
			showcmd = false,
		},
		gitsigns = { enabled = false },
		twighlight = { enabled = false },
		tmux = { enabled = false },
		kitty = {
			enabled = false,
			font = "+6",
		},
	},
}

vim.api.nvim_set_keymap('n', '<leader>z', '<cmd>ZenMode<CR>', { silent = true })
