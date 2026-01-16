return {
	{
		"brianhuster/live-preview.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		cmd = "LivePreview",
		config = function()
			require("livepreview.config").set({
				dynamic_root = true,
			})
		end,
	},
}
