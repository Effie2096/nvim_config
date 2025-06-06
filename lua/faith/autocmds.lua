local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command
local namespace = vim.api.nvim_create_namespace

autocmd("FileType", {
	desc = "Unlist quickfix buffers",
	group = augroup("unlist_quickfix", { clear = true }),
	pattern = "qf",
	callback = function()
		vim.opt_local.buflisted = false
	end,
})
autocmd("BufWinEnter", {
	desc = "Make q close help, man, quickfix, dap floats",
	group = augroup("q_close_windows", { clear = true }),
	callback = function(args)
		local buftype =
			vim.api.nvim_get_option_value("buftype", { buf = args.buf })
		if
			vim.tbl_contains({ "help", "nofile", "quickfix" }, buftype)
			and vim.fn.maparg("q", "n") == ""
		then
			vim.keymap.set("n", "q", "<cmd>close<cr>", {
				desc = "Close window",
				buffer = args.buf,
				silent = true,
				nowait = true,
			})
		end
	end,
})
