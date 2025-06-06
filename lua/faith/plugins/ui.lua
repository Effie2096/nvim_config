local icons = require("faith.icons")

return {
	{
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		lazy = false,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			bufdelete = { enable = true },
			dashboard = { enabled = false },
			explorer = { enabled = false },
			indent = { enabled = false },
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = false },
			quickfile = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },
			toggle = { enables = true },
			scratch = {
				filekey = {
					cwd = true, -- use current working directory
					branch = false, -- use current branch name
					count = true, -- use vim.v.count1
				},
			},
			styles = {
				input = {
					relative = "editor",
				},
				zoom_indicator = {
					text = " ",
					minimal = true,
					enter = false,
					focusable = false,
					height = 1,
					row = 0,
					col = function()
						return math.floor((vim.opt.columns:get() - 1) / 2)
					end,
					backdrop = false,
				},
				scratch = {
					ft = "markdown",
					-- position = "right",
					-- width = function()
					-- 	local width = math.floor((vim.opt.columns:get() * 0.35))
					-- 	return width < 50 and 50 or width
					-- end,
					-- height = function()
					-- 	local height = math.floor((vim.opt.lines:get() * 0.3))
					-- 	return height < 10 and 10 or height
					-- end,
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle
						.option("relativenumber", { name = "Relative Number" })
						:map("<leader>ul")
					Snacks.toggle
						.option("background", {
							off = "light",
							on = "dark",
							name = "Dark Background",
						})
						:map("<leader>ub")
					Snacks.toggle
						.option("wrap", { name = "Wrap" })
						:map("<leader>uw")
					Snacks.toggle
						.option("conceallevel", {
							off = 0,
							on = vim.o.conceallevel > 0 and vim.o.conceallevel
								or 2,
						})
						:map("<leader>uc")
				end,
			})
		end,
		keys = {
			{
				"<leader>s.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>sn",
				function()
					vim.ui.input({
						prompt = "Filetype: ",
						default = (
							vim.bo.buftype == ""
							and vim.bo.filetype ~= ""
						)
								and vim.bo.filetype
							or "markdown",
					}, function(input)
						if input then
							Snacks.scratch({ ft = input })
						else
							Snacks.scratch()
						end
					end)
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<leader>bc",
				function()
					Snacks.bufdelete.delete()
				end,
				desc = "[b]uffer [c]lose: Delete current buffer without closing window.",
			},
		},
	},
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
				exclude = {
					filetypes = {
						"fugitive",
						-- "Avante",
						"AvanteSelectedFiles",
						"AvanteInput",
					},
				},
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
					"Avante",
					"AvanteSelectedFiles",
					"AvanteInput",
				},
				bt_ignore = { "terminal", "nofile" },
				thousands = false, -- or line number thousands separator string ("." / ",")
				relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
				-- Builtin 'statuscolumn' options
				-- Default segments (fold -> sign -> line number + separator), explained below
				segments = {
					{
						sign = {
							name = { "coverage" },
							maxwidth = 1,
							colwidth = 1,
							auto = true,
							wrap = false,
						},
					},
					-- {
					-- 	sign = {
					-- 		namespace = { "diagnostic.signs" },
					-- 		text = { "💡", "🔎" },
					-- 		maxwidth = 1,
					-- 		colwidth = 2,
					-- 		auto = false,
					-- 		foldclosed = true,
					-- 	},
					-- 	click = "v:lua.ScSa",
					-- },
					{
						sign = {
							namespace = { "gitsigns" },
							maxwidth = 1,
							colwidth = 1,
							fillchar = " ",
							fillcharhl = "SignColumn",
							auto = true,
						},
					},
					{
						sign = {
							name = { ".*" },
							maxwidth = 4,
							colwidth = 2,
							auto = true,
							wrap = false,
						},
						click = "v:lua.ScSa",
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
						text = { require("statuscol.builtin").foldfunc },
						click = "v:lua.ScFa",
					},
					{
						sign = {
							name = { "Dap" },
							maxwidth = 1,
							colwidth = 2,
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
		dependencies = { "kevinhwang91/promise-async" },
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

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"neo-tree",
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_console",
					"dapui_stacks",
					"dapui_scopes",
					"dap-repl",
				},
				callback = function()
					require("ufo").detach()
					vim.opt_local.foldenable = false
				end,
			})
		end,
		config = function()
			local ufo = require("ufo")

			local ftMap = {
				markdown = { "treesitter", "indent" },
			}

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}

				local suffix = (
					" " .. require("faith.icons").ui.FoldSuffix -- .. "%d "
				) -- :format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)

				local targetWidth = (width > 100 and 100 or width) - sufWidth

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
				local fold_length = endLnum - lnum
				local lines_display = string.format(
					" (%d line%s)",
					fold_length,
					(fold_length > 1) and "s" or ""
				)
				local extra_suffix = targetWidth
					- curWidth
					- vim.fn.strdisplaywidth(lines_display)
					- 1
				table.insert(newVirtText, { suffix, "MoreMsg" })
				table.insert(newVirtText, {
					("·"):rep(extra_suffix),
					"Comment",
				})
				table.insert(newVirtText, { lines_display, "MoreMsg" })
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
				close_fold_kinds_for_ft = {
					default = { "imports", "comment" },
					json = { "array" },
					c = { "comment", "region" },
				},
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
			"rcarriga/nvim-notify",
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
				{
					filter = {
						event = "notify",
						kind = "error",
						any = {
							{
								-- undo glow cries about this when transparent is enabled but nothing seems to be actually "broken"
								find = "Animation type must be one of the builtin or a function",
							},
						},
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
			messages = {
				view_search = false,
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
						duration = 80,
						easing = "sine",
					})
				end,
			},
			{
				"<C-d>",
				function()
					require("neoscroll").ctrl_d({
						duration = 80,
						easing = "sine",
					})
				end,
			},
			{
				"<C-b>",
				function()
					require("neoscroll").ctrl_b({
						duration = 120,
						easing = "circular",
					})
				end,
			},
			{
				"<C-f>",
				function()
					require("neoscroll").ctrl_f({
						duration = 120,
						easing = "circular",
					})
				end,
			},
			{
				"<C-y>",
				function()
					require("neoscroll").scroll(
						-0.1,
						{ move_cursor = false, duration = 50 }
					)
				end,
			},
			{
				"<C-e>",
				function()
					require("neoscroll").scroll(
						0.1,
						{ move_cursor = false, duration = 50 }
					)
				end,
			},
			{
				"zt",
				function()
					require("neoscroll").zt({
						half_win_duration = 180,
						easing = "circular",
					})
				end,
			},
			{
				"zz",
				function()
					require("neoscroll").zz({
						half_win_duration = 180,
						easing = "circular",
					})
				end,
			},
			{
				"zb",
				function()
					require("neoscroll").zb({
						half_win_duration = 180,
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
					colorcolumn = "0",
					cursorline = false,
				},
			},
			plugins = {
				options = {
					enabled = true,
					ruler = true,
					showcmd = false,
					laststatus = 0, -- turn off the statusline in zen mode
				},
				gitsigns = { enabled = true },
				twilight = { enabled = false },
				todo = { enabled = true }, -- if set to "true", todo-comments.nvim highlights will be disabled
				tmux = { enabled = false }, -- disables the tmux statusline
				kitty = {
					enabled = true,
					font = "+6",
				},
				wezterm = {
					enabled = false,
					font = "+12",
				},
				neovide = {
					enabled = true,
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
				vim.cmd.ScrollbarHide()
			end,
			on_close = function()
				vim.diagnostic.show(nil, 0)
				vim.cmd.ScrollbarShow()
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
	{
		"mcauley-penney/visual-whitespace.nvim",
		opts = function()
			local opts = {
				highlight = { link = "Visual" },
				space_char = icons.characters.space,
				nl_char = icons.characters.eol,
			}

			return opts
		end,
	},
	{
		"y3owk1n/undo-glow.nvim",
		event = { "VeryLazy" },
		---@type UndoGlow.Config
		opts = {
			animation = {
				enabled = true,
				duration = 300,
				animtion_type = "spring",
				easing = "in_out_quad",
				fps = 60,
				window_scoped = false,
			},
			highlights = {
				undo = {
					hl = "UgUndo", -- This will not set new hlgroup, if it's not "UgUndo", we will try to grab the colors of specified hlgroup and apply to "UgUndo"
				},
				redo = {
					hl = "UgRedo",
				},
				yank = {
					hl = "UgYank",
				},
				paste = {
					hl = "UgPaste",
				},
				search = {
					hl = "UgSearch",
				},
				comment = {
					hl = "UgComment",
				},
				cursor = {
					hl = "UgCursor",
				},
			},
			priority = 2048 * 3,
		},
		keys = {
			{
				"u",
				function()
					require("undo-glow").undo()
				end,
				mode = "n",
				desc = "Undo with highlight",
				noremap = true,
			},
			{
				"U",
				function()
					require("undo-glow").redo()
				end,
				mode = "n",
				desc = "Redo with highlight",
				noremap = true,
			},
			{
				"p",
				function()
					require("undo-glow").paste_below()
				end,
				mode = "n",
				desc = "Paste below with highlight",
				noremap = true,
			},
			{
				"P",
				function()
					require("undo-glow").paste_above()
				end,
				mode = "n",
				desc = "Paste above with highlight",
				noremap = true,
			},
			{
				"n",
				function()
					require("undo-glow").search_next({
						animation = {
							animation_type = "strobe",
						},
					})
				end,
				mode = "n",
				desc = "Search next with highlight",
				noremap = true,
			},
			{
				"N",
				function()
					require("undo-glow").search_prev({
						animation = {
							animation_type = "strobe",
						},
					})
				end,
				mode = "n",
				desc = "Search prev with highlight",
				noremap = true,
			},
			{
				"*",
				function()
					require("undo-glow").search_star({
						animation = {
							animation_type = "strobe",
						},
					})
				end,
				mode = "n",
				desc = "Search star with highlight",
				noremap = true,
			},
			{
				"#",
				function()
					require("undo-glow").search_hash({
						animation = {
							animation_type = "strobe",
						},
					})
				end,
				mode = "n",
				desc = "Search hash with highlight",
				noremap = true,
			},
			{
				"gc",
				function()
					-- This is an implementation to preserve the cursor position
					local pos = vim.fn.getpos(".")
					vim.schedule(function()
						vim.fn.setpos(".", pos)
					end)
					return require("undo-glow").comment()
				end,
				mode = { "n", "x" },
				desc = "Toggle comment with highlight",
				expr = true,
				noremap = true,
			},
			{
				"gc",
				function()
					require("undo-glow").comment_textobject()
				end,
				mode = "o",
				desc = "Comment textobject with highlight",
				noremap = true,
			},
			{
				"gcc",
				function()
					return require("undo-glow").comment_line()
				end,
				mode = "n",
				desc = "Toggle comment line with highlight",
				expr = true,
				noremap = true,
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("TextYankPost", {
				desc = "Highlight when yanking (copying) text",
				callback = function()
					require("undo-glow").yank()
				end,
			})

			-- This only handles neovim instance and do not highlight when switching panes in tmux
			vim.api.nvim_create_autocmd("CursorMoved", {
				desc = "Highlight when cursor moved significantly",
				callback = function()
					require("undo-glow").cursor_moved({
						animation = {
							animation_type = "slide",
						},
					})
				end,
			})

			-- This will handle highlights when focus gained, including switching panes in tmux
			vim.api.nvim_create_autocmd("FocusGained", {
				desc = "Highlight when focus gained",
				callback = function()
					---@type UndoGlow.CommandOpts
					local opts = {
						animation = {
							animation_type = "slide",
						},
					}

					opts = require("undo-glow.utils").merge_command_opts(
						"UgCursor",
						opts
					)
					local pos =
						require("undo-glow.utils").get_current_cursor_row()

					require("undo-glow").highlight_region(
						vim.tbl_extend("force", opts, {
							s_row = pos.s_row,
							s_col = pos.s_col,
							e_row = pos.e_row,
							e_col = pos.e_col,
							force_edge = opts.force_edge == nil and true
								or opts.force_edge,
						})
					)
				end,
			})

			vim.api.nvim_create_autocmd("CmdLineLeave", {
				pattern = { "/", "?" },
				desc = "Highlight when search cmdline leave",
				callback = function()
					require("undo-glow").search_cmd({
						animation = {
							animation_type = "fade",
						},
					})
				end,
			})
		end,
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
				build_position_cb = function(plist, _, _, _)
					require("scrollbar.handlers.search").handler.show(
						plist.start_pos
					)
				end,
			})

			local kopts = { noremap = true, silent = true }

			vim.api.nvim_set_keymap(
				"n",
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
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

			vim.cmd([[
				augroup scrollbar_search_hide
				autocmd!
				autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
				augroup END
				]])
		end,
	},
	{
		"petertriho/nvim-scrollbar",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"kevinhwang91/nvim-hlslens",
		},
		opts = {
			set_highlights = false,
			show_in_active_only = true,
			hide_if_all_visible = true,
			marks = {
				GitAdd = {
					text = icons.git.signs.add,
					priority = 7,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "GitSignsAdd",
				},
				GitChange = {
					text = icons.git.signs.mod,
					priority = 7,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "GitSignsChange",
				},
				GitDelete = {
					text = icons.git.signs.delete,
					priority = 7,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "GitSignsDelete",
				},
			},
			handlers = {
				cursor = true,
				diagnostic = true,
				-- gitsigns = true, -- Requires gitsigns
				handle = true,
				search = true, -- Requires hlslens
				ale = false, -- Requires ALE
			},
		},
	},
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		config = function()
			vim.o.winwidth = 10
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			vim.keymap.set("n", "<C-w>m", "<CMD>WindowsMaximize<CR>")
			vim.keymap.set("n", "<C-w>u", "<CMD>WindowsToggleAutowidth<CR>")
			require("windows").setup({
				animation = {
					enable = true,
					duration = 100,
					fps = 60,
					easing = "in_out_sine",
				},
				ignore = {
					buftype = { "terminal", "nofile", "prompt" },
					filetype = {
						"toggleterm",
						"neo-tree",
						"OverseerList",
						"Avante",
						"AvanteInput",
						"AvanteSelectedFiles",
						"oil_preview",
						"snacks_input",
					},
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "classic",
			disable = {
				ft = { "toggleterm", "snacks_input" },
				bt = { "terminal", "prompt" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"kosayoda/nvim-lightbulb",
		opts = {
			hide_in_unfocused_buffer = true,
			code_lenses = true,
			-- Configuration for various handlers:
			-- 1. Sign column.
			sign = {
				enabled = false,
				-- Text to show in the sign column.
				-- Must be between 1-2 characters.
				text = "💡",
				lens_text = "🔎",
				-- Highlight group to highlight the sign column text.
				hl = "LightBulbSign",
			},

			-- 2. Virtual text.
			virtual_text = {
				enabled = false,
				-- Text to show in the virt_text.
				text = "💡",
				lens_text = "🔎",
				-- Position of virtual text given to |nvim_buf_set_extmark|.
				-- Can be a number representing a fixed column (see `virt_text_pos`).
				-- Can be a string representing a position (see `virt_text_win_col`).
				pos = "eol",
				-- Highlight group to highlight the virtual text.
				hl = "LightBulbVirtualText",
				-- How to combine other highlights with text highlight.
				-- See `hl_mode` of |nvim_buf_set_extmark|.
				hl_mode = "combine",
			},

			-- 3. Floating window.
			float = {
				enabled = true,
				-- Text to show in the floating window.
				text = "💡",
				lens_text = "🔎",
				-- Highlight group to highlight the floating window.
				hl = "LightBulbFloatWin",
				-- Window options.
				-- See |vim.lsp.util.open_floating_preview| and |nvim_open_win|.
				-- Note that some options may be overridden by |open_floating_preview|.
				win_opts = {
					focusable = false,
					anchor_bias = "above",
					offset_x = -1,
				},
			},

			-- 4. Status text.
			-- When enabled, will allow using |NvimLightbulb.get_status_text|
			-- to retrieve the configured text.
			status_text = {
				enabled = false,
				-- Text to set if a lightbulb is available.
				text = "💡",
				lens_text = "🔎",
				-- Text to set if a lightbulb is unavailable.
				text_unavailable = "",
			},

			-- 5. Number column.
			number = {
				enabled = false,
				-- Highlight group to highlight the number column if there is a lightbulb.
				hl = "LightBulbNumber",
			},

			-- 6. Content line.
			line = {
				enabled = false,
				-- Highlight group to highlight the line if there is a lightbulb.
				hl = "LightBulbLine",
			},
			autocmd = {
				-- Whether or not to enable autocmd creation.
				enabled = true,
				-- See |updatetime|.
				-- Set to a negative value to avoid setting the updatetime.
				updatetime = -1,
				-- See |nvim_create_autocmd|.
				events = { "CursorHold", "CursorHoldI" },
				-- See |nvim_create_autocmd| and |autocmd-pattern|.
				pattern = { "*" },
			},
		},
	},
	{
		"Wansmer/symbol-usage.nvim",
		event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
		config = function()
			local function text_format(symbol)
				local res = {}

				local round_start = {
					require("faith.icons").separators.rounded.right,
					"SymbolUsageRounding",
				}
				local round_end = {
					require("faith.icons").separators.rounded.left,
					"SymbolUsageRounding",
				}

				-- Indicator that shows if there are any other symbols in the same line
				local stacked_functions_content = symbol.stacked_count > 0
						and ("+%s"):format(symbol.stacked_count)
					or ""

				if symbol.references then
					local usage = symbol.references <= 1 and "usage" or "usages"
					local num = symbol.references == 0 and "no"
						or symbol.references
					table.insert(res, round_start)
					table.insert(res, { "󰌹 ", "SymbolUsageRef" })
					table.insert(
						res,
						{ ("%s %s"):format(num, usage), "SymbolUsageContent" }
					)
					table.insert(res, round_end)
				end

				if symbol.definition then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { "󰳽 ", "SymbolUsageDef" })
					table.insert(
						res,
						{ symbol.definition .. " defs", "SymbolUsageContent" }
					)
					table.insert(res, round_end)
				end

				if symbol.implementation then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
					table.insert(res, {
						symbol.implementation .. " impls",
						"SymbolUsageContent",
					})
					table.insert(res, round_end)
				end

				if stacked_functions_content ~= "" then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { " ", "SymbolUsageImpl" })
					table.insert(
						res,
						{ stacked_functions_content, "SymbolUsageContent" }
					)
					table.insert(res, round_end)
				end

				return res
			end

			require("symbol-usage").setup({
				text_format = text_format,
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		enabled = false,
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				themeable = true,
				mode = "tabs",
				numbers = "ordinal",
				indicator = {
					style = "underline",
				},
				show_buffer_icons = true,
				color_icons = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				show_duplicate_prefix = false,
				separator_style = "slant",
				truncate_names = false,
				hover = {
					enabled = true,
				},
				diagnostics = false,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Explorer",
						text_align = "center",
						separator = false,
					},
				},
				name_formatter = function(ctx)
					local ft = vim.bo[ctx.bufnr].filetype

					local fts = {
						fugitive = "Fugitive",
						TelescopePrompt = "Telescope",
					}
					local found = vim.iter(fts):find(function(v)
						return v == ft
					end)
					if found ~= nil then
						return fts[found]
					end

					local tab_dir = vim.fn.fnamemodify(
						vim.fn.getcwd(-1, ctx.tabnr or 0),
						":t"
					)
					local show_dir = tab_dir --[[ tab has different dir ]]
						~= vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
					local taboo = (
						vim.fn.exists("g:loaded_taboo")
						and vim.fn.TabooTabName(ctx.tabnr) ~= ""
					)
							and string.format(
								" [%s]",
								vim.fn.TabooTabName(ctx.tabnr)
							)
						or ""

					local title = string.format(
						"%s%s%s",
						ctx.name,
						(
							show_dir
								and string.format(
									" %s %s/",
									icons.kind.Folder,
									tab_dir
								)
							or ""
						),
						string.upper(taboo)
					)

					return title
				end,
				get_element_icon = function(element)
					local function fetch_icon(filetype)
						return require("nvim-web-devicons").get_icon_by_filetype(
							filetype,
							{ default = false }
						)
					end
					local fts = {
						fugitive = "git",
						TelescopePrompt = {
							icon = icons.ui.Telescope,
							hl = "BufferLinePick",
						},
					}
					local found = vim.iter(fts):find(function(v)
						return v == element.filetype
					end)
					if found ~= nil then
						if type(fts[found]) == "table" then
							return fts[found].icon, fts[found].hl
						else
							return fetch_icon(fts[found])
						end
					end
				end,
				custom_areas = {
					right = function()
						local harpoon = require("harpoon")
						local marks = harpoon:list(
							string.format(
								"%s%d",
								"tab",
								vim.api.nvim_get_current_tabpage()
							)
						).items or {}

						local buf = vim.api.nvim_buf_get_name(0)

						local extra_marks = 0

						local keys = {
							[1] = "h",
							[2] = "j",
							[3] = "k",
							[4] = "l",
							[5] = icons.arrows.left,
							[6] = icons.arrows.down,
							[7] = icons.arrows.up,
							[8] = icons.arrows.right,
						}
						local result = {}

						if next(marks) ~= nil then
							table.insert(result, {
								text = " " .. icons.ui.BookMark,
								link = "HarpoonNumberActive",
							})

							for i, mark in ipairs(marks) do
								local is_current = (
									(
										vim.fn.glob(
											vim.fn.fnamemodify(buf, ":p:.")
										) -- relative
										== vim.fn.glob(mark.value)
									)
									or (
										vim.fn.glob(
											vim.fn.fnamemodify(buf, ":p")
										)
										== vim.fn.glob(mark.value)
									) -- or absolute
								)

								local label
								if
									mark.value == ""
									or mark.value == "(empty)"
								then
									label = "(empty)"
									is_current = false
								else
									label = string.format(
										"%s",
										vim.fn.fnamemodify(mark.value, ":t")
									)
								end

								if i <= #keys then
									if not is_current then
										table.insert(result, {
											text = (
												i == 1 and " "
												or icons.separators.bar.left
											),
											link = "HarpoonSeparator",
										})
									end
									table.insert(result, {
										text = string.format(
											"%s%s",
											(is_current and " " or ""),
											keys[i]
										),
										link = is_current
												and "HarpoonNumberActive"
											or "HarpoonNumberInactive",
									})
									table.insert(result, {
										text = string.format(" %s ", label),
										link = is_current and "HarpoonActive"
											or "HarpoonInactive",
									})
								else
									extra_marks = extra_marks + 1
									table.insert(result, {
										text = string.format(
											" %s%s ",
											"+",
											extra_marks
										),
										link = "HarpoonNumberActive",
									})
								end
							end

							return result
						end
					end,
				},
			},
		},
	},
}
