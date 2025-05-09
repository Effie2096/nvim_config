return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		lazy = false,
		dependencies = {
			{
				"romgrk/nvim-treesitter-context",
				opts = {
					enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
					multiwindow = true,
					throttle = true, -- Throttles plugin updates (may improve performance)
					max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
					mode = "topline",
					patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
						-- For all filetypes
						-- Note that setting an entry here replaces all other patterns for this entry.
						-- By setting the 'default' entry below, you can control which nodes you want to
						-- appear in the context window.
						default = {
							"class",
							"function",
							"method",
							"for", -- These won't appear in the context
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
				},
			},
			"nvim-treesitter/nvim-treesitter-textobjects",
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
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["aF"] = "@class.outer",
						-- You can optionally set descriptions to the mappings (used in the desc parameter of
						-- nvim_buf_set_keymap) which plugins like which-key display
						["iF"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["ac"] = "@conditional.outer",
						["ic"] = "@conditional.inner",
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
						["ad"] = "@comment.outer",
						["id"] = "@comment.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "V",
						["@loop.inner"] = "V",
					},
					include_surrounding_whitespace = true,
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>sfn"] = "@function.outer",
						["<leader>san"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>sfp"] = "@function.outer",
						["<leader>sap"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]["] = "@class.outer",
						["]b"] = "@block.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]]"] = "@class.outer",
						["]B"] = "@block.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
						["[b"] = "@block.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
						["]B"] = "@block.outer",
						["[A"] = "@parameter.inner",
					},
				},
				lsp_interop = {
					enable = true,
					border = "single",
					peek_definition_code = {
						["<leader>pf"] = "@function.outer",
						["<leader>pF"] = "@class.outer",
					},
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
}
