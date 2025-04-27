return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
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

			vim.keymap.set("n", "<leader>ma", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<leader>me", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-j>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-k>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-l>", function()
				harpoon:list():select(4)
			end)
			vim.keymap.set("n", "<C-Left>", function()
				harpoon:list():select(5)
			end)
			vim.keymap.set("n", "<C-Down>", function()
				harpoon:list():select(6)
			end)
			vim.keymap.set("n", "<C-Up>", function()
				harpoon:list():select(7)
			end)
			vim.keymap.set("n", "<C-Right>", function()
				harpoon:list():select(8)
			end)
		end,
	},
	{
		"stevearc/oil.nvim",
		opts = {
			delete_to_trash = true,
		},
		lazy = false,
	},
	{
		"mrjones2014/smart-splits.nvim",
		opts = {},
		config = function()
			vim.keymap.set("n", "<S-Left>", require("smart-splits").resize_left)
			vim.keymap.set("n", "<S-Down>", require("smart-splits").resize_down)
			vim.keymap.set("n", "<S-Up>", require("smart-splits").resize_up)
			vim.keymap.set(
				"n",
				"<S-Right>",
				require("smart-splits").resize_right
			)
			-- moving between splits
			vim.keymap.set(
				"n",
				"<M-h>",
				require("smart-splits").move_cursor_left
			)
			vim.keymap.set(
				"n",
				"<M-j>",
				require("smart-splits").move_cursor_down
			)
			vim.keymap.set("n", "<M-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set(
				"n",
				"<M-l>",
				require("smart-splits").move_cursor_right
			)
		end,
	},
	{
		"hedyhli/outline.nvim",
		opts = {
			relative_width = false,
			keymaps = {
				up_and_jump = "<C-p>",
				down_and_jump = "<C-n>",
			},
		},
		keys = {
			{
				"<leader>lo",
				"<cmd>Outline<cr>",
				desc = "[l]sp [o]utline: Open outline.",
			},
		},
	},
}
