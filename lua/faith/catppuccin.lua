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
		conditionals = { "bold" },
		loops = { "bold" },
		functions = {},
		keywords = { "bold" },
		strings = { "italic" },
		variables = {},
		numbers = {},
		booleans = { "bold" },
		properties = { "bold" },
		types = {},
		operators = {},
	},
	integrations = {
		barbecue = {
			dim_dirname = true, -- directory name is dimmed by default
			bold_basename = true,
			dim_context = true,
			alt_background = true,
		},
		diffview = true,
		fidget = true,
		gitsigns = true,
		harpoon = true,
		headlines = false,
		indent_blankline = {
			enabled = true,
			scope_color = "pink",
			colored_indent_levels = false,
		},
		lightspeed = true,
		lsp_saga = true,
		markdown = true,
		mason = true,
		neotest = true,
		noice = true,
		cmp = true,
		dap = {
			enabled = true,
			enable_ui = true,
		},
		dap_ui = true,
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
			inlay_hints = {
				background = true,
			},
		},
		navic = {
			enable = true,
			custom_bg = "NONE",
		},
		notify = true,
		semantic_tokens = true,
		nvimtree = true,
		treesitter_context = true,
		treesitter = true,
		ufo = true,
		rainbow_delimiters = true,
		telescope = true,
		lsp_trouble = true,
	},
	custom_highlights = function(colors)
		local git_change_color = colors.blue
		local git_add_color = colors.green
		local git_delete_color = colors.red
		local git_change = { fg = git_change_color, bg = colors.base }
		local git_add = { fg = git_add_color, bg = colors.base }
		local git_delete = { fg = git_delete_color, bg = colors.base }

		local telescope_normal = colors.surface0
		local telescope_prompt = colors.surface1

		local harpoon_active = { fg = colors.base, bg = colors.pink, bold = true }

		local markdown_heading = colors.surface0

		local highlight_overrides = {
			GitSignsAddInline = { fg = colors.base, bg = git_add_color },
			GitSignsAddLnInline = { fg = colors.base, bg = git_add_color },
			GitSignsChangeInline = { fg = colors.base, bg = git_change_color },
			GitSignsChangeLnInline = { fg = colors.base, bg = git_change_color },
			GitSignsDeleteInline = { fg = colors.base, bg = git_delete_color },
			GitSignsDeleteLnInline = { fg = colors.base, bg = git_delete_color },
			GitSignsChange = git_change,
			GitSignsChangeNr = git_change,

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

			-- LspInlayHint = { fg = colors.overlay1, bg = colors.base },

			Heading1 = { fg = markdown_heading, bg = colors.green },
			Heading2 = { fg = markdown_heading, bg = colors.peach },
			Heading3 = { fg = markdown_heading, bg = colors.mauve },
			Heading4 = { fg = markdown_heading, bg = colors.sapphire },
			Heading5 = { fg = markdown_heading, bg = colors.yellow },
			Heading6 = { fg = markdown_heading, bg = colors.red },
			CodeBlock = { bg = colors.crust },
			HeadingBullet = { fg = markdown_heading },

			RenderMarkdownH1Bg = { bg = colors.green, fg = markdown_heading },
			RenderMarkdownH2Bg = { bg = colors.peach, fg = markdown_heading },
			RenderMarkdownH3Bg = { bg = colors.mauve, fg = markdown_heading },
			RenderMarkdownH4Bg = { bg = colors.sapphire, fg = markdown_heading },
			RenderMarkdownH5Bg = { bg = colors.yellow, fg = markdown_heading },
			RenderMarkdownH6Bg = { bg = colors.red, fg = markdown_heading },

			["@markup.quote"] = { fg = colors.yellow, bold = false },
			["@markup.italic"] = { fg = colors.rosewater, italic = true },
			["@markup.strong"] = { fg = colors.maroon, bold = true },
		}

		return highlight_overrides
	end,
	highlight_overrides = {
		latte = function(colors)
			local highlight_overrides = {
				ObsidianTagCustom = { fg = colors.pink, bg = "#eedbee", bold = false },
			}
			return highlight_overrides
		end,
		mocha = function(colors)
			local highlight_overrides = {
				ObsidianTagCustom = { fg = colors.pink, bg = "#493f53", bold = false },
			}
			return highlight_overrides
		end,
	},
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

		--[[ if package.loaded.fidget ~= nil then
			vim.api.nvim_set_hl(0, "FidgetTitle", { fg = colors.pink, bold = true })
		end ]]

		-- vim.api.nvim_set_hl(0, "TreesitterContextBottom", { bg = colors.mantle, special = "none" })
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
