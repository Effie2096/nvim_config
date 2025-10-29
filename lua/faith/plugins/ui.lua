local icons = require("faith.icons")

return {
	{
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		lazy = false,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		init = function()
			vim.g.rainbow_delimiters = {
				highlight = {
					"RainbowRed",
					"RainbowYellow",
					"RainbowBlue",
					"RainbowOrange",
					"RainbowGreen",
					"RainbowViolet",
					"RainbowCyan",
				},
			}
		end,
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
			picker = { enabled = false },
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
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = function()
			local highlights = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			return {
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
					highlight = highlights,
				},
				whitespace = {
					highlight = highlights,
					remove_blankline_trail = false,
				},
				scope = {
					enabled = true,
					show_start = true,
					show_end = true,
					char = icons.characters.indent_focus,
				},
			}
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
					"neotest-summary",
					"oil",
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
							colwidth = 2,
							fillchar = " ",
							fillcharhl = "SignColumn",
							auto = true,
							wrap = false,
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
							text = { " " },
							maxwidth = 1,
							colwidth = 1,
							auto = false,
							wrap = false,
						},
					},
					{
						sign = {
							name = { "Dap" },
							maxwidth = 1,
							colwidth = 1,
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
				"<M-.>",
				"<cmd>Noice dismiss<CR>",
				{ noremap = true, silent = true }
			)
			vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
				if not require("noice.lsp").scroll(4) then
					return "<c-f>"
				end
			end, { silent = true, expr = true })

			vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
				if not require("noice.lsp").scroll(-4) then
					return "<c-b>"
				end
			end, { silent = true, expr = true })
		end,
		opts = {
			presets = {},
			lsp = {
				progress = {
					enabled = false,
				},
				hover = {
					enabled = false,
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
						luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
						throttle = 50, -- Debounce lsp signature help request by 50ms
					},
					view = nil, -- when nil, use defaults from documentation
					---@type NoiceViewOptions
					opts = {}, -- merged with defaults from documentation
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
					position = {
						row = "4",
						col = "50%",
					},
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
					enabled = true,
					font = "+4",
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
		"petertriho/nvim-scrollbar",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			{
				"kevinhwang91/nvim-hlslens",
				dependencies = { "kevinhwang91/nvim-ufo" },
				config = function()
					require("hlslens").setup({
						override_lens = function(
							render,
							posList,
							nearest,
							idx,
							relIdx
						)
							local sfw = vim.v.searchforward == 1
							local indicator, text, chunks
							local absRelIdx = math.abs(relIdx)
							if absRelIdx > 1 then
								indicator = ("%d%s"):format(
									absRelIdx,
									sfw ~= (relIdx > 1) and "▲" or "▼"
								)
							elseif absRelIdx == 1 then
								indicator = sfw ~= (relIdx == 1) and "▲"
									or "▼"
							else
								indicator = ""
							end

							local lnum, col = unpack(posList[idx])
							if nearest then
								local cnt = #posList
								if indicator ~= "" then
									text = ("[%s %d/%d]"):format(
										indicator,
										idx,
										cnt
									)
								else
									text = ("[%d/%d]"):format(idx, cnt)
								end
								chunks =
									{ { " " }, { text, "HlSearchLensNear" } }
							else
								text = ("[%s %d]"):format(indicator, idx)
								chunks = { { " " }, { text, "HlSearchLens" } }
							end
							render.setVirt(
								0,
								lnum - 1,
								col - 1,
								chunks,
								nearest
							)
						end,
						build_position_cb = function(plist, _, _, _)
							require("scrollbar.handlers.search").handler.show(
								plist.start_pos
							)
						end,
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

					vim.cmd([[
						augroup scrollbar_search_hide
						autocmd!
						autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
						augroup END
					]])
				end,
			},
			{
				"chentoast/marks.nvim",
				event = "VeryLazy",
				opts = {
					-- whether to map keybinds or not. default true
					default_mappings = true,
					-- which builtin marks to show. default {}
					-- builtin_marks = { ".", "<", ">", "^" },
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
		},
		config = function()
			local opts = {
				set_highlights = false,
				show_in_active_only = true,
				hide_if_all_visible = true,
				excluded_filetypes = {
					"neo-tree",
				},
				marks = {
					Misc = {
						text = { "-", "=" },
						priority = 6,
					},
					Mark = {
						text = { "", "" },
						priority = 8,
						highlight = "ScrollbarMark",
					},
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
			}
			require("scrollbar").setup(opts)

			require("scrollbar.handlers").register("Marks", function(bufnr)
				local marks_api = require("marks")
				local ret = {}
				if marks_api.mark_state.buffers[bufnr] then
					for line, marks in
						pairs(marks_api.mark_state.buffers[bufnr].marks_by_line)
					do
						if #marks > 1 then
							table.sort(marks)
						end
						table.insert(ret, {
							line = line - 1,
							text = marks[1],
							type = "Mark",
						})
					end
				end
				return ret
			end)
		end,
	},
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
			-- "anuvyklack/animation.nvim",
		},
		config = function()
			-- vim.o.winwidth = 10
			-- vim.o.winminwidth = 10
			-- vim.o.equalalways = false
			vim.keymap.set("n", "<C-w>m", "<CMD>WindowsMaximize<CR>")
			vim.keymap.set("n", "<C-w>u", "<CMD>WindowsToggleAutowidth<CR>")
			require("windows").setup({
				autowidth = {
					enable = false,
				},
				animation = {
					enable = false,
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
				disable = { lsp = {}, filetypes = { "markdown" }, cond = {} },
				text_format = text_format,
				references = { enabled = true, include_declaration = false },
				definition = { enabled = false },
			})
		end,
	},
}
