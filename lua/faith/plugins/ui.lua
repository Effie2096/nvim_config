local icons = require("faith.icons")

return {
	{
		"lukas-reineke/indent-blankline.nvim",
		name = "ibl",
		config = function()
			local highlight = {
				"RainbowGreen",
				"RainbowBlue",
				"RainbowCyan",
				"RainbowViolet",
				"RainbowYellow",
				"RainbowOrange",
				"RainbowRed",
			}
			local ibl = require("ibl")
			local mocha = require("catppuccin.palettes").get_palette("mocha")
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = mocha.red })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = mocha.peach })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = mocha.sapphire })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = mocha.yellow })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = mocha.green })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = mocha.mauve })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = mocha.teal })

			ibl.setup({
				indent = {
					char = icons.characters.indent,
					smart_indent_cap = true,
					repeat_linebreak = true,
					highlight = highlight,
				},
				scope = {
					enabled = true,
					show_start = true,
					show_end = true,
					char = icons.characters.indent_focus,
				},
			})
		end,
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local statuscol = require("statuscol")
			statuscol.setup({
				setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
				-- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
				-- Although I recommend just using the segments field below to build your
				-- statuscolumn to benefit from the performance optimizations in this plugin.
				-- builtin.lnumfunc number string options
				ft_ignore = {
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_console",
					"dapui_stacks",
					"dapui_scopes",
					"dap-repl",
					"lazy",
					"trouble",
					"toggleterm",
					"OverseerList",
					"undotree",
					"Outline",
					"neo-tree",
				},
				bt_ignore = { "terminal" },
				thousands = false, -- or line number thousands separator string ("." / ",")
				relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
				-- Builtin 'statuscolumn' options
				-- Default segments (fold -> sign -> line number + separator), explained below
				segments = {
					{
						text = { require("statuscol.builtin").foldfunc },
						click = "v:lua.ScFa",
					},
					{
						sign = {
							name = { ".*" },
							maxwidth = 4,
							colwidth = 0,
							auto = true,
							wrap = false,
						},
						click = "v:lua.ScSa",
					},
					{
						sign = {
							namespace = { "diagnostic.signs" },
							maxwidth = 2,
							colwidth = 1,
							auto = false,
							foldclosed = true,
						},
						click = "v:lua.ScSa",
					},
					{
						sign = {
							name = { "Dap" },
							maxwidth = 1,
							colwidth = 0,
							auto = true,
						},
					},
					{
						text = { require("statuscol.builtin").lnumfunc, " " },
						condition = {
							true,
							require("statuscol.builtin").not_empty,
						},
						click = "v:lua.ScLa",
					},
					{
						sign = {
							namespace = { "gitsigns" },
							maxwidth = 1,
							colwidth = 1,
							fillchar = icons.git.signs.add,
							fillcharhl = "WinSeparator",
							auto = false,
						},
					},
				},
				clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
				-- "a" for Alt, "c" for Ctrl and "m" for Meta.
				clickhandlers = { -- builtin click handlers
					Lnum = require("statuscol.builtin").lnum_click,
					FoldClose = require("statuscol.builtin").foldclose_click,
					FoldOpen = require("statuscol.builtin").foldopen_click,
					FoldOther = require("statuscol.builtin").foldother_click,
					DapBreakpointRejected = require("statuscol.builtin").toggle_breakpoint,
					DapBreakpoint = require("statuscol.builtin").toggle_breakpoint,
					DapBreakpointCondition = require("statuscol.builtin").toggle_breakpoint,
					["diagnostic/signs"] = require("statuscol.builtin").diagnostic_click,
					GitSignsTopdelete = require("statuscol.builtin").gitsigns_click,
					GitSignsUntracked = require("statuscol.builtin").gitsigns_click,
					GitSignsAdd = require("statuscol.builtin").gitsigns_click,
					GitSignsChange = require("statuscol.builtin").gitsigns_click,
					GitSignsChangedelete = require("statuscol.builtin").gitsigns_click,
					GitSignsDelete = require("statuscol.builtin").gitsigns_click,
					gitsigns_extmark_signs_ = require("statuscol.builtin").gitsigns_click,
				},
			})
		end,
	},
	{
		"m4xshen/smartcolumn.nvim",
		opts = {
			colorcolumn = vim.api.nvim_get_option_value(
				"colorcolumn",
				{ scope = "global" }
			),
		},
	},
	{
		"kevinhwang91/nvim-bqf",
		config = function()
			local opts = {
				auto_enable = true,
				auto_resize_height = true, -- highly recommended enable
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border = {
						icons.borders.square_thick.top_left,
						icons.borders.square_thick.top,
						icons.borders.square_thick.top_right,
						icons.borders.square_thick.right,
						icons.borders.square_thick.bottom_right,
						icons.borders.square_thick.bottom,
						icons.borders.square_thick.bottom_left,
						icons.borders.square_thick.left,
					},
					-- border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
					show_title = false,
					should_preview_cb = function(
						bufnr,
						_ --[[ qwinid ]]
					)
						local ret = true
						local bufname = vim.api.nvim_buf_get_name(bufnr)
						local fsize = vim.fn.getfsize(bufname)
						if fsize > 100 * 1024 then
							-- skip file size greater than 100k
							ret = false
						elseif bufname:match("^fugitive://") then
							-- skip fugitive buffer
							ret = false
						end
						return ret
					end,
				},
				-- make `drop` and `tab drop` to become preferred
				func_map = {
					drop = "o",
					openc = "O",
					split = "<C-s>",
					tabdrop = "<C-t>",
					-- set to empty string to disable
					tabc = "",
					ptogglemode = "z,",
				},
			}

			local fn = vim.fn

			function _G.qftf(info)
				local items
				local ret = {}
				-- The name of item in list is based on the directory of quickfix window.
				-- Change the directory for quickfix window make the name of item shorter.
				-- It's a good opportunity to change current directory in quickfixtextfunc :)
				--
				-- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
				-- local root = getRootByAlterBufnr(alterBufnr)
				-- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
				--
				if info.quickfix == 1 then
					items = fn.getqflist({ id = info.id, items = 0 }).items
				else
					items = fn.getloclist(
						info.winid,
						{ id = info.id, items = 0 }
					).items
				end
				local limit = 31
				local fnameFmt1, fnameFmt2 =
					"%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
				local validFmt = "%s │%5d:%-3d│%s %s"
				for i = info.start_idx, info.end_idx do
					local e = items[i]
					local fname = ""
					local str
					if e.valid == 1 then
						if e.bufnr > 0 then
							fname = fn.bufname(e.bufnr)
							if fname == "" then
								fname = "[No Name]"
							else
								fname = fname:gsub("^" .. vim.env.HOME, "~")
							end
							-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
							if #fname <= limit then
								fname = fnameFmt1:format(fname)
							else
								fname = fnameFmt2:format(fname:sub(1 - limit))
							end
						end
						local lnum = e.lnum > 99999 and -1 or e.lnum
						local col = e.col > 999 and -1 or e.col
						local qtype = e.type == "" and ""
							or " " .. e.type:sub(1, 1):upper()
						str = validFmt:format(fname, lnum, col, qtype, e.text)
					else
						str = e.text
					end
					table.insert(ret, str)
				end
				return ret
			end

			vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

			-- Adapt fzf's delimiter in nvim-bqf
			require("bqf").setup({
				filter = {
					fzf = {
						extra_opts = {
							"--bind",
							"ctrl-o:toggle-all",
							"--delimiter",
							"│",
						},
					},
				},
			})
			return opts
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		init = function()
			-- needs to be high for ufo
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99

			vim.opt.foldopen:remove("hor") -- don't open folds when moving on the line
			vim.opt.foldcolumn = "1"
			vim.opt.fillchars:append({
				foldopen = icons.ui.ArrowOpen,
				foldsep = " ",
				foldclose = icons.ui.ArrowClosed,
			})
			vim.opt.foldnestmax = 1
			vim.opt.foldenable = true
		end,
		config = function()
			local ufo = require("ufo")

			local ftMap = {
				markdown = { "treesitter", "indent" },
			}

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}

				local suffix = (
					" "
					.. require("faith.icons").ui.FoldSuffix
					.. "%d "
				):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)

				local targetWidth = width - sufWidth

				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)

					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)

						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix
								.. (" "):rep(
									targetWidth - curWidth - chunkWidth
								)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			local function goPreviousClosedAndPeek()
				require("ufo").goPreviousClosedFold()
				require("ufo").peekFoldedLinesUnderCursor()
			end

			local function goNextClosedAndPeek()
				require("ufo").goNextClosedFold()
				require("ufo").peekFoldedLinesUnderCursor()
			end

			local opts = { noremap = true, silent = true }
			vim.keymap.set(
				{ "n" },
				"zR",
				require("ufo").openAllFolds,
				vim.tbl_extend("force", opts, { desc = "fold [R]educe all" })
			)
			vim.keymap.set(
				{ "n" },
				"zM",
				require("ufo").closeAllFolds,
				vim.tbl_extend("force", opts, { desc = "fold [M]ax" })
			)
			vim.keymap.set(
				{ "n" },
				"zr",
				require("ufo").openFoldsExceptKinds,
				vim.tbl_extend("force", opts, { desc = "fold [r]educe" })
			)
			vim.keymap.set(
				{ "n" },
				"zm",
				require("ufo").closeFoldsWith,
				vim.tbl_extend("force", opts, { desc = "fold [m]ore" })
			) -- closeAllFolds == closeFoldsWith(0)
			vim.keymap.set(
				{ "n" },
				"zj",
				goNextClosedAndPeek,
				vim.tbl_extend("force", opts, { desc = "fold next" })
			)
			vim.keymap.set(
				{ "n" },
				"zk",
				goPreviousClosedAndPeek,
				vim.tbl_extend("force", opts, { desc = "fold previous" })
			)

			ufo.setup({
				open_fold_hl_timeout = 100,
				preview = {
					win_config = {
						border = {
							"",
							icons.borders.square.top,
							"",
							"",
							"",
							icons.borders.square.bottom,
							"",
							"",
						},
						winhighlight = "Normal:Folded",
						winblend = 0,
					},
					mappings = {
						scrollU = "<C-u>",
						scrollD = "<C-d>",
					},
				},
				provider_selector = function(
					_ --[[ bufnr ]],
					filetype,
					_ --[[ buftype ]]
				)
					return ftMap[filetype]
				end,
				enable_get_fold_virt_text = true,
				fold_virt_text_handler = handler,
			})
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		enabled = false,
		config = function()
			local colorizer = require("colorizer")
			colorizer.setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				mode = "background",
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			background_colour = "#000000",
		},
		init = function()
			vim.notify = require("notify")
		end,
	},
	{
		"folke/noice.nvim",
		-- event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- "rcarriga/nvim-notify",
		},
		init = function()
			vim.opt.cmdheight = 0
			vim.keymap.set(
				{ "n", "i", "v" },
				"<M-;>",
				"<cmd>Noice dismiss<CR>",
				{ noremap = true, silent = true }
			)
		end,
		opts = {
			lsp = {
				progress = {
					enabled = false,
				},
				hover = {
					enabled = true,
				},
				signature = {
					enabled = true,
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
			views = {
				cmdline_popup = {
					border = {
						style = "none",
						padding = { 1, 2 },
					},
					filter_options = {},
					win_options = {
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
					},
				},
			},
		},
	},
	{
		"karb94/neoscroll.nvim",
		opts = {
			easing = "quadratic",
			mappings = {},
			hide_cursor = true, -- Hide cursor while scrolling
			stop_eof = true, -- Stop at <EOF> when scrolling downwards
			use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
			respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
			cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
			easing_function = nil, -- Default easing function
			pre_hook = nil, -- Function to run before the scrolling animation starts
			post_hook = nil, -- Function to run after the scrolling animation ends
		},
		keys = {
			{
				"<C-u>",
				function()
					require("neoscroll").ctrl_u({
						duration = 200,
						easing = "sine",
					})
				end,
			},
			{
				"<C-d>",
				function()
					require("neoscroll").ctrl_d({
						duration = 200,
						easing = "sine",
					})
				end,
			},
			{
				"<C-b>",
				function()
					require("neoscroll").ctrl_b({
						duration = 300,
						easing = "circular",
					})
				end,
			},
			{
				"<C-f>",
				function()
					require("neoscroll").ctrl_f({
						duration = 300,
						easing = "circular",
					})
				end,
			},
			{
				"<C-y>",
				function()
					require("neoscroll").scroll(
						-0.1,
						{ move_cursor = false, duration = 100 }
					)
				end,
			},
			{
				"<C-e>",
				function()
					require("neoscroll").scroll(
						0.1,
						{ move_cursor = false, duration = 100 }
					)
				end,
			},
			{
				"zt",
				function()
					require("neoscroll").zt({
						half_win_duration = 250,
						easing = "circular",
					})
				end,
			},
			{
				"zz",
				function()
					require("neoscroll").zz({
						half_win_duration = 250,
						easing = "circular",
					})
				end,
			},
			{
				"zb",
				function()
					require("neoscroll").zb({
						half_win_duration = 250,
						easing = "circular",
					})
				end,
			},
		},
	},
	{
		"folke/zen-mode.nvim",
		dependencies = {
			{
				"folke/twilight.nvim",
				opts = {
					dimming = {
						alpha = 0.25,
					},
					context = 15,
					treesitter = true,
					expand = {
						"function",
						"method",
						"table",
						"if_statement",
					},
				},
			},
		},
		opts = {
			window = {
				backdrop = 1,
				width = 100,
				height = 1,
				options = {
					number = true,
					relativenumber = true,
					foldcolumn = "0",
					winbar = "",
					signcolumn = "yes:3",
				},
			},
			plugins = {
				options = {
					enabled = true,
					ruler = false,
					showcmd = false,
				},
				gitsigns = { enabled = true },
				twighlight = { enabled = false },
				todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
				tmux = { enabled = false }, -- disables the tmux statusline
				kitty = {
					enabled = true,
					font = "+6",
				},
				wezterm = {
					enabled = true,
					font = "+12",
				},
				neovide = {
					enabled = false,
					-- Will multiply the current scale factor by this number
					scale = 1.2,
					-- disable the Neovide animations while in Zen mode
					disable_animations = {
						neovide_animation_length = 0,
						neovide_cursor_animate_command_line = false,
						neovide_scroll_animation_length = 0,
						neovide_position_animation_length = 0,
						neovide_cursor_animation_length = 0,
						neovide_cursor_vfx_mode = "",
					},
				},
			},
			on_open = function(_)
				vim.diagnostic.hide(nil, 0)
			end,
			on_close = function()
				vim.diagnostic.show(nil, 0)
			end,
		},
		keys = {
			{
				"<leader>z",
				"<cmd>ZenMode<CR>",
			},
		},
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
	},
}
