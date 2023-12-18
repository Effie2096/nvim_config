-- local colors = require'catppuccin.palettes'.get_palette()
local status_ok, ts_conf = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

ts_conf.setup({
	ensure_installed = { "lua", "vim" },
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
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
				["av"] = "@parameter.outer",
				["iv"] = "@parameter.inner",
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
				["<leader>svn"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>sfp"] = "@function.outer",
				["<leader>svp"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]["] = "@class.outer",
				["]b"] = "@block.outer",
				["]v"] = "@parameter.inner",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]]"] = "@class.outer",
				["]B"] = "@block.outer",
				["]V"] = "@parameter.inner",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
				["[b"] = "@block.outer",
				["[v"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
				["]B"] = "@block.outer",
				["[V"] = "@parameter.inner",
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
})
