require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

local has_which_key, which_key = pcall(require, "which-key")
if has_which_key then
	which_key.setup(
		---@class wk.Opts
		{
			-- preset = "helix",
			delay = 0,
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
