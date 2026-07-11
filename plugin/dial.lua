vim.pack.add(
	{ { src = "https://github.com/monaqa/dial.nvim" } },
	{ load = false }
)

local function config()
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
end

local function load()
	if not package.loaded["dial.config"] then
		vim.cmd.packadd("dial.nvim")
		config()
	end
end

local map_cb = function(cb)
	return function()
		load()
		cb()
	end
end

vim.keymap.set(
	"n",
	"<C-a>",
	map_cb(function()
		require("dial.map").manipulate("increment", "normal")
	end)
)
vim.keymap.set(
	"n",
	"<C-x>",
	map_cb(function()
		require("dial.map").manipulate("decrement", "normal")
	end)
)
vim.keymap.set(
	"n",
	"g<C-a>",
	map_cb(function()
		require("dial.map").manipulate("increment", "gnormal")
	end)
)
vim.keymap.set(
	"n",
	"g<C-x>",
	map_cb(function()
		require("dial.map").manipulate("decrement", "gnormal")
	end)
)
vim.keymap.set(
	"x",
	"<C-a>",
	map_cb(function()
		require("dial.map").manipulate("increment", "visual")
	end)
)
vim.keymap.set(
	"x",
	"<C-x>",
	map_cb(function()
		require("dial.map").manipulate("decrement", "visual")
	end)
)
vim.keymap.set(
	"x",
	"g<C-a>",
	map_cb(function()
		require("dial.map").manipulate("increment", "gvisual")
	end)
)
vim.keymap.set(
	"x",
	"g<C-x>",
	map_cb(function()
		require("dial.map").manipulate("decrement", "gvisual")
	end)
)
