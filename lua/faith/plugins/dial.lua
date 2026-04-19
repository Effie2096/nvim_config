return 	{
	"monaqa/dial.nvim",
	keys = {
		{ "<C-a>" },
		{ "<C-x>" },
		{ "g<C-a>" },
		{ "g<C-x>" },
		{ "<C-a>" },
		{ "<C-x>" },
		{ "g<C-a>" },
		{ "g<C-x>" },
	},
	config = function()
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
				augend.date.alias["%Y/%m/%d"],
				augend.constant.new({
					elements = { "and", "or" },
					word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
					cyclic = true, -- "or" is incremented into "and".
				}),
				augend.constant.new({
					elements = { "&&", "||" },
					word = false,
					cyclic = true,
				}),
				augend.hexcolor.new({
					case = "prefer_upper", -- or "lower", "prefer_upper", "prefer_lower", see below
				}),
				augend.semver.alias.semver,
				augend.constant.alias.bool,
				augend.constant.alias.Bool,
			},
		})
		vim.keymap.set("n", "<C-a>", function()
			require("dial.map").manipulate("increment", "normal")
		end)
		vim.keymap.set("n", "<C-x>", function()
			require("dial.map").manipulate("decrement", "normal")
		end)
		vim.keymap.set("n", "g<C-a>", function()
			require("dial.map").manipulate("increment", "gnormal")
		end)
		vim.keymap.set("n", "g<C-x>", function()
			require("dial.map").manipulate("decrement", "gnormal")
		end)
		vim.keymap.set("x", "<C-a>", function()
			require("dial.map").manipulate("increment", "visual")
		end)
		vim.keymap.set("x", "<C-x>", function()
			require("dial.map").manipulate("decrement", "visual")
		end)
		vim.keymap.set("x", "g<C-a>", function()
			require("dial.map").manipulate("increment", "gvisual")
		end)
		vim.keymap.set("x", "g<C-x>", function()
			require("dial.map").manipulate("decrement", "gvisual")
		end)
	end,
}
