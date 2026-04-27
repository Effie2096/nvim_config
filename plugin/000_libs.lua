local notify = require("notify")
notify.setup({
	render = "wrapped-compact",
	fps = 60,
	top_down = false
})
vim.notify = require("notify")

local wk = require("which-key")
wk.setup(
---@class wk.Opts
	{
		-- preset = "helix",
	delay = 500,
	icons = {
		mappings = true,
		keys = {},
	},
	disable = {
		ft = { "toggleterm", "snacks_input" },
		bt = { "terminal", "prompt" },
	},
})
vim.keymap.set({"n"},
	"<leader>?",
	function()
		require("which-key").show({ global = false })
	end,
	{ desc = "Buffer Local Keymaps (which-key)" }
)
