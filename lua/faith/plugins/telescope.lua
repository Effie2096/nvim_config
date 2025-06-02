return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = function()
				if vim.fn.executable("cmake") == 0 then
					return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
				else
					return "make"
				end
			end,
		},
	},
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

		require("telescope").load_extension("ui-select")
		-- require("telescope").load_extension("file_browser")
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("refactoring")
		require("telescope").load_extension("harpoon")
		-- require("telescope").load_extension("git_worktree")
		-- require("telescope").load_extension("scdoc")
		require("telescope").load_extension("noice")
		require("telescope").load_extension("scope")

		require("faith.plugins.telescope-conf")
		require("faith.plugins.telescope-conf.mappings")
	end,
}
