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

pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "file_browser")
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'workspaces')
-- require("telescope").load_extension("refactoring")
