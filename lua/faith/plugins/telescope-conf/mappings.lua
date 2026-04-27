TelescopeMapArgs = TelescopeMapArgs or {}

M = {}

M.map_tele = function(key, f, options, buffer)
	local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

	TelescopeMapArgs[map_key] = options or {}

	local mode = "n"
	local rhs = string.format(
		'<cmd>lua require("faith.plugins.telescope-conf")["%s"](TelescopeMapArgs["%s"])<CR>',
		f,
		map_key
	)

	local map_options = {
		noremap = true,
		silent = true,
		desc = "Telescope: " .. f,
	}

	if not buffer then
		vim.api.nvim_set_keymap(mode, key, rhs, map_options)
	else
		vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
	end
end

M.map_specs = {
-- basic builtins
{ func = "find_files", key = "<leader>ff" },
{ func = "oldfiles", key = "<leader>fo" },
{ func = "project_files", key = "<leader>fp" },
{ func = "current_buffer_fuzzy_find", key = "<leader>fl" },
{ func = "live_grep", key = "<leader>fL" },
{ func = "buffers", key = "<leader>fb" },
{ func = "grep_string", key = "<leader>fw" },
{ func = "help_tags", key = "<leader>fh" },
{ func = "highlights", key = "<leader>fH" },
{ func = "keymaps", key = "<leader>fk" },
{ func = "lsp_document_symbols", key = "<leader>fs" },
{ func = "lsp_workspace_symbols", key = "<leader>fS" },
{ func = "git_commits", key = "<leader>fgc" },
{ func = "git_branches", key = "<leader>fgb" },
{ func = "git_status", key = "<leader>fgs" },
{ func = "spell_suggest", key = "<leader>fi" },
{ func = "diagnostics", key = "<leader>fd" },
{ func = "commands", key = "<leader>;" },
{ func = "loclist", key = "<leader>fq" },
{ func = "quickfix", key = "<leader>fQ" },
{ func = "resume", key = "<leader>f;" },

-- extensions
{ func = "todo", key = "<leader>ft" },
{ func = "harpoon", key = "<leader>fm" },
-- { func = "git_worktrees", key = "<leader>fgw" },
}

return M
