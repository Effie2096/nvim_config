return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				--[[ mappings = {
					i = {
						["<M-p>"] = require("telescope.actions.layout").toggle_preview,
					},
				}, ]]
			},
			extensions = {
				-- fzf = {
				-- 	fuzzy = true,
				-- 	override_generic_sorter = true,
				-- 	override_file_sorter = true,
				-- },
				["ui-select"] = {
					require("telescope.themes").get_cursor(
						require("faith.plugins.telescope-conf.layouts").layout_configs.default_cursor
					),
				},
			},
		})

		require("faith.plugins.telescope-conf")
		require("faith.plugins.telescope-conf.mappings")

		require("telescope").load_extension("ui-select")
		-- require("telescope").load_extension("file_browser")
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("refactoring")
		require("telescope").load_extension("harpoon")
		-- require("telescope").load_extension("git_worktree")
		-- require("telescope").load_extension("scdoc")
		require("telescope").load_extension("noice")
	end,
}
