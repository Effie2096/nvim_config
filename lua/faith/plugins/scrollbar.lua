local icons = require("faith.icons")

return {
	{
		"dstein64/nvim-scrollview",
		opts = {
			excluded_filetypes = {
				"neo-tree",
				"blink-cmp-menu",
				"dropbar_menu",
				"dropbar_menu_fzf",
				"DressingInput",
				"cmp_docs",
				"cmp_menu",
				"noice",
				"prompt",
				"TelescopePrompt",
			},
			base = "right",
			current_only = false,
			hide_on_cursor_intersect = true,
			cursor_symbol = "•",
			cursor_priority = 100,
			signs_scrollbar_overlap = "over",
			signs_max_per_row = 1,
			signs_on_startup = {
				"cursor",
				"keywords",
				"marks",
				"search",
				"spell",
			},
			search_symbol = { "-", "=", vim.fn.nr2char(0x2261) },
		},
	},

	{
		"kevinhwang91/nvim-hlslens",
		dependencies = { "kevinhwang91/nvim-ufo" },
		config = function()
			require("hlslens").setup({
				override_lens = function(render, posList, nearest, idx, relIdx)
					local sfw = vim.v.searchforward == 1
					local indicator, text, chunks
					local absRelIdx = math.abs(relIdx)
					if absRelIdx > 1 then
						indicator = ("%d%s"):format(
							absRelIdx,
							sfw ~= (relIdx > 1) and "▲" or "▼"
						)
					elseif absRelIdx == 1 then
						indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
					else
						indicator = ""
					end

					local lnum, col = unpack(posList[idx])
					if nearest then
						local cnt = #posList
						if indicator ~= "" then
							text = ("[%s %d/%d]"):format(indicator, idx, cnt)
						else
							text = ("[%d/%d]"):format(idx, cnt)
						end
						chunks = { { " " }, { text, "HlSearchLensNear" } }
					else
						text = ("[%s %d]"):format(indicator, idx)
						chunks = { { " " }, { text, "HlSearchLens" } }
					end
					render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
				end,
				-- build_position_cb = function(plist, _, _, _)
				-- 	require("scrollbar.handlers.search").handler.show(plist.start_pos)
				-- end,
			})

			local kopts = { noremap = true, silent = true }

			-- vim.api.nvim_set_keymap(
			-- 	"n",
			-- 	"n",
			-- 	[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
			-- 	kopts
			-- )
			-- vim.api.nvim_set_keymap(
			-- 	"n",
			-- 	"N",
			-- 	[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			-- 	kopts
			-- )
			local function nN(char)
				local ok, winid = require("hlslens").nNPeekWithUFO(char)
				if ok and winid then
					-- Safe to override buffer scope keymaps remapped by ufo,
					-- ufo will restore previous buffer keymaps before closing preview window
					-- Type <CR> will switch to preview window and fire `trace` action
					vim.keymap.set("n", "<CR>", function()
						return "<Tab><CR>"
					end, {
						buffer = true,
						remap = true,
						expr = true,
					})
				end
			end

			vim.keymap.set({ "n", "x" }, "n", function()
				nN("n")
			end)
			vim.keymap.set({ "n", "x" }, "N", function()
				nN("N")
			end)

			vim.api.nvim_set_keymap(
				"n",
				"*",
				[[*<Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"#",
				[[#<Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"g*",
				[[g*<Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"g#",
				[[g#<Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
		end,
	},
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {
			-- whether to map keybinds or not. default true
			default_mappings = true,
			-- which builtin marks to show. default {}
			builtin_marks = {
				"^",
				"<",
				">",
				-- "[",
				-- "]",
				-- "'",
				-- "`",
				".",
			},
			-- whether movements cycle back to the beginning/end of buffer. default true
			cyclic = true,
			-- whether the shada file is updated after modifying uppercase marks. default false
			force_write_shada = false,
			-- how often (in ms) to redraw signs/recompute mark positions.
			-- higher values will have better performance but may cause visual lag,
			-- while lower values may cause performance penalties. default 150.
			refresh_interval = 300,
			-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
			-- marks, and bookmarks.
			-- can be either a table with all/none of the keys, or a single number, in which case
			-- the priority applies to all marks.
			-- default 10.
			sign_priority = {
				lower = 10,
				upper = 15,
				builtin = 8,
				bookmark = 20,
			},
			-- disables mark tracking for specific filetypes. default {}
			excluded_filetypes = {},
			-- disables mark tracking for specific buftypes. default {}
			excluded_buftypes = {},
			mappings = {},
		},
	},
}
