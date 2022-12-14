vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.opt.completeopt:append "c"

local status_ok_cmp, cmp = pcall(require, 'cmp')
if not status_ok_cmp then
	return
end
if package.loaded.lualine == nil then
	return
end

local status_ok_kind, lspkind = pcall(require, 'lspkind')
if not status_ok_kind then
	return
end
lspkind.init({
	preset = 'codicons'
})

local snippet_path = os.getenv("XDG_CONFIG_HOME") .. "/nvim/lua/faith/snippets"
require("luasnip.loaders.from_lua").lazy_load({paths = vim.fn.glob(snippet_path)})
require("luasnip.loaders.from_vscode").lazy_load()

local aup_ok, autopairs = pcall(require, 'nvim-autopairs')
if aup_ok then
	local cmp_autopairs = require('nvim-autopairs.completion.cmp')
	local handlers = require('nvim-autopairs.completion.handlers')

	cmp.event:on(
		'confirm_done',
		cmp_autopairs.on_confirm_done({
			filetypes = {
				-- "*" is a alias to all filetypes
				["*"] = {
					["("] = {
						kind = {
							cmp.lsp.CompletionItemKind.Function,
							cmp.lsp.CompletionItemKind.Method,
						},
						handler = handlers["*"]
					}
				},
				-- Disable for tex
				tex = false
			}
		})
	)
end

cmp.setup {
	mapping = cmp.mapping.preset.insert {
		["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
		["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		["<c-space>"] = cmp.mapping {
			i = cmp.mapping.complete(),
			c = function(
				_ --[[fallback]]
				)
				if cmp.visible() then
					if not cmp.confirm { select = true } then
						return
					end
				else
					cmp.complete()
				end
			end,
		},

		-- ["<tab>"] = false,
		["<tab>"] = cmp.config.disable,
	},
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
			or require("cmp_dap").is_dap_buffer()
	end,
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function (entry, vim_item)
			local kind = require("lspkind").cmp_format({
				mode = "symbol",
				maxwidth = 50,
				menu = {
					buffer = "[buf]",
					nvim_lsp = "[LSP]",
					nvim_lua = "[api]",
					path = "[path]",
					luasnip = "[snip]",
					dap = "[dap]",
					calc = "[maff]"
				},
			})(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. strings[1] .. " "
			-- kind.menu = "    (" .. strings[2] .. ")"

			return kind
		end
		--[[ format = lspkind.cmp_format {
			-- with_text = true,
			mode = 'symbol_text',
			maxwidth = 60,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				-- nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
				calc = "[maff]"
			},
		}, ]]
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	experimental = {
		native_menu = false,
		ghost_text = true,
	},
	--[[ view = {
		entries = {name = 'custom', selection_order = 'near_cursor' }
	}, ]]
	window = {
		completion = {
			col_offset = -3,
			side_padding = 0,
		},
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	sources = {
		{ name = 'luasnip' }, -- For luasnip users.
		{ name = 'nvim_lsp' },
		-- { name = 'nvim_lsp_signature_help' },
		{ name = 'nvim_lua' },
		{ name = 'path' },
		{ name = 'buffer' },
		{ name = 'calc' },
	}
}

cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	},
	view = {
		entries = {name = 'wildmenu', separator = '|' }
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
			{
				name = 'cmdline',
				option = {
					ignore_cmds = { 'Man', '!' }
				}
			}
		})
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})

-- disable suggestions in sagarename popup
cmp.setup.filetype({ "sagarename" }, {
	sources = {}
})
