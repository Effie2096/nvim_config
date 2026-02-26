return {
	"bgaillard/readonly.nvim",
	lazy = false,
	opts = {
		display_modes = {
			buffer = {
				enabled = true,
			},
		},
		pattern = {
			vim.fn.expand("~") .. "/.ssh/*",
			vim.fn.expand("~") .. "/.keys/*",
			vim.fn.expand("~") .. "/.secrets/*",
		},
	},
}
