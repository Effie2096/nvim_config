return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "plenary.nvim" },
		config = function()
			local Path = require("plenary.path")
			local harpoon = require("harpoon")
			harpoon:setup()

			local add_to_tab = function(name)
				name = name
					or Path:new(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
						:make_relative()
				return {
					value = name,
					context = { tab = vim.fn.tabpagenr() },
				}
			end

			local harpoon_tab_setup = function(tab_name, items)
				harpoon:setup({
					[tab_name] = {
						add = function(possible_value)
							return add_to_tab(possible_value)
						end,
					},
				})
				harpoon:list(tab_name).name = tab_name
				harpoon:list(tab_name).items = items or {}
			end

			local new_tab = function(index)
				local tabs = vim.fn.tabpagenr("$")
				local new_tab = index

				local tab_name = ("tab%d"):format(new_tab)
				if harpoon:list(tab_name) then
					-- if harpoon:list(tab_name).items then
					local x = tabs - new_tab
					for i = tabs, (tabs - x) + 1, -1 do
						local current_tab_name = ("tab%d"):format(i)
						local previous_list = harpoon:list(("tab%d"):format(i - 1))

						harpoon_tab_setup(current_tab_name, previous_list.items)
					end
					-- end
				end
				harpoon_tab_setup(("tab%d"):format(new_tab), {})
			end

			local tab_closed = function(index)
				-- tab has been closed, shift all tab data from current down
				local last_tab = vim.fn.tabpagenr("$")

				for i = index, last_tab + 1 do
					local tab_name = ("tab%d"):format(i)

					if harpoon:list(tab_name) then
						harpoon:list(tab_name).items = harpoon:list(("tab%d"):format(i + 1)).items
							or {}
					end
				end
				harpoon:list(("tab%d"):format(last_tab)):clear()
			end

			local tab_move = function(count)
				local start_tab = vim.fn.tabpagenr()
				local last_tab = vim.fn.tabpagenr("$")

				if count == start_tab or (count == 0 and (start_tab == last_tab)) then
					return
				end

				if count > start_tab and count > last_tab then
					count = last_tab
				elseif count == 0 then
					-- no count given, just move one to right
					count = start_tab + 1
				elseif count < start_tab and count < 1 then
					count = 0
				end

				local start_tab_name = ("tab%d"):format(start_tab)
				local start_data = harpoon:list(start_tab_name).items

				vim.cmd.tabmove({ args = { count } })

				if start_tab > count then
					for i = start_tab, count + 1, -1 do
						local current_tab_name = ("tab%d"):format(i)
						local previous_list = harpoon:list(("tab%d"):format(i - 1)).items

						harpoon_tab_setup(current_tab_name, previous_list)
					end

					harpoon_tab_setup(("tab%d"):format(count + 1), start_data)
				else
					for i = start_tab, count - 1 do
						local current_tab_name = ("tab%d"):format(i)
						local previous_list = harpoon:list(("tab%d"):format(i + 1)).items

						harpoon_tab_setup(current_tab_name, previous_list)
					end

					harpoon_tab_setup(("tab%d"):format(count), start_data)
				end
			end

			vim.keymap.set("n", "<leader>ttm", function()
				tab_move(vim.v.count)
			end, { desc = "[t]ab [m]ove: Move current tab" })

			vim.api.nvim_create_autocmd("TabClosed", {
				callback = function(args)
					tab_closed(args.file)
				end,
			})

			vim.api.nvim_create_autocmd("TabNew", {
				callback = function(args)
					new_tab(vim.fn.tabpagenr())
				end,
			})

			local harpoon_extensions = require("harpoon.extensions")
			harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
			harpoon:extend({
				UI_CREATE = function(cx)
					vim.keymap.set("n", "<C-v>", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-x>", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-t>", function()
						harpoon.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr })
				end,
			})
		end,
		keys = {
			{
				"<leader>Ha",
				function()
					require("harpoon"):list(("tab%d"):format(vim.fn.tabpagenr())):add()
				end,
				desc = "[H]arpoon [a]dd: Add harpoon.",
				{ "n" },
			},
			{
				"<leader>He",
				function()
					require("harpoon").ui:toggle_quick_menu(
						require("harpoon"):list(("tab%d"):format(vim.fn.tabpagenr()))
					)
				end,
				desc = "[H]arpoon [e]dit: Edit harpoons.",
				{ "n" },
			},
			{
				"<M-m>",
				function()
					require("harpoon")
						:list(("tab%d"):format(vim.fn.tabpagenr()))
						:select(1)
				end,
				{ "n" },
			},
			{
				"<M-n>",
				function()
					require("harpoon")
						:list(("tab%d"):format(vim.fn.tabpagenr()))
						:select(2)
				end,
				{ "n" },
			},
			{
				"<M-e>",
				function()
					require("harpoon")
						:list(("tab%d"):format(vim.fn.tabpagenr()))
						:select(3)
				end,
				{ "n" },
			},
			{
				"<M-i>",
				function()
					require("harpoon")
						:list(("tab%d"):format(vim.fn.tabpagenr()))
						:select(4)
				end,
				{ "n" },
			},
			{
				"<M-a>",
				function()
					require("harpoon")
						:list(("tab%d"):format(vim.fn.tabpagenr()))
						:select(5)
				end,
				{ "n" },
			},
			{
				"<M-;>",
				function()
					require("harpoon")
						:list(("tab%d"):format(vim.fn.tabpagenr()))
						:select(6)
				end,
				{ "n" },
			},
		},
	},
}
