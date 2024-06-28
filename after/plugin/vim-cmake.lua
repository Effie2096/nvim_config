if not vim.fn.exists("g:cmake_command") == 1 then
	return
end

vim.cmd([[let g:cmake_link_compile_commands = 1]])

vim.api.nvim_create_augroup("cmake_maps", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = "cmake_maps",
	pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
	callback = function(args)
		local opts = { buffer = args.buf, noremap = true, silent = true }
		vim.keymap.set({ "i", "n" }, "<F3>", "<CMD>CMakeGenerate<CR>", opts)
		vim.keymap.set({ "i", "n" }, "<F4>", "<CMD>CMakeBuild<CR>", opts)
		local directory = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		local run_command = "./Debug/" .. directory
		if vim.fn.exists("*VimuxRunCommand") ~= 0 then
			vim.keymap.set({ "i", "n" }, "<F5>", function()
				local run_args = vim.fn.input("Args: ") or ""
				local c_args = string.len(run_args) > 0 and " " .. run_args or ""
				vim.cmd("AsyncRun -mode=term -pos=tmux -cwd=<root> " .. run_command .. c_args)
			end, vim.tbl_deep_extend("force", opts, { desc = "Run Project" }))
		end
	end,
})
