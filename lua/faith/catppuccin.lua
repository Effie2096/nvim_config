local catp_status_ok, catppuccin = pcall(require, "catppuccin")
if not catp_status_ok then
	return
end

-- configure it
catppuccin.setup({
	compile_path = vim.fn.glob(vim.fn.stdpath("cache") .. "/catppuccin"),
	transparent_background = false,
	term_colors = false,
	dim_inactive = {
		enable = false,
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
			colored_indent_levels = false,
		},
		navic = {
			enable = false,
			custom_bg = "NONE",
		},
		nvimtree = true,
		-- mason = true
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
		local changeColor = colors.blue
		vim.api.nvim_exec("highlight GitSignsChange guifg=" .. changeColor, false)
		vim.api.nvim_exec("highlight GitSignsChangeNr guifg=" .. changeColor, false)
		vim.api.nvim_exec("highlight GitSignsChangeLn guifg=" .. colors.yellow .. " guibg=" .. colors.base, false)
		vim.api.nvim_set_hl(0, "GitSignsAddInline", { fg = colors.base, bg = colors.green })
		vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { fg = colors.base, bg = colors.red })
		vim.api.nvim_set_hl(0, "GitSignsChangeInline", { fg = colors.base, bg = changeColor })
		vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d4261" })
		vim.api.nvim_set_hl(0, "DiffText", { bg = "#3d5a8a", special = "#3d5a8a", underline = true })

		vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#d8d8d8", bg = "#3a3a3a" })
		vim.api.nvim_set_hl(0, "ZenBg", { link = "@none" })
		vim.api.nvim_set_hl(0, "MatchParen", { special = colors.peach, underline = true, bold = true })
		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.surface0 })

		local tabFill = package.loaded.transparent ~= 0 and "none" or colors.mantle
		local tabBG = colors.surface1
		local tabFG = colors.subtext0
		local tabSelBG = colors.pink
		local tabSelFG = colors.crust
		local tabSepBG = tabFill
		local tabSepFG = tabBG
		local tabSepSelFG = tabSelBG
		local modified = colors.red
		local tablinePathFG = colors.crust
		local tablinePathBG = colors.lavender

		vim.api.nvim_set_hl(0, "TabLineFill", { bg = tabFill })
		vim.api.nvim_set_hl(0, "TabLineNum", { fg = colors.text, bg = tabBG })
		vim.api.nvim_set_hl(0, "TabLine", { fg = tabFG, bg = tabBG })
		vim.api.nvim_set_hl(0, "TabLineSel", { fg = tabSelFG, bg = tabSelBG, bold = true })
		vim.api.nvim_set_hl(0, "TabModified", { fg = modified, bg = tabBG })
		vim.api.nvim_set_hl(0, "TabModifiedSelected", { fg = modified, bg = tabSelBG })
		vim.api.nvim_set_hl(0, "TabLineSep", { fg = tabSepFG, bg = tabSepBG })
		vim.api.nvim_set_hl(0, "TabLineSelSep", { fg = tabSepSelFG, bg = tabSepBG })
		vim.api.nvim_set_hl(0, "TabLineClose", { fg = colors.red, bg = tabBG })
		vim.api.nvim_set_hl(0, "TabLineSelClose", { fg = colors.red, bg = tabSelBG })
		vim.api.nvim_set_hl(0, "TabLinePath", { fg = tablinePathFG, bg = tablinePathBG })
		vim.api.nvim_set_hl(0, "TabLinePathSep", { fg = tablinePathBG, bg = tabFill })
		vim.api.nvim_set_hl(0, "TabLineProject", { fg = colors.yellow, bg = tablinePathBG })

		local winbarBG = package.loaded.transparent ~= 0 and "none" or colors.base
		local numBG = colors.pink
		local numFG = colors.crust
		local fileBG = colors.surface2
		local fileFG = colors.subtext1
		local navBG = colors.surface1
		-- local navFG = colors.rosewater
		local diffBG = colors.surface1

		local diff_add_col = vim.api.nvim_get_hl_by_name("GitSignsAdd", true)
		local diff_change_col = vim.api.nvim_get_hl_by_name("GitSignsChange", true)
		local diff_delete_col = vim.api.nvim_get_hl_by_name("GitSignsDelete", true)
		vim.api.nvim_set_hl(0, "WinBar", { fg = colors.text, bold = true })
		vim.api.nvim_set_hl(0, "WinBarDiffAdd", { fg = diff_add_col.foreground, bg = diffBG, bold = true })
		vim.api.nvim_set_hl(0, "WinBarDiffChange", { fg = diff_change_col.foreground, bg = diffBG, bold = true })
		vim.api.nvim_set_hl(0, "WinBarDiffDelete", { fg = diff_delete_col.foreground, bg = diffBG, bold = true })
		vim.api.nvim_set_hl(0, "WinBarDiffSep", { fg = diffBG, bg = colors.base, bold = true })

		vim.api.nvim_set_hl(0, "WinBarWinNum", { fg = numFG, bg = numBG, bold = true })
		vim.api.nvim_set_hl(0, "WinBarWinNumEnd", { fg = numBG, bg = winbarBG })
		vim.api.nvim_set_hl(0, "WinBarFile", { fg = fileFG, bg = fileBG, bold = true })
		vim.api.nvim_set_hl(0, "WinBarFileModified", { fg = modified, bg = fileBG, bold = true })
		vim.api.nvim_set_hl(0, "WinBarNavic", { fg = fileFG, bg = navBG })
		vim.api.nvim_set_hl(0, "WinBarFileSep", { fg = fileBG, bg = navBG })
		vim.api.nvim_set_hl(0, "WinBarFileEnd", { fg = fileBG, bg = winbarBG })
		vim.api.nvim_set_hl(0, "WinBarNavicEnd", { fg = navBG, bg = winbarBG })

		local navicHLGroups = {
			"NavicIconsFile",
			"NavicIconsModule",
			"NavicIconsNamespace",
			"NavicIconsPackage",
			"NavicIconsClass",
			"NavicIconsMethod",
			"NavicIconsProperty",
			"NavicIconsField",
			"NavicIconsConstructor",
			"NavicIconsEnum",
			"NavicIconsInterface",
			"NavicIconsFunction",
			"NavicIconsVariable",
			"NavicIconsConstant",
			"NavicIconsString",
			"NavicIconsNumber",
			"NavicIconsBoolean",
			"NavicIconsArray",
			"NavicIconsObject",
			"NavicIconsKey",
			"NavicIconsNull",
			"NavicIconsEnumMember",
			"NavicIconsStruct",
			"NavicIconsEvent",
			"NavicIconsOperator",
			"NavicIconsTypeParameter",
			"NavicText",
			"NavicSeparator",
		}

		vim.api.nvim_set_hl(0, "NavicIconsFile", { fg = colors.blue })
		vim.api.nvim_set_hl(0, "NavicIconsMethod", { link = "@function" })
		vim.api.nvim_set_hl(0, "NavicIconsFunction", { link = "@function" })
		vim.api.nvim_set_hl(0, "NavicIconsConstructor", { link = "@function" })
		vim.api.nvim_set_hl(0, "NavicIconsField", { link = "@field" })
		vim.api.nvim_set_hl(0, "NavicIconsVariable", { link = "@variable" })
		vim.api.nvim_set_hl(0, "NavicIconsClass", { link = "@storageclass" })
		vim.api.nvim_set_hl(0, "NavicIconsInterface", { link = "@storageclass" })
		vim.api.nvim_set_hl(0, "NavicIconsModule", { link = "@function" })
		vim.api.nvim_set_hl(0, "NavicIconsProperty", { link = "@property" })
		vim.api.nvim_set_hl(0, "NavicIconsEnum", { link = "@constant" })
		vim.api.nvim_set_hl(0, "NavicIconsNamespace", { link = "@namespace" })
		vim.api.nvim_set_hl(0, "NavicIconsPackage", { link = "@text" })
		vim.api.nvim_set_hl(0, "NavicIconsConstant", { link = "@constant" })
		vim.api.nvim_set_hl(0, "NavicText", { link = "@string" })
		vim.api.nvim_set_hl(0, "NavicIconsString", { link = "@string" })
		vim.api.nvim_set_hl(0, "NavicIconsNumber", { link = "@number" })
		vim.api.nvim_set_hl(0, "NavicIconsBoolean", { link = "@boolean" })
		vim.api.nvim_set_hl(0, "NavicIconsArray", { link = "@storageclass" })
		vim.api.nvim_set_hl(0, "NavicIconsObject", { link = "@storageclass" })
		vim.api.nvim_set_hl(0, "NavicIconsKey", { link = "@operator" })
		vim.api.nvim_set_hl(0, "NavicIconsNull", { link = "@constant" })
		vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { link = "@constant" })
		vim.api.nvim_set_hl(0, "NavicIconsStruct", { link = "@structure" })
		vim.api.nvim_set_hl(0, "NavicIconsEvent", { fg = colors.yellow })
		vim.api.nvim_set_hl(0, "NavicIconsOperator", { link = "@operator" })
		vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { link = "@operator" })
		vim.api.nvim_set_hl(0, "NavicSeparator", { fg = colors.subtext0 })

		for _, value in pairs(navicHLGroups) do
			local hl = vim.api.nvim_get_hl_by_name(value, true)
			vim.api.nvim_set_hl(0, "Winbar" .. value, { fg = hl.foreground, bg = navBG })
		end

		local kindFG = colors.base

		vim.api.nvim_set_hl(
			0,
			"CmpItemKindField",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@field", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindProperty",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@property", true).foreground }
		)
		vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = kindFG, bg = colors.yellow })
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindText",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@string", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindEnum",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@constant", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindKeyword",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@keyword", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindConstant",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@constant", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindConstructor",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@function", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindReference",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@function", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindFunction",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@function", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindStruct",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@structure", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindClass",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@storageclass", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindModule",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@storageclass", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindOperator",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@operator", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindVariable",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@variable", true).foreground }
		)
		vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = kindFG, bg = colors.blue })
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindUnit",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@storageclass", true).foreground }
		)
		vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = kindFG, bg = colors.mauve })
		vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = kindFG, bg = colors.yellow })
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindMethod",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@function", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindValue",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@constant", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindEnumMember",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@constant", true).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindInterface",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@storageclass", true).foreground }
		)
		vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = kindFG, bg = colors.sky })
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindTypeParameter",
			{ fg = kindFG, bg = vim.api.nvim_get_hl_by_name("@operator", true).foreground }
		)

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

		local white_space_colors = vim.api.nvim_get_hl_by_name("Whitespace", true)
		vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", { fg = white_space_colors.foreground })
		vim.api.nvim_set_hl(0, "IndentBlanklineSpaceCharBlankline", { fg = white_space_colors.foreground })

		vim.api.nvim_set_hl(0, "IndentBlanklineContextStart", { sp = colors.text, underline = true })

		vim.cmd([[highlight ExtraWhitespace ctermfg=red guifg=red gui=nocombine]])

		vim.api.nvim_set_hl(0, "TermCursor", { bg = colors.pink })

		vim.api.nvim_set_hl(0, "YankFlash", { fg = colors.base, bg = colors.lavender })
	end,
})

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-blinkon10,r-cr-o:hor20,a:-TermCursor"

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
