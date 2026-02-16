return {
	{
		"JezerM/oil-lsp-diagnostics.nvim",
		lazy = true,
		dependencies = "stevearc/oil.nvim",
		opts = {},
	},
	{
		"refractalize/oil-git-status.nvim",
		lazy = true,
		dependencies = "stevearc/oil.nvim",
		opts = {
			show_ignored = true,
		},
	},
	{
		"stevearc/oil.nvim",
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			win_options = {
				signcolumn = "yes:2",
			},
			delete_to_trash = true,
			columns = {
				"icon",
				"size",
				"mtime",
			},
			-- Set to false to disable all of the below keymaps
			use_default_keymaps = false,
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<C-s>"] = { "actions.select", opts = { vertical = true } },
				["<C-x>"] = { "actions.select", opts = { horizontal = true } },
				["<C-t>"] = { "actions.select", opts = { tab = true } },
				["<C-p>"] = function()
					require("oil.actions").preview.callback()
					vim.defer_fn(function()
						vim
							.iter(vim.api.nvim_tabpage_list_wins(0))
							:filter(vim.api.nvim_win_is_valid)
							:filter(function(v)
								return vim.wo[v].previewwindow
							end)
							:filter(function(v)
								return vim.w[v]["oil_preview"]
							end)
							:each(function(v)
								vim.wo[v].winfixwidth = true
							end)
					end, 50)
				end,
				["<C-c>"] = { "actions.close", mode = "n" },
				["<C-l>"] = "actions.refresh",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				["`"] = { "actions.cd", mode = "n" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { "actions.toggle_hidden", mode = "n" },
				["g\\"] = { "actions.toggle_trash", mode = "n" },
				["<leader>p"] = function()
					local oil = require("oil")
					local filename = oil.get_cursor_entry().name
					local dir = oil.get_current_dir()
					oil.close()

					local img_clip = require("img-clip")
					img_clip.paste_image({}, dir .. filename)
				end,
			},
		},
	},
}
