return {
	{
		"nvim-neotest/neotest",
		cmd = "Neotest",
		keys = {
			{
				"<leader>trr",
				function()
					require("neotest").run.run()
				end,
				desc = "[t]est nearest.",
			},
			{
				"<leader>trf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "[T]est file.",
			},
			{
				"<leader>tra",
				function()
					require("neotest").run.run({ suite = true })
				end,
				desc = "[t]est [a]ll",
			},
			{
				"<leader>trl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "[t]est [l]ast.",
			},
			{
				"<leader>trg",
				function()
					local last = require("neotest").run.get_last_run()
					if last == nil then
						vim.notify("No test ran yet")
						return
					end
					local filename = string.gsub(
						vim.fn.split(require("neotest").run.get_last_run(), "::")[1],
						'"',
						""
					)
					-- double check file hasn't been deleted since last run
					if vim.fn.filereadable(filename) > 0 then
						vim.cmd.drop(filename)
					end
				end,
				desc = "[t]est [g]o: Go to last file tests were ran.",
			},
			{
				"<leader>to",
				function()
					-- require("neotest").output_panel.toggle()
					require("overseer").toggle({
						enter = false,
						direction = "bottom",
					})
					require("neotest").summary.toggle()
				end,
				desc = "[t]est [o]utput: ",
			},
		},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",

			-- Adapters
			"MisanthropicBit/neotest-busted",
			"nvim-neotest/neotest-plenary",
		},
		config = function()
			local neotest = require("neotest")
			local opts = {
				adapters = {
					-- require("neotest-busted")(),
					require("neotest-plenary")({
						min_init = "minimal_init.lua",
					}),
				},
			}
			neotest.setup(opts)
		end,
	},
}
