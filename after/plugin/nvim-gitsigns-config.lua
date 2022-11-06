local status_ok, gitsign = pcall(require, 'gitsigns')
if not status_ok then
	return
end


gitsign.setup {
	signs                        = {
		add          = { hl = 'GitSignsAdd', text = '┃', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
		change       = { hl = 'GitSignsChange', text = '┃', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
		delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
		topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
		changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
},
	signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir                 = {
		interval = 1000,
		follow_files = true
},
	attach_to_untracked          = true,
	current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts      = {
	virt_text = false,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary> ',
	sign_priority                = 6,
	update_debounce              = 100,
	status_formatter             = nil, -- Use default
	max_file_length              = 40000,
	preview_config               = {
		-- Options passed to nvim_open_win
		border = 'single',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},
	yadm                         = {
		enable = false
	},
}

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>gq", function ()
	vim.api.nvim_cmd({ cmd = "Gitsigns", args = { "setqflist" }}, {})
end, opts)
vim.keymap.set("n", "<Leader>gp", function () vim.api.nvim_cmd({ cmd = "Gitsigns", args = { "preview_hunk" }}, {}) end, opts)
vim.keymap.set("n", "<leader>gj", "<cmd>Gitsigns next_hunk<CR><CR>", opts)
vim.keymap.set("n", "<leader>gk", "<cmd>Gitsigns prev_hunk<CR><CR>", opts)

vim.api.nvim_create_user_command('GitSignsToggleAll',
	function()
		gitsign.toggle_numhl()
		gitsign.toggle_linehl()
		gitsign.toggle_word_diff()
		-- gitsign.toggle_deleted()
		gitsign.toggle_current_line_blame()
	end,
	{}
)
