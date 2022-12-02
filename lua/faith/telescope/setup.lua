local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
	return
end

telescope.setup {
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
