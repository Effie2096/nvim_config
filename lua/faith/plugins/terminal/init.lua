local floaterm = require("faith.plugins.terminal.floaterm")
local toggleterm = floaterm.toggleFloaterm
local toggleopts = floaterm.term_opts
local construct_args = floaterm.construct_args

return {
	{
		"voldikss/vim-floaterm",
		config = function()
			vim.g.floaterm_title = ""
			vim.keymap.set("t", "<MouseMove>", "<NOP>")
		end,
		keys = {
			{
				"<Leader>\\\\",
				function()
					local sizeopts = toggleopts()
					---@type floaterm.Opts
					local opts = {
						name = "nu",
						title = "Nushell",
						wintype = sizeopts.direction == "vertical" and "vsplit"
							or "split",
						autoclose = floaterm.AUTOCLOSE.ALWAYS,
						width = sizeopts.size,
						height = sizeopts.size,
					}
					toggleterm(construct_args(opts, "nu"))
				end,
				mode = { "n", "t" },
				desc = "Nu Shell",
			},
			{
				"<Leader>\\g",
				function()
					---@type floaterm.Opts
					local opts = {
						name = "lazygit",
						title = "Lazygit",
						wintype = floaterm.Wintype.float,
						autoclose = floaterm.Autoclose.always,
						width = 0.8,
						height = 0.9,
					}
					toggleterm(construct_args(opts))
				end,
				mode = { "n", "t" },
				desc = "LazyGit",
			},
		},
	},
}
