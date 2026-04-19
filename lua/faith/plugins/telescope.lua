local tm = require("faith.plugins.telescope-conf.mappings")

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
		},
	},
	keys = vim.iter(vim.deepcopy(tm.map_specs)):map(function(spec)
		return spec.key 
	end):totable(),
	config = function()
		local telescope = require("telescope")

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

		vim.iter(vim.deepcopy(tm.map_specs)):each(function(spec)
			tm.map_tele(spec.key, spec.func)
		end)

		require("faith.plugins.telescope-conf")
	end
}
