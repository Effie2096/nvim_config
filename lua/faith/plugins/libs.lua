local has_notify, notify = pcall(require, "notify")
if has_notify then
	notify.setup({
		render = "wrapped-compact",
		fps = 60,
		top_down = false,
	})
	vim.notify = require("notify")
end

local has_which_key, which_key = pcall(require, "which-key")
if has_which_key then
	which_key.setup(
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
		}
	)
	vim.keymap.set({ "n" }, "<leader>?", function()
		require("which-key").show({ global = false })
	end, { desc = "Buffer Local Keymaps (which-key)" })
end
