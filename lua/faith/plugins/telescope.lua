local telescope = require("telescope")
local tm = require("faith.plugins.telescope-conf.mappings")


telescope.setup({
	defaults = require("faith.plugins.telescope-conf.layouts").layout_configs.default,
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
		},
		["ui-select"] = {
			require("telescope.themes").get_cursor(
				require("faith.plugins.telescope-conf.layouts").layout_configs.default_cursor
			),
		},
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

vim.iter(vim.deepcopy(tm.map_specs)):each(function(spec)
	tm.map_tele(spec.key, spec.func)
end)

require("faith.plugins.telescope-conf")
