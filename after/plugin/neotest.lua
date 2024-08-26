local has_neotest, neotest = pcall(require, "neotest")
if not has_neotest then
	return
end

local desc = require("faith.keymap").desc

local opts = { silent = true, noremap = true }
vim.keymap.set("n", "<leader>t", function()
	require("neotest").run.run()
end, desc(opts, "[t]est nearest."))
vim.keymap.set("n", "<leader>T", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, desc(opts, "[T]est file."))
vim.keymap.set("n", "<leader>ta", function()
	require("neotest").run.run({ suite = true })
end, desc(opts, "[t]est [a]ll"))
vim.keymap.set("n", "<leader>tl", function()
	require("neotest").run.run_last()
end, desc(opts, "[t]est [l]ast."))
vim.keymap.set("n", "<leader>tg", function()
	local last = require("neotest").run.get_last_run()
	P(string.format("last %s", last))
	if last == nil then
		vim.notify("No test ran yet")
		return
	end
	local filename = string.gsub(vim.fn.split(require("neotest").run.get_last_run(), "::")[1], '"', "")
	-- double check file hasn't been deleted since last run
	if vim.fn.filereadable(filename) > 0 then
		vim.cmd.drop(filename)
	end
end, desc(opts, "[t]est [g]o: Go to last file tests were ran."))
vim.keymap.set("n", "<leader>to", function()
	-- require("neotest").output_panel.toggle()
	require("overseer").toggle({ enter = false, direction = "bottom" })
	require("neotest").summary.toggle()
end, desc(opts, "[t]est [o]utput: "))

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
		require("rustaceanvim.neotest"),
		require("neotest-vim-test")({
			allow_file_types = { "c" },
			ignore_file_types = { "python", "vim", "lua", "rust" },
		}),
	},
	consumers = {
		overseer = require("neotest.consumers.overseer"),
	},
})
