vim.opt.autoread = true

vim.api.nvim_create_augroup("reload_changed_buffer", { clear = false })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = "reload_changed_buffer",
	callback = function()
		if vim.fn.mode ~= "c" then
			vim.api.nvim_exec2([[checktime]], { output = false })
			---- TODO: handle warning and error e.g. error, didn't already exist
		end
	end,
})
