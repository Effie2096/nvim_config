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
					notification = {
						window = {
							winblend = 0, -- needs 0 for catppuccin integration
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
				init = function()
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
				config = function()
					require("lint").linters_by_ft = {
						lua = { "luacheck" },
						python = { "flake8" },
						sh = { "shellcheck" },
						vim = { "vint" },
						yaml = { "yamllint" },
						html = { "htmlhint" },
						json = { "biome" },
						jsonc = { "biome" },
						js = { "biome" },
						ts = { "biome" },
					}
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

			local servers = {
				angularls = {},
				basedpyright = {},
				bashls = require("faith.plugins.lsp.settings.bashls"),
				biome = {},
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

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"prettierd",
			})
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend(
							"force",
							{},
							capabilities,
							server.capabilities or {}
						)
						if server_name ~= "rust_analyzer" then
							require("lspconfig")[server_name].setup(server)
						end
					end,
				},
			})

			local float_config = {
				focusable = false,
				border = "single",
				source = false,
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
					source = false,
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
			"hrsh7th/cmp-nvim-lsp-signature-help",
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
						col_offset = -3,
						side_padding = 0,
					},
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				sources = {
					{ name = "codeium", keyword_length = 2 },
					{ name = "luasnip", keyword_length = 2 }, -- For luasnip users.
					{ name = "tags", keyword_length = 2 },
					{ name = "nvim_lsp", keyword_length = 2 },
					-- { name = "nvim_lsp_signature_help"  , keyword_length = 2 },
					{ name = "path", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3 },
					{ name = "calc", keyword_length = 2 },
					{ name = "emoji", keyword_length = 2 },
				},
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
					{ name = "nvim_lsp_signature_help" },
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
		opts = {
			highlight_mode = "virtual",
			virtual_pos = "inline-left",
			virtual_symbol = require("faith.icons").ui.Circle,
			highlighter = {
				auto_enable = true,
				excludes = {
					"fugitive",
				},
				update_insert = false,
			},
		},
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
