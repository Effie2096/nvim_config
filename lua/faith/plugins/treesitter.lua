return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		dependencies = {
			{
				"romgrk/nvim-treesitter-context",
				opts = function()
					local opts = {
						enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
						multiwindow = true,
						throttle = true, -- Throttles plugin updates (may improve performance)
						max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
						mode = "topline",
						multiline_threshold = 1,
						patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
							-- For all filetypes
							-- Note that setting an entry here replaces all other patterns for this entry.
							-- By setting the 'default' entry below, you can control which nodes you want to
							-- appear in the context window.
							default = {
								"class",
								"function",
								"method",
								"for",
								"while",
								"if",
								"switch",
								"case",
							},
							-- Example for a specific filetype.
							-- If a pattern is missing, *open a PR* so everyone can benefit.
							--	 rust = {
							--		 'impl_item',
							--	 },
						},
						exact_patterns = {
							-- Example for a specific filetype with Lua patterns
							-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
							-- exactly match "impl_item" only)
							-- rust = true,
						},
						-- on_attach = function(bufnr) end,
					}
					return opts
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "main",
				init = function()
					-- Disable entire built-in ftplugin mappings to avoid conflicts.
					-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
					vim.g.no_plugin_maps = true

					-- Or, disable per filetype (add as you like)
					-- vim.g.no_python_maps = true
					-- vim.g.no_ruby_maps = true
					-- vim.g.no_rust_maps = true
					-- vim.g.no_go_maps = true
				end,
				config = function()
					local methods = {
						select = function(capture)
							require("nvim-treesitter-textobjects.select").select_textobject(
								capture,
								"textobjects"
							)
						end,
						swap_next = function(capture)
							require("nvim-treesitter-textobjects.swap").swap_next(capture)
						end,
						swap_prev = function(capture)
							require("nvim-treesitter-textobjects.swap").swap_previous(capture)
						end,
						next_start = function(capture)
							require("nvim-treesitter-textobjects.move").goto_next_start(
								capture,
								"textobjects"
							)
						end,
						next_end = function(capture)
							require("nvim-treesitter-textobjects.move").goto_next_end(
								capture,
								"textobjects"
							)
						end,
						prev_start = function(capture)
							require("nvim-treesitter-textobjects.move").goto_previous_start(
								capture,
								"textobjects"
							)
						end,
						prev_end = function(capture)
							require("nvim-treesitter-textobjects.move").goto_previous_end(
								capture,
								"textobjects"
							)
						end,
					}
					local function objmap(keys, capture, method, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, function()
							methods[method](capture)
						end)
					end

					-- stylua: ignore start
					objmap("af", "@function.outer", "select", { "x", "o" })
					objmap("if", "@function.inner", "select", { "x", "o" })
					objmap("aF", "@class.outer", "select", { "x", "o" })
					objmap("iF", "@class.inner", "select", { "x", "o" })
					objmap("aa", "@parameter.outer", "select", { "x", "o" })
					objmap("ia", "@parameter.inner", "select", { "x", "o" })
					objmap("al", "@loop.outer", "select", { "x", "o" })
					objmap("il", "@loop.inner", "select", { "x", "o" })
					objmap("ac", "@conditional.outer", "select", { "x", "o" })
					objmap("ic", "@conditional.inner", "select", { "x", "o" })
					objmap("ab", "@block.outer", "select", { "x", "o" })
					objmap("ib", "@block.inner", "select", { "x", "o" })
					objmap("ad", "@comment.outer", "select", { "x", "o" })
					objmap("id", "@comment.inner", "select", { "x", "o" })
					objmap("he", "@assignment.lhs", "select", { "x", "o" })
					objmap("le", "@assignment.rhs", "select", { "x", "o" })
					objmap("as", "@statement.outer", "select", { "x", "o" })

					objmap("<leader>sfn", "@function.outer", "swap_next")
					objmap("<leader>san", "@parameter.inner", "swap_next")
					objmap("<leader>sfp", "@function.outer", "swap_prev")
					objmap("<leader>sap", "@parameter.inner", "swap_prev")

					objmap("]m", "@function.outer", "next_start", { "n", "x", "o" })
					objmap("][", "@class.outer","next_start" , { "n", "x", "o" })
					objmap("]b", "@block.outer","next_start" , { "n", "x", "o" })
					objmap("]a", "@parameter.inner", "next_start", { "n", "x", "o" })
					objmap("]M", "@function.outer", "next_end", { "n", "x", "o" })
					objmap("]]", "@class.outer", "next_end", { "n", "x", "o" })
					objmap("]B", "@block.outer", "next_end", { "n", "x", "o" })
					objmap("]A", "@parameter.inner", "next_end", { "n", "x", "o" })
					objmap("[m", "@function.outer", "prev_start", { "n", "x", "o" })
					objmap("[[", "@class.outer", "prev_start", { "n", "x", "o" })
					objmap("[b", "@block.outer", "prev_start", { "n", "x", "o" })
					objmap("[a", "@parameter.inner", "prev_start", { "n", "x", "o" })
					objmap("[M", "@function.outer", "prev_end", { "n", "x", "o" })
					objmap("[]", "@class.outer", "prev_end", { "n", "x", "o" })
					objmap("]B", "@block.outer", "prev_end", { "n", "x", "o" })
					objmap("[A", "@parameter.inner", "prev_end", { "n", "x", "o" })
					-- stylua: ignore end

					require("nvim-treesitter-textobjects").setup({
						select = {
							lookahead = true,
							selection_modes = {
								["@parameter.outer"] = "v",
								["@function.outer"] = "V",
								["@class.outer"] = "V",
								["@loop.inner"] = "V",
							},
							include_surrounding_whitespace = true,
						},
						move = {
							set_jumps = true, -- whether to set jumps in the jumplist
						},
					})
				end,
			},
			{
				"andymass/vim-matchup",
				lazy = false,
				init = function()
					vim.g.matchup_matchparen_offscreen = {
						method = "popup",
						fullwidth = 1,
						syntax_hl = 1,
						border = 0,
					}
					vim.g.matchup_transmute_enabled = 1
					vim.g.matchup_matchparen_deferred = 0
					vim.g.matchup_matchparen_hi_surround_always = 0
				end,
			},
		},
		init = function()
			require("vim.treesitter.query").add_predicate(
				"is-mise?",
				function(_, _, bufnr, _)
					local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
					local filename = vim.fn.fnamemodify(filepath, ":t")
					return string.match(filename, ".*mise.*%.toml$") ~= nil
				end,
				{ force = true, all = false }
			)
			vim.treesitter.language.register("scheme", "kanata")
		end,
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					scope_incremental = "<CR>",
					node_incremental = "<TAB>",
					node_decremental = "<S-TAB>",
				},
			},
			playground = {
				enable = true,
				disable = {},
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = false, -- Whether the query persists across vim sessions
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
			matchup = {
				enable = true,
			},
		},
	},
	{
		"m-demare/hlargs.nvim",
	},
}
