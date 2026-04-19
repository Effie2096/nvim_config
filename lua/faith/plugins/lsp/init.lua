local icons = require("faith.icons")

local managed_servers = {
	angularls = require("faith.plugins.lsp.settings.angularls"),
	bacon_ls = {
		init_options = {
			updateOnSave = true,
			updateOnSaveWaitMillis = 1000,
		},
	},
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
	emmet_language_server = {},
	gopls = {},
	-- html = require("faith.plugins.lsp.settings.html"),
	jdtls = require("faith.plugins.lsp.settings.jdtls"),
	superhtml = {},
	jsonls = require("faith.plugins.lsp.settings.jsonls"),
	-- kotlin_lsp = {},
	lemminx = require("faith.plugins.lsp.settings.lemminx"),
	lua_ls = require("faith.plugins.lsp.settings.lua_ls"),
	markdown_oxide = {},
	-- ocamllsp = require("faith.plugins.lsp.settings.ocamllsp"),
	omnisharp = require("faith.plugins.lsp.settings.omnisharp"),
	powershell_es = {},
	tombi = {},
	ts_ls = require("faith.plugins.lsp.settings.tsserver"),
	yamlls = require("faith.plugins.lsp.settings.yamlls"),
	svelte = {},
	wgsl_analyzer = require("faith.plugins.lsp.settings.wgsl_analyzer"),
}

