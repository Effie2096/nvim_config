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

			local harpoon_tab_setup = function(tab_name, items)
				harpoon:setup({
					[tab_name] = {
						add = function(possible_value)
							return add_to_tab(possible_value)
						end,
					},
				})
				harpoon:list(tab_name).name = tab_name
				harpoon:list(tab_name).items = items or {} or {}
			end

			local new_tab = function(index)
				local tabs = vim.fn.tabpagenr("$")
				local new_tab = index

				local tab_name = string.format("%s%d", "tab", new_tab)
				if harpoon:list(tab_name) then
					-- if harpoon:list(tab_name).items then
					local x = tabs - new_tab
					for i = tabs, (tabs - x) + 1, -1 do
						local current_tab_name = string.format("%s%d", "tab", i)
						local previous_list =
							harpoon:list(string.format("%s%d", "tab", i - 1))

						harpoon_tab_setup(current_tab_name, previous_list.items)
					end
					-- end
				end
				harpoon_tab_setup(string.format("tab%d", new_tab), {})
			end

			local tab_move = function(count)
				local start_tab = vim.fn.tabpagenr()
				local last_tab = vim.fn.tabpagenr("$")

				if
					count == start_tab
					or (count == 0 and (start_tab == last_tab))
				then
					return
				end

				if count > start_tab and count > last_tab then
					count = last_tab
				elseif count == 0 then
					-- no count given, just move one to right
					count = start_tab + 1
				elseif count < start_tab and count < 1 then
					count = 0
				end

				local start_tab_name = string.format("%s%d", "tab", start_tab)
				local start_data = harpoon:list(start_tab_name).items

				vim.cmd.tabmove({ args = { count } })

				if start_tab > count then
					for i = start_tab, count + 1, -1 do
						local current_tab_name = string.format("%s%d", "tab", i)
						local previous_list = harpoon:list(
							string.format("%s%d", "tab", i - 1)
						).items

						harpoon_tab_setup(current_tab_name, previous_list)
					end

					harpoon_tab_setup(
						string.format("tab%d", count + 1),
						start_data
					)
				else
					for i = start_tab, count - 1 do
						local current_tab_name = string.format("%s%d", "tab", i)
						local previous_list = harpoon:list(
							string.format("%s%d", "tab", i + 1)
						).items

						harpoon_tab_setup(current_tab_name, previous_list)
					end

					harpoon_tab_setup(string.format("tab%d", count), start_data)
				end
			end

			vim.keymap.set("n", "<leader>ttm", function()
				tab_move(vim.v.count)
			end, { desc = "[t]ab [m]ove: Move current tab" })

			vim.api.nvim_create_autocmd("TabClosed", {
				callback = function(args)
					require("harpoon"):list("tab" .. args.file):clear()
				end,
			})

			vim.api.nvim_create_autocmd("TabNew", {
				callback = function(args)
					new_tab(vim.fn.tabpagenr())
				end,
			})

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

			vim.keymap.set("n", "<leader>ma", function()
				harpoon
					:list(string.format("%s%d", "tab", vim.fn.tabpagenr()))
					:add()
			end)
			vim.keymap.set("n", "<leader>me", function()
				harpoon.ui:toggle_quick_menu(
					harpoon:list(
						string.format("%s%d", "tab", vim.fn.tabpagenr())
					)
				)
			end)

			vim.keymap.set("n", "<M-h>", function()
				harpoon
					:list(string.format("%s%d", "tab", vim.fn.tabpagenr()))
					:select(1)
			end)
			vim.keymap.set("n", "<M-j>", function()
				harpoon
					:list(string.format("%s%d", "tab", vim.fn.tabpagenr()))
					:select(2)
			end)
			vim.keymap.set("n", "<M-k>", function()
				harpoon
					:list(string.format("%s%d", "tab", vim.fn.tabpagenr()))
					:select(3)
			end)
			vim.keymap.set("n", "<M-l>", function()
				harpoon
					:list(string.format("%s%d", "tab", vim.fn.tabpagenr()))
					:select(4)
			end)
			vim.keymap.set("n", "<M-;>", function()
				harpoon
					:list(string.format("%s%d", "tab", vim.fn.tabpagenr()))
					:select(5)
			end)
			vim.keymap.set("n", "<M-'>", function()
				harpoon
					:list(string.format("%s%d", "tab", vim.fn.tabpagenr()))
					:select(6)
			end)
		end,
	},
	{
		"JezerM/oil-lsp-diagnostics.nvim",
		dependencies = "stevearc/oil.nvim",
		opts = {},
	},
	{
		"refractalize/oil-git-status.nvim",
		dependencies = "stevearc/oil.nvim",
		opts = {
			show_ignored = true,
		},
	},
	{
		"stevearc/oil.nvim",
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
				"<M-Left>",
				require("smart-splits").move_cursor_left
			)
			vim.keymap.set(
				"n",
				"<M-Down>",
				require("smart-splits").move_cursor_down
			)
			vim.keymap.set(
				"n",
				"<M-Up>",
				require("smart-splits").move_cursor_up
			)
			vim.keymap.set(
				"n",
				"<M-Right>",
				require("smart-splits").move_cursor_right
			)
		end,
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
			source_selector = {
				content_layout = "center",
				tabs_layout = "equal",
				padding = 0,
				separator = { left = "", right = "" }, -- string | { left: string, right: string, override: string | nil }
				separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
				highlight_tab = "NeoTreeTabInactive",
				highlight_tab_active = "NeoTreeTabActive",
				highlight_background = "NeoTreeTabInactive",
				highlight_separator = "NeoTreeTabSeparatorInactive",
				highlight_separator_active = "NeoTreeTabSeparatorActive",
			},
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
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--               -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				hijack_netrw_behavior = "disabled",
				use_libuv_file_watcher = false,
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
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						vim.cmd("highlight! Cursor blend=100")
					end,
				},
				{
					event = "neo_tree_buffer_leave",
					handler = function()
						vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
					end,
				},
				{
					event = "after_render",
					handler = function(state)
						if
							state.current_position == "left"
							or state.current_position == "right"
						then
							vim.api.nvim_win_call(state.winid, function()
								local str =
									require("neo-tree.ui.selector").get()
								if str then
									_G.__cached_neo_tree_selector =
										string.gsub(str, "%s+", " ")
								end
							end)
						end
					end,
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
}
