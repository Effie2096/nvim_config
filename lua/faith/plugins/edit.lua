return {
	{
		"numToStr/Comment.nvim",
		lazy = false,
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				opts = {
					enable_autocmd = false,
					kanata = { __default = ";; %s", __multiline = "#| %s |#" },
				},
			},
		},
		config = function()
			local tcc = require(
				"ts_context_commentstring.integrations.comment_nvim"
			).create_pre_hook()
			local opts = {
				opleader = {
					line = "gc",
					block = "gb",
				},
				mappings = {
					basic = true,
					extra = true,
				},
				ignore = "^$",
				pre_hook = tcc,
			}
			require("Comment").setup(opts)

			vim.keymap.set(
				{ "n" },
				"g>",
				require("Comment.api").call("comment.linewise", "g@"),
				{ expr = true, desc = "Comment region linewise" }
			)
			vim.keymap.set(
				{ "n" },
				"g>c",
				require("Comment.api").call("comment.linewise.current", "g@$"),
				{ expr = true, desc = "Comment current line" }
			)
			vim.keymap.set(
				{ "n" },
				"g>b",
				require("Comment.api").call("comment.blockwise.current", "g@$"),
				{ expr = true, desc = "Comment current block" }
			)

			vim.keymap.set(
				{ "n" },
				"g<",
				require("Comment.api").call("uncomment.linewise", "g@"),
				{ expr = true, desc = "Uncomment region linewise" }
			)
			vim.keymap.set(
				{ "n" },
				"g<c",
				require("Comment.api").call("uncomment.linewise.current", "g@$"),
				{ expr = true, desc = "Uncomment current line" }
			)
			vim.keymap.set(
				{ "n" },
				"g<b",
				require("Comment.api").call(
					"uncomment.blockwise.current",
					"g@$"
				),
				{ expr = true, desc = "Uncomment current block" }
			)

			local esc =
				vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

			vim.keymap.set({ "x" }, "g>", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				require("Comment.api").locked("comment.linewise")(
					vim.fn.visualmode()
				)
			end, { desc = "Comment region linewise (visual)" })

			vim.keymap.set({ "x" }, "g<", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				require("Comment.api").locked("uncomment.linewise")(
					vim.fn.visualmode()
				)
			end, { desc = "Uncomment region linewise (visual)" })
		end,
	},
	{
		"folke/todo-comments.nvim",
		-- cmd = { "TodoQuickfix", "TodoTelescope" },
		opts = {
			sign_priority = 15,
		},
	},
	{
		"kylechui/nvim-surround",
		opts = {
			hightlight = {
				duration = 40,
			},
		},
	},
	{
		"nat-418/boole.nvim",
		opts = {
			mappings = {
				increment = "<C-a>",
				decrement = "<C-x>",
			},
		},
	},
	"tpope/vim-repeat",
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			prompt_func_return_type = {
				go = false,
				java = true,
				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			prompt_func_param_type = {
				go = false,
				java = true,
				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			printf_statements = {},
			print_var_statements = {},
			show_success_message = false,
		},
		config = function()
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { desc = desc })
			end

			-- Remaps for the refactoring operations currently offered by the plugin
			map("<leader>rr", function()
				require("telescope").extensions.refactoring.refactors()
			end, "[r]efactor [r]efactors: List refactors.", { "n", "x" })
			map(
				"<leader>re",
				"<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>",
				"[r]efactor [e]xtract: Extract selection to new function.",
				{ "v" }
			)
			map(
				"<leader>rf",
				[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
				"[r]efactor to [f]ile: Extract selection to new function in new file.",
				{ "v" }
			)
			map(
				"<leader>rv",
				[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
				"[r]efactor [v]ariable: Extract selected variable.",
				{ "v" }
			)
			map(
				"<leader>ri",
				[[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
				"[r]efactor [i]nline: Inline selected variable.",
				{ "v" }
			)

			-- Extract block doesn't need visual mode
			map(
				"<leader>rb",
				[[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
				"[r]efactor [b]lock: Extract surrounding block to new function.",
				{ "n" }
			)
			map(
				"<leader>rbf",
				[[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
				"[r]efactor [b]lock to [f]ile: Extract surrounding block to new function in new file.",
				{ "n" }
			)

			-- Inline variable can also pick up the identifier currently under the cursor without visual mode
			map(
				"<leader>ri",
				[[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
				"[r]efactor [i]nline: Inline variable under cursor.",
				{ "n" }
			)
			-- You can also use below = true here to to change the position of the printf
			-- statement (or set two remaps for either one). This remap must be made in normal mode.
			map(
				"<leader>rpo",
				"<cmd>lua require('refactoring').debug.printf({below = true})<CR>",
				"[r]efactor [p]rint [o]utline: Create print statement outlining current location in file.",
				{ "n" }
			)

			-- Print var

			-- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
			map(
				"<leader>rpv",
				"<cmd>lua require('refactoring').debug.print_var({ normal = true })<CR>",
				"[r]efactor [p]rint [v]ariable: Create print statement for variable under cursor.",
				{ "n" }
			)
			-- Remap in visual mode will print whatever is in the visual selection
			map(
				"<leader>rpv",
				"<cmd>lua require('refactoring').debug.print_var({})<CR>",
				"[r]efactor [p]rint [v]ariable: Create print statement for first variable/function in selection.",
				{ "v" }
			)

			-- Cleanup function: this remap should be made in normal mode
			map(
				"<leader>rpc",
				"<cmd>lua require('refactoring').debug.cleanup({})<CR>",
				"[r]efactor [p]rint [c]leanup: Automated cleanup of all print statements generated by refactor binds.",
				{ "n" }
			)
		end,
	},
	"tpope/vim-abolish",
	{
		ft = { "markdown", "text", "gitcommit" },
		"bullets-vim/bullets.vim",
		init = function()
			vim.g.bullets_enabled_file_types =
				{ "markdown", "text", "gitcommit" }
			vim.g.bullets_enable_in_empty_buffers = 0 -- default = 1

			local opts = { silent = true }
		end,
	},
	{
		"nmac427/guess-indent.nvim",
		opts = {},
	},
	-- {
	-- 	"romgrk/equal.operator",
	-- 	init = function()
	-- 		vim.g.equal_operator_default_mappings = 0

	--      local opts = { silent = true }

	-- 		-- vim.keymap.set("o", "il", "<Plug>(operator-rhs)")
	-- 		vim.keymap.set("o", "ihe", "<Plug>(operator-lhs)")
	-- 		-- vim.keymap.set("o", "al", "<Plug>(operator-Rhs)")
	-- 		vim.keymap.set("o", "ahe", "<Plug>(operator-Lhs)")

	-- 		-- vim.keymap.set("x", "il", "<Plug>(visual-rhs)")
	-- 		vim.keymap.set("x", "ihe", "<Plug>(visual-lhs)")
	-- 		-- vim.keymap.set("x", "al", "<Plug>(visual-Rhs)")
	-- 		vim.keymap.set("x", "ahe", "<Plug>(visual-Lhs)")
	-- 	end,
	-- },
}