return {
	-- LSP Plugins
	require("faith.plugins.lsp.json_schema"),
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				 "nvim-dap-ui",
				 "mini.icons"
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
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					require("faith.plugins.lsp.common").on_attach(
						event.data.client_id,
						event.buf
					)
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.iter(vim.tbl_keys(managed_servers)):each(function(server)
				vim.lsp.config(server, managed_servers[server])
			end)

			local ensure_installed = vim.tbl_keys(managed_servers or {})
			vim.tbl_deep_extend("force", ensure_installed, {
				"stylua",
			})
			-- require("mason-tool-installer").setup({
			-- 	ensure_installed = ensure_installed,
			-- })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (populates installs via mason-tool-installer)
				automatic_installation = false,
				automatic_enable = {
					exclude = {
						"rust_analyzer",
						-- "jdtls",
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

			-- vim.api.nvim_create_augroup("diagnostics", { clear = true })

			-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
			-- 	group = "diagnostics",
			-- 	callback = function()
			-- 		vim.diagnostic.setloclist({ open = false })
			-- 	end,
			-- })

			local virtual_text = {
				spacing = 0,
				virt_text_pos = "eol",
				prefix = "",
				format = function(diagnostic)
					return icons.diagnostic[diagnostic.severity]
				end,
				hl_mode = "combine",
			}
			---@type vim.diagnostic.Opts
			local config = {
				virtual_text = false,
				virtual_lines = {
					current_line = true,
					source = true,
					prefix = "",
					spacing = 1,
					format = function(diagnostic)
						if
							vim.api.nvim_get_option_value("filetype", { scope = "local" })
							== "rust"
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
						[vim.diagnostic.severity.ERROR] = icons.diagnostic.error,
						[vim.diagnostic.severity.WARN] = icons.diagnostic.warn,
						[vim.diagnostic.severity.HINT] = icons.diagnostic.hint,
						[vim.diagnostic.severity.INFO] = icons.diagnostic.info,
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
				update_in_insert = true,
				underline = true,
				severity_sort = false,
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
					local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
					orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
				end,
				hide = function(_, bufnr)
					orig_signs_handler.hide(ns, bufnr)
				end,
			}
		end,
	},
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {
	-- 		on_attach = require("faith.plugins.lsp.common").on_attach,
	-- 		settings = {
	-- 			tsserver_file_preferences = function(ft)
	-- 				return require("faith.plugins.lsp.settings.tsserver").settings[ft].inlayHints
	-- 			end,
	-- 			-- tsserver_format_options = {
	-- 			-- 	allowIncompleteCompletions = false,
	-- 			-- 	allowRenameOfImportPath = false,
	-- 			-- },
	-- 		},
	-- 	},
	-- },
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"onsails/lspkind.nvim",
				init = function()
					require("lspkind").init({
						preset = "codicons",
					})
				end,
			},
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				config = function()
					local ls = require("luasnip")
					local types = require("luasnip.util.types")

					local snippet_path = vim.fn.stdpath("config") .. "/lua/faith/snippets"
					require("luasnip.loaders.from_lua").load({
						paths = vim.fn.glob(snippet_path),
					})
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = snippet_path .. "/vscode",
					})

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
			"xzbdmw/colorful-menu.nvim",
			"folke/lazydev.nvim",
			{ "yus-works/csc.nvim", opts = {} },
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "default",
				["<C-space>"] = {},
				["<C-y>"] = { "show", "select_and_accept", "fallback" },
				["<C-u>"] = { "scroll_signature_up", "fallback" },
				["<C-d>"] = { "scroll_signature_down", "fallback" },
				["<C-k>"] = {},
				["<Tab>"] = {},
				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},

			cmdline = {
				keymap = { preset = "inherit" },
				completion = {
					menu = { auto_show = true },
					ghost_text = { enabled = false },
				},
			},
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "normal",
			},

			completion = {
				ghost_text = { enabled = true, show_with_menu = true },
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				menu = {
					auto_show = true,
					direction_priority = function()
						local ctx = require("blink.cmp").get_context()
						local item = require("blink.cmp").get_selected_item()
						if ctx == nil or item == nil then
							return { "s", "n" }
						end

						local item_text = item.textEdit ~= nil and item.textEdit.newText
							or item.insertText
							or item.label
						local is_multi_line = item_text:find("\n") ~= nil

						-- after showing the menu upwards, we want to maintain that direction
						-- until we re-open the menu, so store the context id in a global variable
						if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
							vim.g.blink_cmp_upwards_ctx_id = ctx.id
							return { "n", "s" }
						end
						return { "s", "n" }
					end,
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- combined together in label by colorful-menu.nvim.
						columns = {
							{ "kind_icon" },
							{ "label", gap = 1, "source_name" },
						},
						padding = { 0, 1 },
						components = {
							kind_icon = {
								text = function(ctx)
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ =
											MiniIcons.get(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
											icon = require("lspkind").symbolic(ctx.kind, {
												mode = "symbol",
											})
									end

									return (" %s "):format(icon) .. ctx.icon_gap
								end,
							},
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(
										ctx
									)
								end,
							},
							source_name = {
								text = function(ctx)
									return ("(%s)"):format(ctx.source_name)
								end,
							},
						},
					},
				},
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
			},

			sources = {
				default = function()
					local result = {
						"lsp",
						"path",
						"snippets",
						"lazydev",
						"buffer",
					}
					return result
				end,
				providers = {
					buffer = {
						score_offset = -5,
						opts = {
							get_bufnrs = function()
								return { vim.api.nvim_get_current_buf() }
							end,
						},
					},
					lazydev = {
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					lsp = {
						fallbacks = {},
					},
					path = {
						score_offset = 3,
						fallbacks = { "buffer" },
						opts = {
							trailing_slash = true,
							label_trailing_slash = true,
							get_cwd = function(context)
								return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
							end,
							show_hidden_files_by_default = false,
							-- Treat `/path` as starting from the current working directory (cwd) instead of the root of your filesystem
							ignore_root_slash = false,
							-- Maximum number of files/directories to return. This limits memory use and responsiveness for very large folders.
							max_entries = 10000,
						},
					},
				},
			},

			snippets = { preset = "luasnip" },

			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},

			-- Shows a signature help window while you type arguments for a function
			signature = {
				enabled = true,
				window = {
					show_documentation = true,
				},
			},
		},
	},
	{
		"nvim-svelte/nvim-svelte-snippets",
		ft = "svelte",
		dependencies = "L3MON4D3/LuaSnip",
		opts = {},
	},
	require("faith.plugins.lsp.java"),
	require("faith.plugins.lsp.rust"),
}
