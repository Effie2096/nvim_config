vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.opt.completeopt:append "c"

local lspkind = require('lspkind')
lspkind.init({
	preset = 'codicons'
})

local cmp = require('cmp')
local luasnip = require('luasnip')

local snippet_path = os.getenv("XDG_CONFIG_HOME") .. "/nvim/lua/faith/snippets"
require("luasnip.loaders.from_lua").lazy_load({paths = snippet_path})
require("luasnip.loaders.from_vscode").lazy_load()

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

cmp.setup {
	mapping = cmp.mapping.preset.insert {
		["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
		["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		--[[ ["<CR>"] = cmp.mapping(
			cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			},
			{ "i", "c" }
		), ]]
		--[[ ['<C-k>'] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable(1) then
				luasnip.expand_or_jump(1)
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<C-j>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<C-l>'] = cmp.mapping(function (fallback)
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			else
				fallback()
			end
		end, { 'i' }), ]]

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
		format = lspkind.cmp_format {
			-- with_text = true,
			mode = 'symbol_text',
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				-- nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
				calc = "[maff]"
			},
		},
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	experimental = {
		native_menu = false,
		ghost_text = true,
	},
	window = {
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

cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
	sources = {
		{ name = "dap" },
	},
})
