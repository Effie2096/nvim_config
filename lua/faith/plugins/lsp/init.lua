local icons = require("faith.icons")

return {
	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ "nvim-dap-ui" },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						border = "single",
						icons = {
							package_installed = icons.ui.Check,
							package_pending = icons.ui.Mason,
							package_uninstalled = icons.ui.Circle_Empty,
						},
					},
					log_level = vim.log.levels.DEBUG,
					max_concurrent_installers = 4,
				},
			},
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{
				"j-hui/fidget.nvim",
				opts = {
					progress = {
						display = {
							done_style = "FidgetDone",
							progress_style = "FidgetProgress",
							group_style = "FidgetGroupName",
							icon_style = "FidgetGroupIcon",
						},
					},
					notification = {
						view = {
							group_separator_hl = "FidgetSep",
						},
						window = {
							winblend = 100, -- needs 0 for catppuccin integration
							normal_hl = "FidgetWindow",
						},
					},
					integration = {
						["nvim-tree"] = {
							enable = false,
						},
					},
				},
			},
			{
				"mfussenegger/nvim-lint",
				config = function()
					require("lint").linters_by_ft = {
						lua = { "luacheck" },
						python = { "flake8" },
						sh = { "shellcheck" },
						vim = { "vint" },
						yaml = { "yamllint" },
						html = { "htmlhint" },
						json = { "biomejs" },
						jsonc = { "biomejs" },
						js = { "biomejs" },
						jsx = { "biomejs" },
						ts = { "biomejs" },
						tsx = { "biomejs" },
						css = { "biomejs" },
					}

					vim.api.nvim_create_autocmd({ "BufWritePost" }, {
						callback = function()
							-- try_lint without arguments runs the linters defined in `linters_by_ft`
							-- for the current filetype
							require("lint").try_lint()
						end,
					})
					vim.api.nvim_create_autocmd(
						{ "TextChanged", "InsertLeave" },
						{
							pattern = "gitcommit",
							callback = function()
								require("lint").try_lint("commitlint")
							end,
						}
					)
				end,
			},
			"hrsh7th/cmp-nvim-lsp",
			{
				"S1M0N38/love2d.nvim",
				event = "VeryLazy",
				opts = {
					path_to_love_bin = "love",
					-- set to "" to disable auto lsp setup (I'm setting it up manually)
					path_to_love_library = "", -- vim.fn.globpath(vim.o.runtimepath, "love2d/library"),
					restart_on_save = false,
					debug_window_opts = nil,
				},
				keys = {
					{ "<leader>v", ft = "lua", desc = "LOVE" },
					{
						"<leader>vv",
						"<cmd>LoveRun<cr>",
						ft = "lua",
						desc = "Run LOVE",
					},
					{
						"<leader>vs",
						"<cmd>LoveStop<cr>",
						ft = "lua",
						desc = "Stop LOVE",
					},
				},
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup(
					"lsp-attach",
					{ clear = true }
				),
				callback = function(event)
					require("faith.plugins.lsp.common").on_attach(
						event.data.client_id,
						event.buf
					)
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			capabilities = vim.tbl_deep_extend(
				"force",
				capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)
			-- for UFO
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			local managed_servers = {
				angularls = {},
				basedpyright = {},
				bashls = require("faith.plugins.lsp.settings.bashls"),
				-- biome = {},
				clangd = {},
				cmake = {},
				css_variables = {},
				cssls = {},
				cssmodules_ls = {},
				docker_compose_language_service = {},
				dockerls = {},
				emmet_ls = require("faith.plugins.lsp.settings.emmet_ls"),
				gopls = {},
				html = require("faith.plugins.lsp.settings.html"),
				jsonls = require("faith.plugins.lsp.settings.jsonls"),
				kotlin_language_server = require(
					"faith.plugins.lsp.settings.kotlin_language_server"
				),
				lemminx = require("faith.plugins.lsp.settings.lemminx"),
				lua_ls = require("faith.plugins.lsp.settings.lua_ls"),
				marksman = {},
				ocamllsp = require("faith.plugins.lsp.settings.ocamllsp"),
				omnisharp = require("faith.plugins.lsp.settings.omnisharp"),
				powershell_es = {},
				taplo = {},
				ts_ls = require("faith.plugins.lsp.settings.tsserver"),
				yamlls = {},
			}

			vim.iter(vim.tbl_keys(managed_servers)):each(function(server)
				vim.lsp.config(server, managed_servers[server])
			end)

			local ensure_installed = vim.tbl_keys(managed_servers or {})
			vim.tbl_deep_extend("force", ensure_installed, {
				"stylua",
				"prettierd",
			})
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (populates installs via mason-tool-installer)
				automatic_installation = false,
				automatic_enable = {
					exclude = {
						"rust_analyzer",
					},
				},
			})

			local float_config = {
				focusable = false,
				border = "single",
				source = true,
				header = "",
				prefix = function(_, i, _)
					return string.format("%s: ", i)
				end,
				width = 60,
			}

			vim.api.nvim_create_augroup("diagnostics", { clear = true })

			vim.api.nvim_create_autocmd("DiagnosticChanged", {
				group = "diagnostics",
				callback = function()
					vim.diagnostic.setloclist({ open = false })
				end,
			})

			local config = {
				virtual_lines = {
					current_line = true,
					source = true,
					prefix = "",
					spacing = 1,
					format = function(diagnostic)
						if
							vim.api.nvim_get_option_value(
								"filetype",
								{ scope = "local" }
							) == "rust"
						then
							diagnostic.message = string.gsub(
								diagnostic.message,
								"`#%[.*%(.*%)%]` on by default",
								"",
								1
							)
							diagnostic.message = string.gsub(
								diagnostic.message,
								"for further information visit.*",
								"",
								1
							)
						end
						return diagnostic.message
					end,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
					linehl = {
						[vim.diagnostic.severity.ERROR] = "NONE", -- "DiagnosticSignError",
						[vim.diagnostic.severity.WARN] = "NONE", --"DiagnosticSignWarn",
						[vim.diagnostic.severity.HINT] = "NONE", --"DiagnosticSignHint",
						[vim.diagnostic.severity.INFO] = "NONE", --"DiagnosticSignInfo",
					},
					numhl = {
						[vim.diagnostic.severity.ERROR] = "DiagnosticErrorNum",
						[vim.diagnostic.severity.WARN] = "DiagnosticWarnNum",
						[vim.diagnostic.severity.HINT] = "DiagnosticHintNum",
						[vim.diagnostic.severity.INFO] = "DiagnosticInfoNum",
					},
				},
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = float_config,
			}

			vim.diagnostic.config(config)

			-- Create a custom namespace. This will aggregate signs from all other
			-- namespaces and only show the one with the highest severity on a
			-- given line
			local ns = vim.api.nvim_create_namespace("my_namespace")

			-- Get a reference to the original signs handler
			local orig_signs_handler = vim.diagnostic.handlers.signs

			-- Override the built-in signs handler
			vim.diagnostic.handlers.signs = {
				show = function(_, bufnr, _, opts)
					-- Get all diagnostics from the whole buffer rather than just the
					-- diagnostics passed to the handler
					local diagnostics = vim.diagnostic.get(bufnr)

					-- Find the "worst" diagnostic per line
					local max_severity_per_line = {}
					for _, d in pairs(diagnostics) do
						local m = max_severity_per_line[d.lnum]
						if not m or d.severity < m.severity then
							max_severity_per_line[d.lnum] = d
						end
					end

					-- Pass the filtered diagnostics (with our custom namespace) to
					-- the original handler
					local filtered_diagnostics =
						vim.tbl_values(max_severity_per_line)
					orig_signs_handler.show(
						ns,
						bufnr,
						filtered_diagnostics,
						opts
					)
				end,
				hide = function(_, bufnr)
					orig_signs_handler.hide(ns, bufnr)
				end,
			}
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			debug = false, -- set to true to enable debug logging
			log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
			-- default is  ~/.cache/nvim/lsp_signature.log
			verbose = false, -- show debug line number

			bind = true, -- This is mandatory, otherwise border config won't get registered.
			-- If you want to hook lspsaga or other signature handler, pls set to false
			doc_lines = 0, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
			-- set to 0 if you DO NOT want any API comments be shown
			-- This setting only take effect in insert mode, it does not affect signature help in normal
			-- mode, 10 by default

			max_height = 12, -- max height of signature floating_window, include borders
			max_width = function()
				return vim.api.nvim_win_get_width(0) * 0.8
			end, -- max_width of signature floating_window, line will be wrapped if exceed max_width
			-- the value need >= 40
			-- if max_width is function, it will be called
			wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
			floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

			floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
			-- will set to true when fully tested, set to false will use whichever side has more space
			-- this setting will be helpful if you do not want the PUM and floating win overlap

			floating_window_off_x = 1, -- adjust float windows x position.
			-- can be either a number or function
			floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
			-- can be either number or function, see examples
			ignore_error = false, -- this scilence errors, check init.lua for more details

			close_timeout = 4000, -- close floating window after ms when laster parameter is entered
			fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
			hint_enable = false, -- virtual hint enable
			hint_prefix = {
				above = "↙  ", -- when the hint is on the line above the current line
				current = "←  ", -- when the hint is on the same line
				below = "↖ ", -- when the hint is on the line below the current line
			},
			hint_scheme = "String",
			hint_inline = function()
				return false
			end, -- should the hint be inline(nvim 0.10 only)?  default false
			-- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
			-- return 'right_align' to display hint right aligned in the current line
			hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
			handler_opts = {
				border = { -- double, rounded, single, shadow, none, or a table of borders
					require("faith.icons").borders.edge_thin.top_left,
					require("faith.icons").borders.edge_thin.top,
					require("faith.icons").borders.edge_thin.top_right,
					require("faith.icons").borders.edge_thin.right,
					require("faith.icons").borders.edge_thin.bottom_right,
					require("faith.icons").borders.edge_thin.bottom,
					require("faith.icons").borders.edge_thin.bottom_left,
					require("faith.icons").borders.edge_thin.left,
				},
			},

			always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

			auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
			extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
			zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

			padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

			transparency = nil, -- disabled by default, allow floating win transparent value 1~100
			shadow_blend = 36, -- if you using shadow as border use this set the opacity
			shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
			timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
			toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
			toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
			-- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
			-- may not popup when typing depends on floating_window setting

			select_signature_key = "<M-n>", -- cycle to next signature, e.g. '<M-n>' function overloading
			move_signature_window_key = nil, -- move the floating window, e.g. {'<M-k>', '<M-j>'} to move up and down, or
			-- table of 4 keymaps, e.g. {'<M-k>', '<M-j>', '<M-h>', '<M-l>'} to move up, down, left, right
			move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating window
			-- e.g. move_cursor_key = '<M-p>',
			-- once moved to floating window, you can use <M-d>, <M-u> to move cursor up and down
			keymaps = {}, -- relate to move_cursor_key; the keymaps inside floating window with arguments of bufnr
			-- e.g. keymaps = function(bufnr) vim.keymap.set(...) end
			-- it can be function that set keymaps
			-- e.g. keymaps = { { 'j', '<C-o>j' }, } this map j to <C-o>j in floating window
			-- <M-d> and <M-u> are default keymaps to move cursor up and down
		},
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = {
					"rafamadriz/friendly-snippets",
				},
				config = function()
					local ls = require("luasnip")
					local types = require("luasnip.util.types")

					local snippet_path = vim.fn.stdpath("config")
						.. "/lua/faith/snippets"
					require("luasnip.loaders.from_lua").load({
						paths = vim.fn.glob(snippet_path),
					})
					require("luasnip.loaders.from_vscode").lazy_load()

					ls.config.set_config({
						-- This tells LuaSnip to remember to keep around the last snippet.
						-- You can jump back into it even if you move outside of the selection
						history = true,
						--
						-- This one is cool cause if you have dynamic snippets, it updates as you type!
						updateevents = "TextChanged,TextChangedI",
						-- treesitter-hl has 100, use something higher (default is 200).
						ext_base_prio = 300,
						-- minimal increase in priority.
						ext_prio_increase = 1,
						-- Autosnippets:
						enable_autosnippets = true,
						ext_opts = {
							[types.choiceNode] = {
								active = {
									virt_text = { { "🦊", "Error" } },
								},
							},
						},
					})

					-- <c-k> is my expansion key
					-- this will expand the current item or jump to the next item within the snippet.
					vim.keymap.set({ "i", "s" }, "<c-k>", function()
						if ls.expand_or_jumpable() then
							ls.expand_or_jump()
						end
					end, { silent = true })

					-- <c-j> is my jump backwards key.
					-- this always moves to the previous item within the snippet
					vim.keymap.set({ "i", "s" }, "<c-j>", function()
						if ls.jumpable(-1) then
							ls.jump(-1)
						end
					end, { silent = true })

					-- <c-l> is selecting within a list of options.
					vim.keymap.set({ "i", "s" }, "<c-l>", function()
						if ls.choice_active() then
							ls.change_choice(1)
							-- require("luasnip.extras.select_choice")()
						end
					end, { silent = true })
				end,
			},
			"saadparwaiz1/cmp_luasnip",

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"rcarriga/cmp-dap",
			"hrsh7th/cmp-cmdline",
			"petertriho/cmp-git",
			"quangnguyen30192/cmp-nvim-tags",
			"davidsierradz/cmp-conventionalcommits",

			{
				"onsails/lspkind.nvim",
				init = function()
					require("lspkind").init({
						preset = "codicons",
					})
				end,
			},
			{
				"allaman/emoji.nvim",
				dependencies = {
					-- util for handling paths
					"nvim-lua/plenary.nvim",
					-- optional for nvim-cmp integration
					"hrsh7th/nvim-cmp",
					-- optional for telescope integration
					-- "nvim-telescope/telescope.nvim",
				},
				opts = {
					-- default is false, also needed for blink.cmp integration!
					enable_cmp_integration = true,
				},
			},
		},

		config = function()
			local cmp = require("cmp")

			local luasnip = require("luasnip")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Select,
					}),
					["<C-p>"] = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Select,
					}),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}, { "i", "c" }),
					["<c-y>"] = cmp.mapping({
						i = cmp.mapping.complete(),
						c = function(
							_ --[[fallback]]
						)
							if cmp.visible() then
								if not cmp.confirm({ select = true }) then
									return
								end
							else
								cmp.complete()
							end
						end,
					}),

					-- ["<tab>"] = false,
					["<tab>"] = cmp.config.disable,
				}),
				enabled = function()
					return vim.api.nvim_get_option_value(
						"buftype",
						{ scope = "local" }
					) ~= "prompt" or require("cmp_dap").is_dap_buffer()
				end,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind = require("lspkind").cmp_format({
							mode = "symbol_text",
							maxwidth = 40,
							menu = {
								buffer = "[buf]",
								nvim_lsp = "[LSP]",
								path = "[path]",
								luasnip = "[snip]",
								dap = "[dap]",
								calc = "[maff]",
								git = "[git]",
								codeium = "[ai]",
								tags = "[tag]",
								emoji = "[emoji]",
							},
							ellipsis_char = "...",
						})(entry, vim_item)
						if entry.source.name == "codeium" then
							local icon = require("faith.icons").ui.Wand
							vim_item.kind = icon
							vim_item.kind_hl_group = "CmpItemKindSnippet"
						end
						if entry.source.name == "calc" then
							vim_item.kind = require("faith.icons").ui.Calc
							vim_item.kind_hl_group = "CmpItemKindFunction"
						end
						if entry.source.name == "tags" then
							vim_item.kind = require("faith.icons").ui.Tag
							vim_item.kind_hl_group = "CmpItemKindFunction"
						end
						local strings =
							vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						return kind
					end,
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						-- cmp.config.compare.sort_text,
						-- cmp.config.compare.scopes,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.kind,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				--[[ confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}, ]]
				experimental = {
					ghost_text = true,
				},
				view = {
					name = "custom",
					selection_order = "top_down",
					follow_cursor = true,
				},
				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						border = "none",
						col_offset = -3,
						side_padding = 0,
					},
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				sources = cmp.config.sources({
					{ name = "codeium" },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "tags" },
					{
						name = "nvim_lsp",
						option = {
							markdown_oxide = {
								keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
							},
						},
					},
					{ name = "render-markdown" },
					{ name = "ecolog" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "calc" },
					{ name = "emoji" },
				}),
			})

			cmp.event:on("menu_opened", function()
				vim.b.copilot_suggestion_hidden = true
			end)

			cmp.event:on("menu_closed", function()
				vim.b.copilot_suggestion_hidden = false
			end)

			cmp.setup.filetype({ "gitcommit", "octo" }, {
				sources = cmp.config.sources({
					{ name = "git" },
					{ name = "conventionalcommits" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
			require("cmp_git").setup()

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
				--[[ view = {
					entries = { name = "wildmenu", separator = "|" },
				}, ]]
			})

			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
				--[[ view = {
					entries = { name = "wildmenu", separator = "|" },
				}, ]]
			})

			cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
				sources = {
					{ name = "dap" },
				},
			})

			-- disable suggestions in sagarename popup
			cmp.setup.filetype({ "sagarename" }, {
				sources = {},
			})

			cmp.setup.filetype({ "markdown" }, {
				sources = {
					{ name = "codeium" },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "render-markdown" },
					{ name = "tags" },
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer", keyword_length = 3 },
					{ name = "calc" },
				},
			})
		end,
	},
	require("faith.plugins.lsp.rust"),
	{
		"uga-rosa/ccc.nvim",
		lazy = false,
		config = function()
			local ccc = require("ccc")
			local opts = {
				lsp = true,
				highlight_mode = "virtual",
				highlighter = {
					auto_enable = true,
					lsp = true,
					excludes = {
						"fugitive",
					},
					update_insert = true,
				},
				virtual_pos = "inline-left",
				virtual_symbol = require("faith.icons").ui.Circle,
				inputs = {
					ccc.input.rgb,
					ccc.input.hsl,
					ccc.input.hwb,
					ccc.input.lab,
					ccc.input.lch,
					ccc.input.oklab,
					ccc.input.oklch,
					ccc.input.cmyk,
					ccc.input.hsluv,
					ccc.input.okhsl,
					ccc.input.hsv,
					ccc.input.okhsv,
					ccc.input.xyz,
				},
				outputs = {
					ccc.output.hex,
					ccc.output.hex_short,
					ccc.output.css_rgb,
					ccc.output.css_rgba,
					ccc.output.css_hsl,
					ccc.output.css_hwb,
					ccc.output.css_lab,
					ccc.output.css_lch,
					ccc.output.css_oklab,
					ccc.output.css_oklch,
					ccc.output.float,
				},
				pickers = {
					ccc.picker.hex,
					ccc.picker.hex_long,
					ccc.picker.hex_short,
					ccc.picker.css_rgb,
					ccc.picker.css_hsl,
					ccc.picker.css_hwb,
					ccc.picker.css_lab,
					ccc.picker.css_lch,
					ccc.picker.css_oklab,
					ccc.picker.css_oklch,
					ccc.picker.css_name,
					ccc.picker.defaults,
				},
			}

			ccc.setup(opts)
		end,
		keys = {
			{
				"<Leader>cp",
				"<cmd>CccPick<cr>",
				desc = "[c]olor [p]icker: Open color picker.",
			},
			{
				"<M-c>",
				"<cmd>CccPick<cr>",
				desc = "[c]olor picker: Open color picker.",
				mode = "i",
			},
		},
	},
}
