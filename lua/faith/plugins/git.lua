return {
	{
		"tpope/vim-fugitive",
		keys = {
			{
				"<leader>gs",
				"<CMD>G<CR>",
				desc = "[g]it [s]tatus: Open git status window.",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = function()
			vim.api.nvim_create_user_command("GitSignsToggleAll", function()
				-- gitsign.toggle_linehl()
				require("gitsigns").preview_hunk_inline()
				-- vim.wait(200, function () end)
				vim.defer_fn(function()
					-- gitsign.toggle_numhl()
					require("gitsigns").toggle_word_diff()
					-- gitsign.toggle_current_line_blame()
				end, 100)
			end, {})

			local opts = {
				signs = {
					add = { text = require("faith.icons").git.signs.add },
					change = {
						text = require("faith.icons").git.signs.mod,
					},
					delete = {
						text = require("faith.icons").git.signs.delete,
					},
					topdelete = {
						text = require("faith.icons").git.signs.top_delete,
					},
					changedelete = {
						text = require("faith.icons").git.signs.change_delete,
					},
					untracked = {
						text = require("faith.icons").git.signs.untracked,
					},
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary> ",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000,
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end
					-- Navigation
					map("n", "]h", function()
						if vim.wo.diff then
							return "]h"
						end
						vim.schedule(function()
							gs.next_hunk()
							vim.cmd("normal! zz")
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[h", function()
						if vim.wo.diff then
							return "[h"
						end
						vim.schedule(function()
							gs.prev_hunk()
							vim.cmd("normal! zz")
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map("n", "<leader>hs", gs.stage_hunk)
					map("n", "<leader>hr", gs.reset_hunk)
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					-- map('n', '<leader>hS', gs.stage_buffer)
					map("n", "<leader>hu", gs.undo_stage_hunk)
					-- map('n', '<leader>hR', gs.reset_buffer)
					map("n", "<leader>hp", gs.preview_hunk)
					-- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
					-- map('n', '<leader>tb', gs.toggle_current_line_blame)
					map("n", "<leader>gd", gs.diffthis)
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end)
					-- map('n', '<leader>td', gs.toggle_deleted)
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			}

			return opts
		end,
	},
	"akinsho/git-conflict.nvim",
	{
		"mbbill/undotree",

		keys = {
			{
				"<leader>u",
				vim.cmd.UndotreeToggle,
				desc = "[u]ndo tree: Open undo history for current file.",
			},
		},

		init = function()
			vim.g.undotree_WindowLayout = 3
			vim.g.undotree_SplitWidth = 70
			vim.g.undotree_DiffpanelHeight = 20
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_Helpline = 0

			vim.g.undotree_DiffCommand = "git diff"
		end,
	},
	{
		"sindrets/diffview.nvim",
		opts = {},
	},
}
