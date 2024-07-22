local has_neotest, neotest = pcall(require, "neotest")
if not has_neotest then
	return
end

neotest.setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = true },
			python = function()
				if vim.fn.has("win32") == 1 then
					return vim.fn.glob(
						os.getenv("HOME")
							.. "\\.virtualenvs\\"
							.. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							.. "*"
							.. "\\Scripts"
					) .. "\\python.exe"
				end
				return vim.fn.glob(
					os.getenv("XDG_CACHE_HOME")
						.. "/virtualenvs/"
						.. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						.. "*"
						.. "/bin"
				) .. "/python"
			end,
		}),
		require("neotest-vim-test")({
			allow_file_types = { "c" },
			ignore_file_types = { "python", "vim", "lua" },
		}),
	},
})
