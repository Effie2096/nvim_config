return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			bufdelete = { enable = true },
			dashboard = { enabled = false },
			explorer = { enabled = false },
			indent = { enabled = false },
			input = { enabled = true },
			picker = { enabled = false },
			notifier = { enabled = false },
			quickfile = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },
			toggle = { enables = true },
			scratch = {
				filekey = {
					cwd = true, -- use current working directory
					branch = false, -- use current branch name
					count = true, -- use vim.v.count1
				},
			},
			styles = {
				input = {
					relative = "editor",
				},
				zoom_indicator = {
					text = " ",
					minimal = true,
					enter = false,
					focusable = false,
					height = 1,
					row = 0,
					col = function()
						return math.floor((vim.opt.columns:get() - 1) / 2)
					end,
					backdrop = false,
				},
				scratch = {
					ft = "markdown",
					-- position = "right",
					-- width = function()
					-- 	local width = math.floor((vim.opt.columns:get() * 0.35))
					-- 	return width < 50 and 50 or width
					-- end,
					-- height = function()
					-- 	local height = math.floor((vim.opt.lines:get() * 0.3))
					-- 	return height < 10 and 10 or height
					-- end,
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle
						.option("relativenumber", { name = "Relative Number" })
						:map("<leader>ul")
					Snacks.toggle
						.option("background", {
							off = "light",
							on = "dark",
							name = "Dark Background",
						})
						:map("<leader>ub")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle
						.option("conceallevel", {
							off = 0,
							on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
						})
						:map("<leader>uc")
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions[1].type == "move" then
						Snacks.rename.on_rename_file(
							event.data.actions[1].src_url,
							event.data.actions[1].dest_url
						)
					end
				end,
			})
		end,
		keys = {
			{
				"<leader>s.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>sn",
				function()
					vim.ui.input({
						prompt = "Filetype: ",
						default = (vim.bo.buftype == "" and vim.bo.filetype ~= "")
								and vim.bo.filetype
							or "markdown",
					}, function(input)
						if input then
							Snacks.scratch({ ft = input })
						else
							Snacks.scratch()
						end
					end)
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<leader>bc",
				function()
					Snacks.bufdelete.delete()
				end,
				desc = "[b]uffer [c]lose: Delete current buffer without closing window.",
			},
		},
	},
}
