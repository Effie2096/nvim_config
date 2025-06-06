local icons = require("faith.icons")
return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local Path = require("plenary.path")
			local harpoon = require("harpoon")
			harpoon:setup()

			local add_to_tab = function(name)
				name = name
					or Path:new(
						vim.api.nvim_buf_get_name(
							vim.api.nvim_get_current_buf()
						)
					):make_relative()
				return {
					value = name,
					context = { tab = vim.fn.tabpagenr() },
				}
			end

			local tab_lists = {}
			for i = 1, 100 do
				tab_lists["tab" .. i] = {
					add = function(possible_value)
						return add_to_tab(possible_value)
					end,
				}
			end

			vim.api.nvim_create_autocmd("TabClosed", {
				callback = function(args)
					local tab_name = string.format("%s%d", "tab", args.file)
					if harpoon:list(tab_name) then
						harpoon:list(tab_name):clear()
					end
				end,
			})

			harpoon:setup(tab_lists)

			local harpoon_extensions = require("harpoon.extensions")
			harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
			harpoon:extend({
				UI_CREATE = function(cx)
					vim.keymap.set("n", "<C-v>", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-x>", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-t>", function()
						harpoon.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr })
				end,
			})

			vim.api.nvim_create_autocmd("TabClosed", {
				callback = function(args)
					require("harpoon")
						:list(string.format("%s%d", "tab", args.file))
						:clear()
				end,
			})

			vim.keymap.set("n", "<leader>ma", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:add()
			end)
			vim.keymap.set("n", "<leader>me", function()
				harpoon.ui:toggle_quick_menu(
					harpoon:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
				)
			end)

			vim.keymap.set("n", "<C-h>", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:select(1)
			end)
			vim.keymap.set("n", "<C-j>", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:select(2)
			end)
			vim.keymap.set("n", "<C-k>", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:select(3)
			end)
			vim.keymap.set("n", "<C-l>", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:select(4)
			end)
			vim.keymap.set("n", "<C-Left>", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:select(5)
			end)
			vim.keymap.set("n", "<C-Down>", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:select(6)
			end)
			vim.keymap.set("n", "<C-Up>", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:select(7)
			end)
			vim.keymap.set("n", "<C-Right>", function()
				harpoon
					:list(
						string.format(
							"%s%d",
							"tab",
							vim.api.nvim_get_current_tabpage()
						)
					)
					:select(8)
			end)
		end,
	},
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
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
						vim.iter(vim.api.nvim_tabpage_list_wins(0))
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
			},
		},
	},
	{
		"mrjones2014/smart-splits.nvim",
		opts = {},
		config = function()
			vim.keymap.set("n", "<S-Left>", require("smart-splits").resize_left)
			vim.keymap.set("n", "<S-Down>", require("smart-splits").resize_down)
			vim.keymap.set("n", "<S-Up>", require("smart-splits").resize_up)
			vim.keymap.set(
				"n",
				"<S-Right>",
				require("smart-splits").resize_right
			)
			-- moving between splits
			vim.keymap.set(
				"n",
				"<M-h>",
				require("smart-splits").move_cursor_left
			)
			vim.keymap.set(
				"n",
				"<M-j>",
				require("smart-splits").move_cursor_down
			)
			vim.keymap.set("n", "<M-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set(
				"n",
				"<M-l>",
				require("smart-splits").move_cursor_right
			)
		end,
	},
	{
		"hedyhli/outline.nvim",
		opts = {
			relative_width = false,
			keymaps = {
				up_and_jump = "<C-p>",
				down_and_jump = "<C-n>",
			},
		},
		keys = {
			{
				"<leader>lo",
				"<cmd>Outline<cr>",
				desc = "[l]sp [o]utline: Open outline.",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
			{
				"antosha417/nvim-lsp-file-operations",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
				config = function()
					require("lsp-file-operations").setup()
				end,
			},
			{
				"s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = {
									"neo-tree",
									"neo-tree-popup",
									"notify",
									"OverseerList",
									"undotree",
									"Outline",
								},
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module "neo-tree"
		---@type neotree.Config?
		opts = {
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = icons.ui.ArrowClosed,
					expander_expanded = icons.ui.ArrowOpen,
					expander_highlight = "NeoTreeExpander",
				},
			},
			window = {
				mappings = {
					["e"] = function()
						vim.api.nvim_cmd({
							cmd = "Neotree",
							args = { "focus", "filesystem", "left" },
						}, { output = false })
					end,
					["b"] = function()
						vim.api.nvim_cmd({
							cmd = "Neotree",
							args = { "focus", "buffers", "left" },
						}, { output = false })
					end,
					["g"] = function()
						vim.api.nvim_cmd({
							cmd = "Neotree",
							args = { "focus", "git_status", "left" },
						}, { output = false })
					end,
				},
			},
			filesystem = {
				hijack_netrw_behavior = "disabled",
				commands = {
					avante_add_files = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local relative_path =
							require("avante.utils").relative_path(filepath)

						local sidebar = require("avante").get()

						local open = sidebar:is_open()
						-- ensure avante sidebar is open
						if not open then
							require("avante.api").ask()
							sidebar = require("avante").get()
						end

						sidebar.file_selector:add_selected_file(relative_path)

						-- remove neo tree buffer
						if not open then
							sidebar.file_selector:remove_selected_file(
								"neo-tree filesystem [1]"
							)
						end
					end,
				},
				window = {
					mappings = {
						["h"] = function(state)
							local node = state.tree:get_node()
							if
								node.type == "directory" and node:is_expanded()
							then
								require("neo-tree.sources.filesystem").toggle_directory(
									state,
									node
								)
							else
								require("neo-tree.ui.renderer").focus_node(
									state,
									node:get_parent_id()
								)
							end
						end,
						["l"] = function(state)
							local node = state.tree:get_node()
							if node.type == "directory" then
								if not node:is_expanded() then
									require("neo-tree.sources.filesystem").toggle_directory(
										state,
										node
									)
								elseif node:has_children() then
									require("neo-tree.ui.renderer").focus_node(
										state,
										node:get_child_ids()[1]
									)
								end
							end
						end,
						["oa"] = "avante_add_files",
					},
				},
			},
		},
		keys = {
			{
				"<leader>ef",
				"<cmd>Neotree filesystem toggle left<cr>",
				desc = "[e]xplore [f]iles: Open file explorer.",
			},
		},
	},
	---@type LazySpec
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		dependencies = {
			-- check the installation instructions at
			-- https://github.com/folke/snacks.nvim
			"folke/snacks.nvim",
		},
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				"<leader>-",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
			{
				-- Open in the current working directory
				"<leader>cw",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			{
				"<leader><up>",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
		},
		---@type YaziConfig | {}
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
		},
	},
}
