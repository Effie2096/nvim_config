M = {}

local layouts = require('faith.telescope.layouts').layout_configs

local function merge_ext_options(local_options, ext_options)
	return vim.tbl_deep_extend("force", local_options, ext_options)
end

function M.find_files()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	opts = vim.tbl_deep_extend(
		"force",
		opts,
		{
			no_ignore = true
		}
	)

	require('telescope.builtin').find_files(opts)
end

function M.buffers()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	require('telescope.builtin').buffers(opts)
end

function M.current_buffer_fuzzy_find()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

function M.live_grep(options)
	local opts = vim.deepcopy(layouts.default_flex) or {}
	if options then
		opts = merge_ext_options(opts, options)
	end
	require('telescope.builtin').live_grep(opts)
end

function M.git_commits()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	require('telescope.builtin').git_commits(opts)
end

function M.treesitter()
	local opts = vim.deepcopy(layouts.default_vert) or {}
	require('telescope.builtin').treesitter(opts)
end

function M.help_tags()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	opts = vim.tbl_deep_extend(
		"force",
		opts,
		{
			prompt_title = "Help",
			show_version = true
		}
	)

	require('telescope.builtin').help_tags(opts)
end

function M.file_browser()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	require('telescope._extensions.file_browser').exports.file_browser(opts)
end

function M.workspaces()
	local opts = vim.deepcopy(layouts.centered_compact) or {}
	require('telescope._extensions.workspaces').exports.workspaces(opts)
end

function M.todo()
	local opts = vim.deepcopy(layouts.default_vert) or {}
	opts = vim.tbl_deep_extend(
		"force",
		opts,
		{
			prompt_title = 'TODO Comments'
		}
	)
	require('telescope._extensions.todo-comments').exports.todo(opts)
end

function M.spell_suggest()
	local opts = vim.deepcopy(layouts.default_cursor) or {}
	require('telescope.builtin').spell_suggest(opts)
end

function M.diagnostics()
	local opts = vim.deepcopy(layouts.default_flex) or {}
	opts = vim.tbl_deep_extend(
		"force",
		opts,
		{
			-- bufnr = nil,
			no_unlisted = false,
		}
	)
	require('telescope.builtin').diagnostics(opts)
end

return setmetatable({}, {
	__index = function (_, k)
		if M[k] then
			return M[k]
		else
			return require('telescope.builtin')[k]
		end
	end
})
