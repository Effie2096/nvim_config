local icons = require("faith.icons")

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{
				"<leader>ef",
				"<cmd>Neotree filesystem toggle left<cr>",
				desc = "[e]xplore [f]iles: Open file explorer.",
			},
		},
		branch = "v3.x",
		dependencies = {
			"plenary.nvim",
			"dev_icons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				"antosha417/nvim-lsp-file-operations",
				dependencies = {
					"plenary.nvim",
					"nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
				},
				config = function()
					require("lsp-file-operations").setup()
				end,
			},
			"saifulapm/neotree-file-nesting-config",
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module "neo-tree"
		---@type neotree.Config?
		opts = function(_, opts)
			local function on_move(data)
				Snacks.rename.on_rename_file(data.source, data.destination)
			end
			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})
			return {
				hide_root_node = true,
				retain_hidden_root_indent = true,
				enable_git_status = true,
				enable_diagnostics = true,
				source_selector = {
					content_layout = "center",
					tabs_layout = "equal",
					padding = 0,
					separator = { left = "", right = "" }, -- string | { left: string, right: string, override: string | nil }
					separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
					highlight_tab = "MyNeoTreeTabInactive",
					highlight_tab_active = "MyNeoTreeTabActive",
					highlight_background = "MyNeoTreeTabInactive",
					highlight_separator = "MyNeoTreeTabSeparatorInactive",
					highlight_separator_active = "MyNeoTreeTabSeparatorActive",
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
					group_empty_dirs = true,
					filtered_items = {
						show_hidden_count = false,
						never_show = {
							".DS_Store",
						},
					},
					hijack_netrw_behavior = "disabled",
					use_libuv_file_watcher = true,
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
								if node.type == "directory" and node:is_expanded() then
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
									local str = require("neo-tree.ui.selector").get()
									if str then
										_G.__cached_neo_tree_selector = string.gsub(str, "%s+", " ")
									end
								end)
							end
						end,
					},
				},
			}
		end,
		config = function(_, opts)
			opts.nesting_rules = require("neotree-file-nesting-config").nesting_rules
			require("neo-tree").setup(opts)
		end,
	},
}
