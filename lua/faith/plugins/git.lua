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
				require("gitsigns").toggle_linehl()
				-- require("gitsigns").preview_hunk_inline()
				vim.defer_fn(function()
					require("gitsigns").toggle_numhl()
					require("gitsigns").toggle_word_diff()
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
						show_count = true,
					},
					topdelete = {
						text = require("faith.icons").git.signs.top_delete,
					},
					changedelete = {
						text = require("faith.icons").git.signs.change_delete,
						show_count = true,
					},
					untracked = {
						text = require("faith.icons").git.signs.untracked,
					},
				},
				signs_staged = {
					add = { text = require("faith.icons").git.signs.add },
					change = {
						text = require("faith.icons").git.signs.mod,
					},
					delete = {
						text = require("faith.icons").git.signs.delete,
						show_count = true,
					},
					topdelete = {
						text = require("faith.icons").git.signs.top_delete,
					},
					changedelete = {
						text = require("faith.icons").git.signs.change_delete,
						show_count = true,
					},
					untracked = {
						text = require("faith.icons").git.signs.untracked,
					},
				},
				count_chars = {
					"₁",
					"₂",
					"₃",
					"₄",
					"₅",
					"₆",
					"₇",
					"₈",
					"₉",
					["+"] = ">",
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
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
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
							vim.cmd.normal({ "]c", bang = true })
						else
							gs.nav_hunk("next")
							vim.cmd("normal! zz")
						end
					end, { desc = "Next hunk" })

					map("n", "[h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gs.nav_hunk("prev")
							vim.cmd("normal! zz")
						end
					end, { desc = "Previous hunk" })

					-- Actions
					map(
						"n",
						"<leader>hs",
						gs.stage_hunk,
						{ desc = "[h]unk [s]tage" }
					)
					map(
						"n",
						"<leader>hr",
						gs.reset_hunk,
						{ desc = "[h]unk [r]eset" }
					)
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[h]unk [s]tage" })
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[h]unk [r]eset" })
					map(
						"n",
						"<leader>hS",
						gs.stage_buffer,
						{ desc = "[h]unk [S]tage buffer" }
					)
					map(
						"n",
						"<leader>hu",
						gs.undo_stage_hunk,
						{ desc = "[h]unk [u]ndo" }
					)
					map(
						"n",
						"<leader>hR",
						gs.reset_buffer,
						{ desc = "[h]unk [R]eset buffer" }
					)
					map(
						"n",
						"<leader>hp",
						gs.preview_hunk,
						{ desc = "[h]unk [p]review" }
					)
					map(
						"n",
						"<leader>hi",
						gs.preview_hunk_inline,
						{ desc = "[h]unk [i]nline" }
					)
					-- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
					-- map('n', '<leader>tb', gs.toggle_current_line_blame)
					map(
						"n",
						"<leader>gd",
						gs.diffthis,
						{ desc = "[g]it [d]iff" }
					)
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end, { desc = "[g]it [D]iff upstream" })
					-- map('n', '<leader>td', gs.toggle_deleted)
					map({ "o", "x" }, "ih", gs.select_hunk)
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
