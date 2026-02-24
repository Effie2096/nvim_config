local aerial_maps = {
	{
		lhs = "<leader>lo",
		rhs = function()
			if require("aerial").is_open() then
				require("aerial").close()
			else
				require("aerial").open({ focus = false, direction = "right" })
			end
		end,
		mode = "n",
		opts = { desc = "[l]sp [o]utline: Open outline window." },
	},
	{
		lhs = "<leader>lO",
		rhs = function()
			if
				require("aerial").is_open({
					bufnr = vim.api.nvim_get_current_buf(),
					winid = vim.api.nvim_get_current_win(),
				})
			then
				require("aerial").focus()
			else
				require("aerial").open({ focus = true, direction = "right" })
			end
		end,
		mode = "n",
		opts = { desc = "focus [O]utline: Focus outline window." },
	},
}

return {
	{
		"stevearc/aerial.nvim",
		cmd = {
			"AerialToggle",
			"AerialOpen",
			"AerialOpenAll",
			"AerialClose",
			"AerialCloseAll",
			"AerialNext",
			"AerialPrev",
			"AerialGo",
			"AerialInfo",
			"AerialNavToggle",
			"AerialNavOpen",
			"AerialNavClose",
		},
		keys = vim
			.iter(vim.deepcopy(aerial_maps))
			:map(function(map)
				return { map.lhs }
			end)
			:fold({}, function(acc, map)
				table.insert(acc, map)
				return acc
			end),
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"onsails/lspkind.nvim",
		},
		opts = function()
			local opts = {
				attach_mode = "global",
				show_guides = true,
				layout = {
					max_width = 40,
					min_width = 40,
					resize_to_content = true,
					width = 40,
					default_direction = "right",
					placement = "edge",
				},
				highlight_on_hover = true,
			}

			vim.iter(aerial_maps):each(function(map)
				vim.keymap.set(map.mode, map.lhs, map.rhs, map.opts)
			end)
			return opts
		end,
	},
}
