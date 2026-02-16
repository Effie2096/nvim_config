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
			local tcc =
				require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
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
				require("Comment.api").call("uncomment.blockwise.current", "g@$"),
				{ expr = true, desc = "Uncomment current block" }
			)

			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

			vim.keymap.set({ "x" }, "g>", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				require("Comment.api").locked("comment.linewise")(vim.fn.visualmode())
			end, { desc = "Comment region linewise (visual)" })

			vim.keymap.set({ "x" }, "g<", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				require("Comment.api").locked("uncomment.linewise")(vim.fn.visualmode())
			end, { desc = "Uncomment region linewise (visual)" })
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {
			hightlight = {
				duration = 40,
			},
		},
	},
	{
		"monaqa/dial.nvim",
		keys = {
			-- stylua: ignore start
			{ "<C-a>",function() require("dial.map").manipulate("increment", "normal") end, {"n"} },
			{ "<C-x>",function() require("dial.map").manipulate("decrement", "normal") end, {"n"} },
			{ "g<C-a>",function() require("dial.map").manipulate("increment", "gnormal") end, {"n"} },
			{ "g<C-x>",function() require("dial.map").manipulate("decrement", "gnormal") end, {"n"} },
			{ "<C-a>",function() require("dial.map").manipulate("increment", "visual") end, {"x"} },
			{ "<C-x>",function() require("dial.map").manipulate("decrement", "visual") end, {"x"} },
			{ "g<C-a>",function() require("dial.map").manipulate("increment", "gvisual") end, {"x"} },
			{ "g<C-x>",function() require("dial.map").manipulate("decrement", "gvisual") end, {"x"} },
			-- stylua: ignore end
		},
	},
	"tpope/vim-repeat",
	{
		"ThePrimeagen/refactoring.nvim",
		cmd = "Refactor",
		-- branch = "develop",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
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
			show_success_message = true,
		},
		keys = {
			{
				"<leader>rr",
				function()
					return require("telescope").extensions.refactoring.refactors()
				end,
				{ "n", "x" },
				desc = "[r]efactor [r]efactors: List refactors.",
				expr = true,
			},
			{
				"<leader>ref",
				function()
					return require("refactoring").refactor("Extract Function")
				end,
				desc = "[r]efactor [e]xtract [f]unction: Extract selection to new function.",
				expr = true,
			},
			{
				"<leader>reF",
				function()
					return require("refactoring").refactor("Extract Function To File")
				end,
				desc = "[r]efactor [e]xtract to [f]ile: Extract selection to new function in new file.",
				expr = true,
			},
			{
				"<leader>rev",
				function()
					return require("refactoring").refactor("Extract Variable")
				end,
				desc = "[r]efactor [e]xtract [v]ariable: Extract selected variable.",
				expr = true,
			},
			{
				"<leader>riv",
				function()
					return require("refactoring").refactor("Inline Variable")
				end,
				desc = "[r]efactor [i]nline [v]ariable: Inline selected variable.",
				expr = true,
			},
			{
				"<leader>rif",
				function()
					return require("refactoring").refactor("Inline Function")
				end,
				desc = "[r]efactor [i]line [f]unction: Inline selected function call.",
				expr = true,
			},

			{
				"<leader>rb",
				function()
					return require("refactoring").refactor("Extract Block")
				end,
				desc = "[r]efactor [e]xtract [b]lock: Extract selection to new block.",
				expr = true,
			},
			{
				"<leader>reB",
				function()
					return require("refactoring").refactor("Extract Block To File")
				end,
				{ "n", "x" },
				desc = "[r]efactor [e]xtract [B]lock to file: Extract selection to new block in new file.",
				expr = true,
			},

			-- You can also use below = true here to to change the position of the printf
			-- statement (or set two remaps for either one). This remap must be made in normal mode.
			{
				"<leader>rpo",
				function()
					require("refactoring").debug.printf({ below = true })
				end,
				{ "n" },
				desc = "[r]efactor [p]rint [o]utline: Create print statement outlining current location in file.",
				expr = true,
			},

			-- Print var

			-- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
			{
				"<leader>rpv",
				function()
					require("refactoring").debug.print_var({})
				end,
				{ "n", "x" },

				desc = "[r]efactor [p]rint [v]ariable: Create print statement for variable.",
				expr = true,
			},

			-- Cleanup function: this remap should be made in normal mode
			{
				"<leader>rpc",
				function()
					require("refactoring").debug.cleanup({})
				end,
				{ "n" },
				desc = "[r]efactor [p]rint [c]leanup: Automated cleanup of all print statements generated by refactor binds.",
				expr = true,
			},
		},
	},
	"tpope/vim-abolish",
	{
		ft = { "markdown", "text", "gitcommit" },
		"bullets-vim/bullets.vim",
		init = function()
			vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
			vim.g.bullets_enable_in_empty_buffers = 0 -- default = 1

			local opts = { silent = true }
		end,
	},
	{
		"nmac427/guess-indent.nvim",
		event = "VeryLazy",
		opts = {
			on_tab_options = {
				["expandtab"] = false,
			},
			on_space_options = {
				["expandtab"] = true,
				["tabstop"] = "detected",
				["softtabstop"] = "detected",
				["shiftwidth"] = "detected",
			},
		},
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
