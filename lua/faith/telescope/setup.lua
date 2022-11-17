local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
	return
end

-- local opts = { noremap = true, silent = true }
-- vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, opts)
-- vim.keymap.set('n', '<leader>fl', require('telescope.builtin').live_grep, opts)
-- vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, opts)
-- -- vim.keymap.set('n', '<leader>fh', "<CMD> lua require('telescope.builtin').help_tags(require('faith.telescope.layouts').layout_configs.default_flex)<CR>", opts)
-- vim.keymap.set('n', '<leader>fe', "<CMD> lua require('telescope._extensions.file_browser').exports.file_browser(require('faith.telescope.layouts').layout_configs.default_flex)<CR>", opts)
-- vim.keymap.set('n', '<leader>fp', require('telescope.builtin').current_buffer_fuzzy_find, opts)
-- vim.keymap.set('n', '<leader>fs', require('telescope.builtin').treesitter, opts)
-- vim.keymap.set('n', '<leader>fw', "<CMD> lua require('telescope._extensions.workspaces').exports.workspaces(require('faith.telescope.layouts').layout_configs.centered_compact)<CR>", opts)
-- -- vim.keymap.set('n', '<leader>ft', '<cmd> lua require("telescope._extensions.todo-comments").exports.todo({ layout_strategy = "bottom_pane", borderchars = { { "─", " ", " ", " ", "─", "─", "┘", "└" }, prompt = { "─", " ", "─", " ", "─", "─", "│", "│" }, results = { "─", " ", " ", " ", " ", " ", " ", " " }, preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, }, results_title = false, sorting_strategy = "ascending", layout_config = { prompt_position = "top", height = 15, }, })<CR>', opts)
-- vim.keymap.set('n', '<leader>ft', "<cmd> lua require('telescope._extensions.todo-comments').exports.todo( vim.tbl_deep_extend('force', require('faith.telescope.layouts').layout_configs.default_vert, { prompt_title = 'TODO Comments', preview_title = false }))<CR>", opts)
-- vim.keymap.set( "v", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", { noremap = true })

-- local layouts = require('faith.telescope.layouts').layout_configs

telescope.setup {
	-- defaults = layouts.defaults,
	-- pickers = {
	-- 	--[[ find_files = {
	-- 		find_command = { "fdfind", "--strip-cwd-prefix", "--type", "f" }
	-- 	}, ]]
	-- },
	defaults = {
		mappings = {
			i = {
				['<M-p>'] = require('telescope.actions.layout').toggle_preview
			},
		},
	},
	extensions = {
		fzy_native = {
      override_generic_sorter = true,
      override_file_sorter = true,
    },
		["ui-select"] = {
			require("telescope.themes").get_cursor {}
		}
	}
}

require("telescope").load_extension("ui-select")
require("telescope").load_extension("file_browser")
require('telescope').load_extension('fzf')
require('telescope').load_extension('workspaces')
-- require("telescope").load_extension("refactoring")
