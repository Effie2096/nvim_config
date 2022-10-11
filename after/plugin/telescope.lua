local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
	return
end

Square_borders = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
Round_borders = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
Blank_borders = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }

Square_borders_alt = {
	Square_borders,
	prompt = { "─", "│", " ", "│", '┌', '┐', "│", "│" },
	results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
	preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, opts)
vim.keymap.set('n', '<leader>fl', require('telescope.builtin').live_grep, opts)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, opts)
vim.keymap.set('n', '<leader>fe', require('telescope').extensions.file_browser.file_browser, opts)
vim.keymap.set('n', '<leader>fp', require('telescope.builtin').current_buffer_fuzzy_find, opts)
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').treesitter, opts)
vim.keymap.set('n', '<leader>fw', require('telescope').extensions.workspaces.workspaces, opts)
vim.keymap.set('n', '<leader>ft', '<cmd> lua require("telescope._extensions.todo-comments").exports.todo({ layout_strategy = "bottom_pane", borderchars = { { "─", " ", " ", " ", "─", "─", "┘", "└" }, prompt = { "─", " ", "─", " ", "─", "─", "│", "│" }, results = { "─", " ", " ", " ", " ", " ", " ", " " }, preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, }, results_title = false, sorting_strategy = "ascending", layout_config = { prompt_position = "top", height = 15, }, })<CR>', opts)
-- vim.keymap.set( "v", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", { noremap = true })

local file_ignore_patterns = {
	"node_modules/",
	".git/",
	"target/", "*.class", "*.jar"
}

telescope.setup {
	defaults = {
		border = true,
		prompt_prefix = '🔭',
		selection_caret = '',
		multi_icon = ' ',
		borderchars = Square_borders,
		file_ignore_patterns = file_ignore_patterns,
	},
	pickers = {
		hidden = true,
		buffers = {
			layout_strategy = 'center',
			previewer = false,
			results_title = '',
			borderchars = Square_borders_alt,
			layout_config = {
				anchor = "N",
				height = 0.3,
				width = 100
			}
		},
		current_buffer_fuzzy_find = {
			layout_strategy = 'bottom_pane',
			borderchars = {
				{ '─', ' ', ' ', ' ', '─', '─', '┘', '└' },
				prompt = { "─", " ", "─", " ", '─', '─', "│", "│" },
				results = { "─", " ", " ", " ", " ", " ", " ", " " },
				preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
			},
			results_title = false,
			sorting_strategy = 'ascending',
			layout_config = {
				prompt_position = 'top',
				height = 15,
			},
		},
		treesitter = {
			theme = "dropdown",
			borderchars = Square_borders_alt
		},
		find_files = {
			winblend = 0,
			-- prompt_title = 'Find Files',
			sorting_strategy = 'ascending',
			-- layout_strategy = 'horizontal',
			layout_config = {
				prompt_position = 'top',
				-- width = { padding = 0 },
				-- height = { padding = 0 },
			},
			no_ignore = true,
		},
		live_grep = {
			prompt_title = 'Grep',
			results_title = false,
			layout_strategy = 'horizontal',
			sorting_strategy = 'ascending',
			layout_config = {
				prompt_position = 'top',
				--[[ width = { padding = 0 },
				height = { padding = 0 }, ]]
			},
		},
	},
	extensions = {
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
