local catp_status_ok, catppuccin = pcall(require, "catppuccin")
if not catp_status_ok then
	return
end

-- configure it
catppuccin.setup({
	compile_path = vim.fn.glob(vim.fn.stdpath("cache") .. "/catppuccin"),
	transparent_background = vim.g.transparent_enabled,
	term_colors = true,
	dim_inactive = {
		enable = true,
		shade = "dark",
		percentage = 0.15,
	},
	styles = {
		comments = {},
		conditionals = {},
		loops = {},
		functions = {},
		keywords = { "bold" },
		strings = { "italic" },
		variables = {},
		numbers = {},
		booleans = { "bold" },
		properties = {},
		types = {},
		operators = {},
	},
	integrations = {
		gitsigns = true,
		lightspeed = true,
		cmp = true,
		notify = true,
		treesitter_context = true,
		treesitter = true,
		lsp_trouble = true,
		ts_rainbow = false,
		telescope = true,
		harpoon = true,
		rainbow_delimiters = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = {},
				hints = {},
				warnings = {},
				information = {},
			},
			underlines = {
				errors = { "undercurl" },
				hints = { "underline" },
				warnings = { "undercurl" },
				information = { "underline" },
			},
		},
		dap = {
			enabled = true,
			enable_ui = true,
		},
		indent_blankline = {
			enabled = true,
			scope_color = "pink",
			colored_indent_levels = false,
		},
		navic = {
			enable = true,
			custom_bg = "NONE",
		},
		nvimtree = true,
		barbecue = {
			dim_dirname = true, -- directory name is dimmed by default
			bold_basename = true,
			dim_context = true,
			alt_background = true,
		},
		lsp_saga = true,
		mason = true,
		noice = true,
	},
	custom_highlights = function(colors)
		local change_color = colors.blue

		local telescope_normal = colors.surface0
		local telescope_prompt = colors.surface1

		local harpoon_active = { fg = colors.base, bg = colors.pink, bold = true }

		local hightlight_overrides = {
			GitSignsChange = { fg = change_color, bg = colors.base },
			GitSignsChangeNr = { fg = change_color, bg = colors.base },
			GitSignsChangeInline = { fg = colors.base, bg = change_color },

			TelescopeNormal = { bg = telescope_normal },
			TelescopeSelection = { bg = telescope_prompt },
			TelescopePromptNormal = { bg = telescope_prompt },
			TelescopeBorder = { fg = telescope_normal, bg = telescope_normal },
			TelescopePromptBorder = { fg = telescope_prompt, bg = telescope_prompt },
			TelescopePromptTitle = { fg = colors.crust, bg = colors.pink },
			TelescopePreviewTitle = { fg = colors.crust, bg = colors.green },

			HarpoonInactive = { link = "Tabline" },
			HarpoonActive = harpoon_active,
			HarpoonNumberActive = harpoon_active,
			HarpoonNumberInactive = { link = "Tabline" },

			CmpItemKindSnippet = { fg = colors.base, bg = colors.mauve },
			CmpItemKindKeyword = { fg = colors.base, bg = colors.red },
			CmpItemKindText = { fg = colors.base, bg = colors.teal },
			CmpItemKindMethod = { fg = colors.base, bg = colors.blue },
			CmpItemKindConstructor = { fg = colors.base, bg = colors.blue },
			CmpItemKindFunction = { fg = colors.base, bg = colors.blue },
			CmpItemKindFolder = { fg = colors.base, bg = colors.blue },
			CmpItemKindModule = { fg = colors.base, bg = colors.blue },
			CmpItemKindConstant = { fg = colors.base, bg = colors.peach },
			CmpItemKindField = { fg = colors.base, bg = colors.green },
			CmpItemKindProperty = { fg = colors.base, bg = colors.green },
			CmpItemKindEnum = { fg = colors.base, bg = colors.green },
			CmpItemKindUnit = { fg = colors.base, bg = colors.green },
			CmpItemKindClass = { fg = colors.base, bg = colors.yellow },
			CmpItemKindVariable = { fg = colors.base, bg = colors.flamingo },
			CmpItemKindFile = { fg = colors.base, bg = colors.blue },
			CmpItemKindInterface = { fg = colors.base, bg = colors.yellow },
			CmpItemKindColor = { fg = colors.base, bg = colors.red },
			CmpItemKindReference = { fg = colors.base, bg = colors.red },
			CmpItemKindEnumMember = { fg = colors.base, bg = colors.red },
			CmpItemKindStruct = { fg = colors.base, bg = colors.blue },
			CmpItemKindValue = { fg = colors.base, bg = colors.peach },
			CmpItemKindEvent = { fg = colors.base, bg = colors.blue },
			CmpItemKindOperator = { fg = colors.base, bg = colors.blue },
			CmpItemKindTypeParameter = { fg = colors.base, bg = colors.blue },
			CmpItemKindCopilot = { fg = colors.base, bg = colors.teal },
		}

		return hightlight_overrides
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local colors = require("catppuccin.palettes").get_palette()

		local accent = colors.pink
		local base = vim.g.transparent_enabled and "none" or colors.base
		local mantle = vim.g.transparent_enabled and "none" or colors.mantle
		vim.api.nvim_set_hl(0, "CatAccent", { fg = base, bg = accent, bold = true })
		vim.api.nvim_set_hl(0, "CatAccentInverse", { fg = accent, bg = base, bold = true })
		vim.api.nvim_set_hl(0, "DiagnosticCheck", { fg = colors.green, bg = mantle })

		for _, level in pairs({ "Error", "Warn", "Info", "Hint" }) do
			vim.api.nvim_set_hl(0, "BarDiag" .. level, {
				fg = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. level }).fg,
				bg = mantle,
			})
		end

		vim.api.nvim_exec2("highlight FoldColumn guifg=" .. accent, { output = false })

		local signHl = vim.api.nvim_get_hl(0, { name = "SignColumn" })

		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = accent, bg = signHl.bg })

		vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d4261" })
		vim.api.nvim_set_hl(0, "DiffText", { bg = "#3d5a8a", special = "#3d5a8a", underline = true })

		vim.api.nvim_set_hl(0, "ZenBg", { link = "@none" })
		-- vim.api.nvim_set_hl(0, "MatchParen", { special = colors.peach, underline = true, bold = true })
		vim.api.nvim_exec2(
			"highlight MatchParen guifg="
				.. colors.base
				.. " guibg="
				.. colors.lavender
				.. " cterm=bold,underline gui=bold,underline",
			{ output = false }
		)

		vim.cmd([[highlight ExtraWhitespace ctermfg=red guifg=red gui=nocombine]])

		vim.api.nvim_set_hl(0, "TermCursor", { --[[ fg is ignored ]]
			bg = colors.pink,
		})

		vim.api.nvim_set_hl(0, "YankFlash", { fg = colors.base, bg = colors.lavender })

		if package.loaded.bufferline ~= nil then
			vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", { link = "VertSplit" })
		end

		if package.loaded.fidget ~= nil then
			vim.api.nvim_set_hl(0, "FidgetTitle", { fg = colors.pink, bold = true })
		end

		vim.api.nvim_set_hl(0, "TreesitterContextBottom", { bg = colors.mantle, special = "none" })
	end,
})

vim.opt.guicursor = "n-v-c-sm:block-TermCursor-blinkon10,i-ci-ve:ver25-blinkon10,r-cr-o:hor20,a:"

local yank_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	callback = function()
		vim.highlight.on_yank({ higroup = "YankFlash", timeout = 40 })
	end,
})

local match_group = vim.api.nvim_create_augroup("match_group", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
	group = match_group,
	command = [[2match ExtraWhitespace /\s\+$/]],
})
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	group = match_group,
	command = [[2match ExtraWhitespace /\s\+\%#\@<!$/]],
})
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	group = match_group,
	callback = function()
		vim.fn.clearmatches()
	end,
})
