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
			dim_context = false,
			alt_background = false,
		},
		lsp_saga = true,
		mason = true,
		noice = true,
	},
})

vim.api.nvim_create_augroup("catppuccin_auto_compile", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "catppuccin.lua" },
	callback = function()
		local path = vim.fn.stdpath("config")
		vim.cmd("luafile " .. vim.fn.glob(path .. "/lua/faith/catppuccin.lua"))
		require("catppuccin").compile()
		return true
	end,
	group = "catppuccin_auto_compile",
})

--[[ vim.api.nvim_create_autocmd("ColorSchemePre", {
	pattern = "*",
	callback = function ()
	end,
}) ]]

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local colors = require("catppuccin.palettes").get_palette()

		local accent = colors.pink
		local base = vim.g.transparent_enabled and "none" or colors.base
		vim.api.nvim_set_hl(0, "CatAccent", { fg = base, bg = accent, bold = true })
		vim.api.nvim_set_hl(0, "CatAccentInverse", { fg = accent, bg = base, bold = true })

		vim.api.nvim_exec2("highlight FoldColumn guifg=" .. accent, { output = false })

		local signHl = vim.api.nvim_get_hl(0, { name = "SignColumn" })

		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = accent, bg = signHl.bg })

		local changeColor = colors.blue
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green, bg = signHl.bg })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = changeColor, bg = signHl.bg })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.red, bg = signHl.bg })
		vim.api.nvim_exec2("highlight GitSignsChangeNr guifg=" .. changeColor, { output = false })
		vim.api.nvim_exec2(
			"highlight GitSignsChangeLn guifg=" .. colors.yellow .. " guibg=" .. colors.base,
			{ output = false }
		)
		vim.api.nvim_set_hl(0, "GitSignsAddInline", { fg = colors.base, bg = colors.green })
		vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { fg = colors.base, bg = colors.red })
		vim.api.nvim_set_hl(0, "GitSignsChangeInline", { fg = colors.base, bg = changeColor })
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
		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.surface0 })

		local kindFG = colors.base

		local cmp_items = {
			"CmpItemKindField",
			"CmpItemKindProperty",
			"CmpItemKindEvent",
			"CmpItemKindText",
			"CmpItemKindEnum",
			"CmpItemKindKeyword",
			"CmpItemKindConstant",
			"CmpItemKindConstructor",
			"CmpItemKindReference",
			"CmpItemKindFunction",
			"CmpItemKindStruct",
			"CmpItemKindClass",
			"CmpItemKindModule",
			"CmpItemKindOperator",
			"CmpItemKindVariable",
			"CmpItemKindFile",
			"CmpItemKindUnit",
			"CmpItemKindSnippet",
			"CmpItemKindFolder",
			"CmpItemKindMethod",
			"CmpItemKindValue",
			"CmpItemKindEnumMember",
			"CmpItemKindInterface",
			"CmpItemKindColor",
			"CmpItemKindTypeParameter",
		}

		for _, v in pairs(cmp_items) do
			local color = vim.api.nvim_get_hl(0, { name = v })
			vim.api.nvim_set_hl(0, v, { fg = kindFG, bg = color.fg })
		end

		local telescope_normal = colors.surface0
		local telescope_prompt = colors.surface1

		vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = telescope_normal })
		vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = telescope_prompt })
		vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = telescope_prompt })
		vim.api.nvim_set_hl(0, "TelescopeBorder", {
			fg = telescope_normal, --colors.pink,
			bg = telescope_normal,
		})
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", {
			fg = telescope_prompt, --colors.pink,
			bg = telescope_prompt,
		})
		vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = colors.crust, bg = colors.pink })
		vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = colors.crust, bg = colors.green })

		local white_space_colors = vim.api.nvim_get_hl(0, { name = "Whitespace" })
		vim.api.nvim_set_hl(0, "IndentBlankLineChar", { fg = white_space_colors.fg })
		vim.api.nvim_set_hl(0, "IndentBlankLineContextChar", { fg = accent })
		vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", { fg = white_space_colors.fg })
		vim.api.nvim_set_hl(0, "IndentBlanklineSpaceCharBlankline", { fg = white_space_colors.fg })

		vim.api.nvim_set_hl(0, "IndentBlanklineContextStart", { sp = colors.text, underline = true })

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

		if package.loaded.harpoon ~= nil then
			local active = { fg = colors.base, bg = accent, bold = true }
			vim.api.nvim_set_hl(0, "HarpoonInactive", { link = "Tabline" })
			vim.api.nvim_set_hl(0, "HarpoonActive", active)
			vim.api.nvim_set_hl(0, "HarpoonNumberActive", active)
			vim.api.nvim_set_hl(0, "HarpoonNumberInactive", { link = "Tabline" })
		end

		if package.loaded["rainbow_delimiters"] ~= nil then
			vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = colors.red })
			vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = colors.yellow })
			vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = colors.teal })
			vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = colors.peach })
			vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = colors.green })
			vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = colors.mauve })
			vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = colors.sky })
		end
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
