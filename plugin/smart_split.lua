vim.pack.add({
	{
		src = "https://github.com/mrjones2014/smart-splits.nvim",
		version = vim.version.range("2.x"),
	},
}, { load = false })

local function config()
	require("smart-splits").setup()
end

local function load()
	if package.loaded["smart-splits"] then
		return
	end

	vim.cmd.packadd("smart-splits.nvim")

	config()
end

local map_cb = function(cb)
	load()
	return function()
		cb()
	end
end

vim.keymap.set(
	"n",
	"<S-Left>",
	map_cb(require("smart-splits").resize_left),
	{ desc = "Resize window Left" }
)
vim.keymap.set(
	"n",
	"<S-Down>",
	map_cb(require("smart-splits").resize_down),
	{ desc = "Resize window Down" }
)
vim.keymap.set(
	"n",
	"<S-Up>",
	map_cb(require("smart-splits").resize_up),
	{ desc = "Resize window Up" }
)
vim.keymap.set(
	"n",
	"<S-Right>",
	map_cb(require("smart-splits").resize_right),
	{ desc = "Resize window Right" }
)
-- moving between splits
vim.keymap.set(
	"n",
	"<M-Left>",
	map_cb(require("smart-splits").move_cursor_left),
	{ desc = "Move window focus Left" }
)
vim.keymap.set(
	"n",
	"<M-Down>",
	map_cb(require("smart-splits").move_cursor_down),
	{ desc = "Move window focus Down" }
)
vim.keymap.set(
	"n",
	"<M-Up>",
	map_cb(require("smart-splits").move_cursor_up),
	{ desc = "Move window focus Up" }
)
vim.keymap.set(
	"n",
	"<M-Right>",
	map_cb(require("smart-splits").move_cursor_right),
	{ desc = "Move window focus Right" }
)
