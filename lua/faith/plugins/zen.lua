return {
	{
		"folke/zen-mode.nvim",
		keys = {
			{
				"<leader>z",
				"<cmd>ZenMode<CR>",
			},
		},
		opts = {
			window = {
				backdrop = 1,
				width = 79,
				height = 1,
				options = {
					colorcolumn = "0",
					cursorline = false,
					foldcolumn = "0",
					statuscolumn = "",
					signcolumn = "no",
					relativenumber = false,
					number = false,
					winbar = "%=%{b:obsidian_status}%=",
					winhighlight = "NormalFloat:Normal,Normal:Normal,WinBar:Comment",
				},
			},
			plugins = {
				options = {
					enabled = true,
					ruler = false,
					showcmd = false,
					laststatus = 0, -- turn off the statusline in zen mode
				},
				gitsigns = { enabled = false },
				twilight = { enabled = false },
				todo = { enabled = true }, -- if set to "true", todo-comments.nvim highlights will be disabled
				tmux = { enabled = false }, -- disables the tmux statusline
				kitty = {
					enabled = false,
					font = "+4",
				},
				wezterm = {
					enabled = false, -- something about resizing breaks scrolling w/ <C-d> <C-u>
					font = "+2",
				},
				alacritty = {
					enabled = false,
					font = "14",
				},
				neovide = {
					enabled = true,
					-- Will multiply the current scale factor by this number
					scale = 1.2,
					-- disable the Neovide animations while in Zen mode
					disable_animations = {
						neovide_animation_length = 0,
						neovide_cursor_animate_command_line = false,
						neovide_scroll_animation_length = 0,
						neovide_position_animation_length = 0,
						neovide_cursor_animation_length = 0,
						neovide_cursor_vfx_mode = "",
					},
				},
			},
			on_open = function(_)
				vim.diagnostic.hide(nil, 0)
				-- vim.cmd.ScrollViewDisable()
			end,
			on_close = function()
				vim.diagnostic.show(nil, 0)
				-- vim.cmd.ScrollViewEnable()
			end,
		},

	},
}
