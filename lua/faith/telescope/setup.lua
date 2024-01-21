local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

telescope.setup({
	defaults = {
		--[[ mappings = {
			i = {
				["<M-p>"] = require("telescope.actions.layout").toggle_preview,
			},
		}, ]]
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
		},
		["ui-select"] = {
			require("telescope.themes").get_cursor(require("faith.telescope.layouts").layout_configs.default_cursor),
		},
	},
})

pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "file_browser")
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "refactoring")
pcall(require("telescope").load_extension, "harpoon")
pcall(require("telescope").load_extension, "git_worktree")
pcall(require("telescope").load_extension, "scdoc")
