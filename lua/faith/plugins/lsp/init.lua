local icons = require("faith.icons")

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

local has_lazydev, lazydev = pcall(require, "lazydev")
if has_lazydev then
	lazydev.setup({
		library = {
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			"overseer",
			"nvim-dap-ui",
			"mini.icons",
		},
	})
end

local love2d = require("love2d")
love2d.setup({
	path_to_love_bin = "love",
	-- set to "" to disable auto lsp setup (I'm setting it up manually)
	path_to_love_library = "", -- vim.fn.globpath(vim.o.runtimepath, "love2d/library"),
	restart_on_save = false,
	debug_window_opts = nil,
})
vim.keymap.set({ "n" }, "<leader>vv", vim.cmd.LoveRun, { desc = "Run Love" })
vim.keymap.set({ "n" }, "<leader>vs", vim.cmd.LoveStop, { desc = "Stop Love" })

local mason = require("mason")
local blink = require("blink.cmp")
local mason_lspconfig = require("mason-lspconfig")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local colorful_menu = require("colorful-menu")
local csc = require("csc")
local nvim_svelte_snippets = require("nvim-svelte-snippets")

mason.setup()

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

capabilities = blink.get_lsp_capabilities(capabilities)

capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

vim.lsp.config("*", {
	capabilities = capabilities,
})

mason_lspconfig.setup({
	ensure_installed = {},
	automatic_installation = false,
	automatic_enable = {
		exclude = {
			"rust_analyzer",
			-- "jdtls",
		},
	},
})

lspkind.init({ preset = "codicons" })
require("luasnip.loaders.from_vscode").lazy_load()

local types = require("luasnip.util.types")

local snippet_path = vim.fn.stdpath("config") .. "/lua/faith/snippets"
require("luasnip.loaders.from_lua").load({
	paths = vim.fn.glob(snippet_path),
})
require("luasnip.loaders.from_vscode").lazy_load({
	paths = snippet_path .. "/vscode",
})

luasnip.config.set_config({
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

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if luasnip.jumpable(-1) then
		luasnip.jump(-1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
		-- require("luasnip.extras.select_choice")()
	end
end, { silent = true })

colorful_menu.setup({})
csc.setup()
nvim_svelte_snippets.setup()

blink.setup({
	keymap = {
		preset = "default",
		["<C-space>"] = {},
		["<C-y>"] = { "show", "select_and_accept", "fallback" },
		["<C-u>"] = { "scroll_signature_up", "fallback" },
		["<C-d>"] = { "scroll_signature_down", "fallback" },
		["<C-b>"] = {
			function(cmp)
				cmp.scroll_documentation_up(4)
			end,
			"fallback",
		},
		["<C-f>"] = {
			function(cmp)
				cmp.scroll_documentation_down(4)
			end,
			"fallback",
		},
		["<C-k>"] = {},
		["<Tab>"] = {},
	},

	cmdline = {
		keymap = { preset = "inherit" },
		completion = {
			menu = { auto_show = true },
			ghost_text = { enabled = false },
		},
	},
	appearance = {
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
				local ctx = blink.get_context()
				local item = blink.get_selected_item()
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
				treesitter = { "lsp" },
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
									require("mini.icons").get("directory", ctx.label)
								if dev_icon then
									icon = dev_icon
								end
							else
								icon = lspkind.symbolic(ctx.kind, {
									mode = "symbol",
								})
							end

							return (" %s "):format(icon) .. ctx.icon_gap
						end,
					},
					label = {
						text = function(ctx)
							return colorful_menu.blink_components_text(ctx)
						end,
						highlight = function(ctx)
							return colorful_menu.blink_components_highlight(ctx)
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
})
require("faith.plugins.lsp.java")
require("faith.plugins.lsp.rust")
