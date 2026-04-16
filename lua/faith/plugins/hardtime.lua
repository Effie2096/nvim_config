return {
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			disable_mouse = false,
			restricted_keys = {
				["<Left>"] = { "n", "x" },
				["<Down>"] = { "n", "x" },
				["<Up>"] = { "n", "x" },
				["<Right>"] = { "n", "x" },
			},
			disabled_keys = {
				["<Up>"] = false,
				["<Down>"] = false,
				["<Left>"] = false,
				["<Right>"] = false,
			},
			disabled_filetypes = { "OverseerForm" },
			hints = {
				["[dcyvV][ia][%(%)]"] = {
					message = function(keys)
						return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
					end,
					length = 3,
				},
				["[dcyvV][ia][%{%}]"] = {
					message = function(keys)
						return "Use " .. keys:sub(1, 2) .. "B instead of " .. keys
					end,
					length = 3,
				},
				["ggVG"] = {
					message = function()
						return "Use :% to operate over entire file instead of selecting everything."
					end,
				},
			},
		},
	},
}
