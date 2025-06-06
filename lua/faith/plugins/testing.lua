local icons = require("faith.icons")
return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",

			"vim-test/vim-test",
			"nvim-neotest/neotest-vim-test",

			"nvim-neotest/neotest-python",
		},
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
						vim.fn.split(
							require("neotest").run.get_last_run(),
							"::"
						)[1],
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
		opts = function()
			local opts = {
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = true },
						python = function()
							if vim.fn.has("win32") == 1 then
								return vim.fn.glob(
									os.getenv("HOME")
										.. "\\.virtualenvs\\"
										.. vim.fn.fnamemodify(
											vim.fn.getcwd(),
											":t"
										)
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
			}

			return opts
		end,
	},
	{
		"andythigpen/nvim-coverage",
		version = "*",
		opts = {
			commands = true, -- create commands
			highlights = {
				-- customize highlight groups created by the plugin
				covered = nil, -- supports style, fg, bg, sp (see :h highlight-gui)
				uncovered = nil,
				partial = nil,
			},
			signs = {
				-- use your own highlight groups or text markers
				covered = {
					hl = "CoverageCovered",
					text = icons.testing.covered,
				},
				uncovered = {
					hl = "CoverageUncovered",
					text = icons.testing.uncovered,
				},
				partial = {
					hl = "CoveragePartial",
					text = icons.testing.partial,
				},
			},
			summary = {
				-- customize the summary pop-up
				min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
			},
			load_coverage_cb = function(ftype)
				vim.notify("Loaded " .. ftype .. " coverage")
			end,
			lang = {
				rust = {
					coverage_command = "grcov ${cwd} -s ${cwd} --binary-path ./target/debug/ -t coveralls --branch --ignore-not-existing --token NO_TOKEN",
				},
			},
		},
	},
}
