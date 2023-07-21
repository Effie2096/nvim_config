if not pcall(require, "telescope") then
	return
end

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
	local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

	TelescopeMapArgs[map_key] = options or {}

	local mode = "n"
	local rhs = string.format('<cmd>lua require("faith.telescope")["%s"](TelescopeMapArgs["%s"])<CR>', f, map_key)

	local map_options = {
		noremap = true,
		silent = true,
	}

	if not buffer then
		vim.api.nvim_set_keymap(mode, key, rhs, map_options)
	else
		vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
	end
end

-- basic builtins
map_tele("<leader>ff", "find_files")
map_tele("<leader>fp", "project_files")
map_tele("<leader>fL", "live_grep")
map_tele("<leader>fb", "buffers")
map_tele("<leader>fh", "help_tags")
map_tele("<leader>fk", "keymaps")
map_tele("<leader>fl", "current_buffer_fuzzy_find")
map_tele("<leader>fs", "lsp_document_symbols")
map_tele("<leader>fS", "lsp_workspace_symbols")
map_tele("<leader>fgc", "git_commits")
map_tele("<leader>fgs", "git_status")
map_tele("<leader>fi", "spell_suggest")
map_tele("<leader>fd", "diagnostics")
map_tele("<leader>fm", "harpoon")

-- extensions
map_tele("<leader>fe", "file_browser")
map_tele("<leader>ft", "todo")

return map_tele
