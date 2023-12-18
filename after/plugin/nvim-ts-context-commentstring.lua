local has_ts_context_commentstring, ts_context_commentstring = pcall(require, "ts_context_commentstring")
if not has_ts_context_commentstring then
	return
end

-- NOTE: only needed until deprecated stuff removed. this just shuts up warning and speeds up startup
vim.g.skip_ts_context_commentstring_module = true

ts_context_commentstring.setup({
	enable_autocmd = false
})
