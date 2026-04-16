SHOULD_RELOAD_TELESCOPE = true
local action_state = require("telescope.actions.state")

local reloader = function()
	if SHOULD_RELOAD_TELESCOPE then
		RELOAD("plenary")
		RELOAD("telescope")
		RELOAD("faith.plugins.telescope-conf")
	end
end

M = {}

local configs = require("faith.plugins.telescope-conf.layouts")
local layouts = configs.layout_configs

local function merge_ext_options(local_options, ext_options)
	return vim.tbl_deep_extend("force", local_options, ext_options)
end

function M.find_files(options)
	local opts = vim.deepcopy(layouts.default_flex) or {}
	if options then
		opts = merge_ext_options(opts, options)
	end

	opts = vim.tbl_extend("force", opts, {
		hidden = true,
		no_ignore = true,
		no_ignore_parent = true,
		file_ignore_patterns = nil,
	})

	require("telescope.builtin").find_files(opts)
end

function M.project_files()
	local opts = vim.deepcopy(layouts.default_flex)
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = "Project Files",
		cwd = require("lspconfig.util").root_pattern(".git")(vim.fn.expand("%:p"))
			or vim.fn.getcwd(),
	})
	require("telescope.builtin").find_files(opts)
end

function M.oldfiles()
	local opts = vim.deepcopy(layouts.default_flex)
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = "Recent Files",
		cwd = require("lspconfig.util").root_pattern(".git")(vim.fn.expand("%:p")),
	})
	require("telescope.builtin").oldfiles(opts)
end

local buffers_maps = function(_, map)
	map("i", "<c-d>", require("telescope.actions").delete_buffer)
	map("n", "d", require("telescope.actions").delete_buffer)
end

function M.scope_buffers()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = "Scope Buffers",
		attach_mappings = require("faith.plugins.telescope-conf.layouts").attach_mappings_with_defaults(
			-- buffers_maps,
			function(_, map)
				map("i", "<c-d>", function(prompt_bufnr)
					local current_picker = action_state.get_current_picker(prompt_bufnr)

					current_picker:delete_selection(function(selection)
						local current_tab = vim.api.nvim_get_current_tabpage()
						local current_buf = selection.bufnr

						-- Ensure the cache is up-to-date
						require("scope.core").revalidate()

						local buffers_in_current_tab =
							require("scope.core").cache[current_tab]

						-- Check if the buffer exists in other tabs (could be a utils function)
						local buffer_exists_in_other_tabs = false
						for tab, buffers in pairs(require("scope.core").cache) do
							if tab ~= current_tab then
								for _, buffer in ipairs(buffers) do
									if buffer == current_buf then
										buffer_exists_in_other_tabs = true
										break
									end
								end
							end
							if buffer_exists_in_other_tabs then
								break
							end
						end

						-- If the buffer exists in other tabs, hide it in the current tab
						if buffer_exists_in_other_tabs then
							if #buffers_in_current_tab > 1 then
								vim.api.nvim_buf_set_option(current_buf, "buflisted", false)
								vim.cmd([[bprev]])
							else
								--     vim.cmd("tabclose")
								local empty_buf = vim.api.nvim_create_buf(true, true)
								vim.api.nvim_win_set_buf(
									current_picker.original_win_id,
									empty_buf
								)
								current_picker.original_bufnr = empty_buf
								vim.api.nvim_buf_delete(selection.bufnr, { force = true })
							end
						else -- buffer does not exist in other tabs
							local tab_count = #vim.api.nvim_list_tabpages()
							if #buffers_in_current_tab == 1 then
								if tab_count > 1 then
									vim.api.nvim_buf_delete(current_buf, { force = true })
									-- if tab_count > 1 then
									--     vim.cmd("tabclose")
									-- end

									local empty_buf = vim.api.nvim_create_buf(true, true)
									vim.api.nvim_win_set_buf(
										current_picker.original_win_id,
										empty_buf
									)
									current_picker.original_bufnr = empty_buf
									vim.api.nvim_buf_delete(selection.bufnr, { force = true })
								else
									-- Ask for confirmation before quitting if it's the only tab
									local choice = 1
									if opts.ask then
										choice = vim.fn.confirm(
											"You're about to close the last tab. Do you want to quit?",
											"&Yes\n&No"
										)
									end
									-- if choice == 1 then
									-- 	vim.cmd("qa!")
									-- end
								end
							else
								vim.api.nvim_buf_delete(current_buf, { force = opts.force })
							end
						end

						-- Update the cache
						require("scope.core").revalidate()
						-- require("scope.core").close_buffer({
						-- 	buf = selection.bufnr,
						-- 	ask = false,
						-- })
					end)
					return true
				end)
				map("n", "d", function(prompt_bufnr)
					local current_picker = action_state.get_current_picker(prompt_bufnr)

					current_picker:delete_selection(function(selection)
						require("scope.core").close_buffer({
							buf = selection.bufnr,
							ask = false,
						})
					end)
					return true
				end)
			end
		),
	})
	-- scope.nvim makes buffers scoped by default so this feels inverted but
	-- "scope_buffers" is the default `all` buffers command now.
	require("telescope.builtin").buffers(opts)
end

function M.buffers()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = "Buffers",
		attach_mappings = require("faith.plugins.telescope-conf.layouts").attach_mappings_with_defaults(
			buffers_maps
		),
	})
	-- scope.nvim show all buffers
	require("telescope._extensions.scope").exports.buffers(opts)
end

function M.grep_string()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	require("telescope.builtin").grep_string(opts)
end

function M.current_buffer_fuzzy_find()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = "Find Word",
	})
	require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

function M.live_grep(options)
	local opts = vim.deepcopy(layouts.default_flex) or {}
	if options then
		opts = merge_ext_options(opts, options)
	end

	opts = vim.tbl_deep_extend("force", opts, {
		cwd = require("lspconfig.util").root_pattern(".git")(vim.fn.expand("%:p")),
		-- file_ignore_patterns = require("faith.plugins.telescope-conf.layouts").file_ignore.file_ignore_patterns,
	})
	require("telescope.builtin").live_grep(opts)
end

function M.git_commits()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	require("telescope.builtin").git_commits(opts)
end
function M.git_branches()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	require("telescope.builtin").git_branches(opts)
end

function M.git_status()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	require("telescope.builtin").git_status(opts)
end

function M.treesitter()
	local opts = vim.deepcopy(layouts.default_vert) or {}
	require("telescope.builtin").treesitter(opts)
end

function M.lsp_document_symbols()
	local opts = vim.deepcopy(layouts.default_vert) or {}
	require("telescope.builtin").lsp_document_symbols(opts)
end

function M.lsp_workspace_symbols()
	local opts = vim.deepcopy(layouts.default_vert) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		path_display = { "tail" },
	})
	require("telescope.builtin").lsp_dynamic_workspace_symbols(opts)
end

function M.help_tags()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = "Help",
		show_version = true,
	})

	require("telescope.builtin").help_tags(opts)
end

function M.keymaps()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	require("telescope.builtin").keymaps(opts)
end

function M.file_browser()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	require("telescope._extensions.file_browser").exports.file_browser(opts)
end

function M.todo()
	local opts = vim.deepcopy(layouts.default_bottom) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = "TODO Comments",
	})
	require("telescope._extensions.todo-comments").exports.todo(opts)
end

function M.spell_suggest()
	local opts = vim.deepcopy(layouts.default_cursor) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		layout_config = {
			width = 40,
			height = 10,
		},
	})
	require("telescope.builtin").spell_suggest(opts)
end

function M.diagnostics()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		-- bufnr = nil,
		no_unlisted = false,
	})
	require("telescope.builtin").diagnostics(opts)
end

function M.harpoon()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		path_display = "tail",
		layout_config = {
			horizontal = {
				height = 0.3,
			},
		},
	})
	require("telescope._extensions.harpoon").exports.marks(opts)
end

function M.git_worktrees()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	require("telescope").extensions.git_worktree.git_worktrees(opts)
end

function M.create_git_worktree()
	require("telescope").extensions.git_worktree.create_git_worktree()
end

function M.commands()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		layout_config = {
			anchor = "N",
		},
	})
	require("telescope.builtin").commands(opts)
end

function M.quickfix()
	local opts = vim.deepcopy(layouts.default_bottom) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = vim.fn.getqflist({ title = 0 }).title,
	})
	require("telescope.builtin").quickfix(opts)
end

function M.loclist()
	local opts = vim.deepcopy(layouts.default_bottom) or {}
	opts = vim.tbl_deep_extend("force", opts, {
		prompt_title = vim.fn.getloclist(0, { title = 0 }).title,
	})
	require("telescope.builtin").loclist(opts)
end

function M.resume()
	require("telescope.builtin").resume()
end

return setmetatable({}, {
	__index = function(_, k)
		reloader()
		if M[k] then
			return M[k]
		else
			return function()
				require("telescope.builtin")[k](vim.deepcopy(layouts.default_flex))
			end
		end
	end,
})
