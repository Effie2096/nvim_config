local theme_colormaps = require("faith.plugins.color.colormaps")

local M = {}
---@param theme string
---@param scheme? string
M.apply_theme_overrides = function(theme, scheme)
	scheme = scheme or ""
	local color_map = theme_colormaps[theme](scheme)

	local function h(name)
		return vim.api.nvim_get_hl(0, { name = name })
	end

	vim.api.nvim_set_hl(
		0,
		"Accent",
		{ fg = color_map.bg, bg = color_map.accent, bold = true }
	)
	vim.api.nvim_set_hl(
		0,
		"AccentInverse",
		{ fg = color_map.accent, bold = true }
	)

	vim.api.nvim_set_hl(0, "TransB", { bg = "#5bcffa" })
	vim.api.nvim_set_hl(0, "TransP", { bg = "#ffb5cd" })
	vim.api.nvim_set_hl(0, "TransW", { bg = "#ffffff" })

	local sidebar_bg = color_map.bg
	vim.api.nvim_set_hl(0, "SignColumn", {
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "EndOfBuffer", {
		bg = "NONE",
		fg = color_map.bg,
	})
	vim.api.nvim_set_hl(0, "LineNr", {
		fg = h("Comment").fg,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "CursorLineSign", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "CursorLineNr", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "FoldColumn", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "CursorLineFold", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "Folded", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})

	vim.api.nvim_set_hl(0, "NormalFloat", {
		fg = color_map.fg,
		bg = color_map.float,
	})
	vim.api.nvim_set_hl(0, "FloatBorder", {
		fg = color_map.accent,
		bg = color_map.float,
	})
	vim.api.nvim_set_hl(0, "WinSeparator", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "ColorfulWinSep", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})

	vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
		fg = color_map.bg,
		bg = color_map.accent,
		italic = true,
	})

	vim.api.nvim_set_hl(
		0,
		"LspInlayHint",
		{ fg = h("Comment").fg, italic = true }
	)

	vim.api.nvim_set_hl(0, "StatusLine", {
		fg = color_map.fg,
		bg = color_map.bg_light,
	})
	vim.api.nvim_set_hl(0, "StatusLineNC", {
		fg = color_map.fg,
		bg = color_map.bg_light,
	})
	vim.api.nvim_set_hl(0, "WinBar", {
		link = "StatusLine",
	})
	vim.api.nvim_set_hl(0, "WinBarNC", {
		link = "StatusLineNC",
	})

	vim.api.nvim_set_hl(0, "DiagnosticCheck", { fg = color_map.green })

	for _, level in pairs({ "Error", "Warn", "Info", "Hint" }) do
		vim.api.nvim_set_hl(0, "Diagnostic" .. level, {
			fg = color_map[level:lower()],
		})
		vim.api.nvim_set_hl(0, "DiagnosticVirtualText" .. level, {
			fg = color_map[level:lower()],
		})
		vim.api.nvim_set_hl(0, "BarDiag" .. level, {
			link = "Diagnostic" .. level,
		})
		vim.api.nvim_set_hl(0, "Diagnostic" .. level .. "Num", {
			link = "Diagnostic" .. level,
			bold = true,
			italic = true,
		})
	end
	vim.api.nvim_set_hl(0, "SessionAuto", {
		fg = color_map.yellow,
	})

	vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d4261" })
	vim.api.nvim_set_hl(0, "DiffText", {
		bg = "#3d5a8a",
		special = "#3d5a8a",
		underline = true,
	})

	vim.api.nvim_set_hl(0, "GitSignsChangedelete", {
		fg = color_map.blue,
		bg = color_map.red,
	})

	vim.api.nvim_set_hl(
		0,
		"YankFlash",
		{ fg = color_map.surface_dark, bg = color_map.purple_light }
	)

	vim.api.nvim_set_hl(
		0,
		"Heading1",
		{ fg = color_map.surface_dark, bg = color_map.green }
	)
	vim.api.nvim_set_hl(
		0,
		"Heading2",
		{ fg = color_map.surface_dark, bg = color_map.orange }
	)
	vim.api.nvim_set_hl(
		0,
		"Heading3",
		{ fg = color_map.float_light, bg = color_map.purple_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"Heading4",
		{ fg = color_map.float_light, bg = color_map.blue_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"Heading5",
		{ fg = color_map.surface_dark, bg = color_map.yellow }
	)
	vim.api.nvim_set_hl(
		0,
		"Heading6",
		{ fg = color_map.surface_dark, bg = color_map.red }
	)
	vim.api.nvim_set_hl(0, "CodeBlock", { bg = color_map.bg_dark })
	vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = color_map.bg_dark })
	vim.api.nvim_set_hl(0, "HeadingBullet", { fg = color_map.surface_dark })
	vim.api.nvim_set_hl(0, "Conceal", { bg = color_map.bg })
	vim.api.nvim_set_hl(
		0,
		"RenderMarkdownDash",
		{ bg = "NONE", fg = color_map.fg }
	)

	vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", {
		bg = color_map.green,
		fg = color_map.bg,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", {
		bg = color_map.orange,
		fg = color_map.bg,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", {
		bg = color_map.purple_dark,
		fg = color_map.bg,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", {
		bg = color_map.blue_dark,
		fg = color_map.bg,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", {
		bg = color_map.yellow,
		fg = color_map.bg,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", {
		bg = color_map.red,
		fg = color_map.bg,
	})

	vim.api.nvim_set_hl(0, "RenderMarkdownChecked", {
		fg = color_map.green,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", {
		fg = color_map.blue,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownCancelled", {
		fg = h("Comment").fg,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownCancelledMainContent", {
		fg = h("Comment").fg,
		strikethrough = true,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownPaused", {
		fg = color_map.warn,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownUrgent", {
		fg = color_map.error,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownOptional", {
		fg = color_map.purple,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownInProgress", {
		fg = color_map.warn,
	})

	vim.api.nvim_set_hl(0, "RenderMarkdownInlineHighlight", {
		bg = color_map.yellow,
		fg = color_map.bg,
		bold = true,
	})
	vim.api.nvim_set_hl(0, "RenderMarkdownTableFill", { link = "Normal" })

	vim.api.nvim_set_hl(0, "IblScope", { fg = color_map.accent })
	vim.api.nvim_set_hl(0, "IblWhitespace", { fg = h("Comment").fg })
	vim.api.nvim_set_hl(0, "NonText", { fg = h("Comment").fg })

	vim.api.nvim_set_hl(
		0,
		"@markup.quote",
		{ fg = color_map.yellow, bold = false }
	)
	vim.api.nvim_set_hl(0, "@markup.italic", {
		fg = color_map.purple_dark,
		italic = true,
	})
	vim.api.nvim_set_hl(0, "@markup.strong", { fg = color_map.red, bold = true })

	vim.api.nvim_set_hl(0, "RainbowRed", { fg = color_map.red })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = color_map.yellow })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = color_map.blue_dark })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = color_map.orange })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = color_map.green })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = color_map.purple_dark })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = color_map.green_light })

	vim.api.nvim_set_hl(
		0,
		"BlinkPairsUnmatched",
		{ fg = color_map.fg, bg = color_map.red, bold = true }
	)
	vim.api.nvim_set_hl(
		0,
		"BlinkPairsMatchParen",
		{ fg = color_map.bg, bg = color_map.green, bold = true }
	)

	vim.api.nvim_set_hl(0, "BranchIndicator", { fg = color_map.blue })
	vim.api.nvim_set_hl(
		0,
		"GitSignsAddInline",
		{ fg = color_map.bg, bg = color_map.green }
	)
	vim.api.nvim_set_hl(
		0,
		"GitSignsAddLnInline",
		{ fg = color_map.bg, bg = color_map.green }
	)
	vim.api.nvim_set_hl(
		0,
		"GitSignsChangeInline",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"GitSignsChangeLnInline",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"GitSignsDeleteInline",
		{ fg = color_map.bg, bg = color_map.red }
	)
	vim.api.nvim_set_hl(
		0,
		"GitSignsDeleteLnInline",
		{ fg = color_map.bg, bg = color_map.red }
	)
	vim.api.nvim_set_hl(
		0,
		"GitSignsChange",
		{ fg = color_map.blue, bg = sidebar_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"GitSignsChangeNr",
		{ fg = color_map.blue, bg = sidebar_bg }
	)

	-- Telescope
	local telescope_bg = color_map.float
	local telescope_prompt_bg = color_map.bg_light
	local telescope_preview_bg = color_map.bg
	local telescope_border = color_map.accent

	vim.api.nvim_set_hl(
		0,
		"TelescopePromptCounter",
		{ fg = color_map.fg_dark, bg = telescope_prompt_bg }
	)
	vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = color_map.float_dark })

	vim.api.nvim_set_hl(
		0,
		"TelescopePromptTitle",
		{ fg = color_map.bg, bg = color_map.accent }
	)
	vim.api.nvim_set_hl(
		0,
		"TelescopePreviewTitle",
		{ fg = color_map.bg, bg = color_map.green }
	)

	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = telescope_prompt_bg })
	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = telescope_prompt_bg })
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = telescope_bg })
	vim.api.nvim_set_hl(
		0,
		"TelescopePreviewNormal",
		{ bg = telescope_preview_bg }
	)

	vim.api.nvim_set_hl(
		0,
		"TelescopePromptBorder",
		{ fg = telescope_border, bg = telescope_prompt_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"TelescopeResultsBorder",
		{ fg = telescope_border, bg = telescope_prompt_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"TelescopeBorder",
		{ fg = telescope_border, bg = telescope_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"TelescopePreviewBorder",
		{ fg = telescope_border, bg = telescope_preview_bg }
	)

	local ts_context_bg = color_map.bg
	local ts_bottom = true
	vim.api.nvim_set_hl(0, "TreesitterContext", {
		bg = ts_context_bg,
	})
	vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
		bg = ts_context_bg,
		sp = color_map.accent,
		underline = ts_bottom,
	})
	vim.api.nvim_set_hl(0, "TreesitterContextSeparator", {
		bg = ts_context_bg,
	})
	local lnr = h("LineNr")
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
		fg = lnr.fg,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", {
		fg = lnr.fg,
		bg = sidebar_bg,
		sp = color_map.accent,
		underline = ts_bottom,
	})

	local pmenu_bg = color_map.float_dark
	local pmenu_sel_bg = color_map.float

	vim.api.nvim_set_hl(0, "Pmenu", { fg = color_map.fg, bg = pmenu_bg })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = pmenu_bg })
	vim.api.nvim_set_hl(0, "PmenuMatch", { bold = true })
	vim.api.nvim_set_hl(0, "PmenuExtra", { bg = pmenu_bg })
	vim.api.nvim_set_hl(0, "PmenuSbar", { fg = color_map.bg_dark, bg = pmenu_bg })
	vim.api.nvim_set_hl(0, "PmenuKind", { link = "Pmenu" })

	vim.api.nvim_set_hl(0, "PmenuSel", { bg = pmenu_sel_bg })
	vim.api.nvim_set_hl(0, "PmenuMatchSel", { bold = true, bg = pmenu_sel_bg })
	vim.api.nvim_set_hl(0, "PmenuExtraSel", { bold = true, bg = pmenu_sel_bg })
	vim.api.nvim_set_hl(0, "PmenuKindSel", { link = "PmenuSel" })

	-- stylua: ignore start
	vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Pmenu" })
	vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "Pmenu" })
	vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "PmenuSel" })
	vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { link = "PmenuThumb" })
	vim.api.nvim_set_hl(0, "BlinkCmpScrollBarGutter", { link = "PmenuSbar" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabel", { link = "Pmenu" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { link = "PmenuExtra" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { link = "Pmenu" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { link = "PmenuExtra" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { link = "PmenuExtra" })
	vim.api.nvim_set_hl(0, "BlinkCmpKind", { link = "PmenuKind" })
	vim.api.nvim_set_hl(0, "BlinkCmpSource", { link = "PmenuExtra" })
	vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { link = "NonText" })
	vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "BlinkCmpDocCursorLine", { link = "Visual" })
	vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpActiveParameter", { link = "LspSignatureActiveParameter" })


	local filesystem = color_map.blue_light
	local func = color_map.blue
	local constant = color_map.orange
	local type = color_map.yellow
	local struct = color_map.yellow
	local keyword = color_map.red
	local async = color_map.purple
	local snippet = color_map.purple_dark
	local variable = color_map.green
	local str = color_map.green_light

	vim.api.nvim_set_hl(0, "LspKindArray", { fg = variable })
	vim.api.nvim_set_hl(0, "LspKindBoolean", { fg = constant })
	vim.api.nvim_set_hl(0, "LspKindClass",{ fg = struct })
	vim.api.nvim_set_hl(0, "LspKindColor",{ fg = constant })
	vim.api.nvim_set_hl(0, "LspKindConstant",{ fg = constant })
	vim.api.nvim_set_hl(0, "LspKindConstructor",{ fg = func })
	vim.api.nvim_set_hl(0, "LspKindEnum",{ fg = struct })
	vim.api.nvim_set_hl(0, "LspKindEnumMember",{ fg = constant })
	vim.api.nvim_set_hl(0, "LspKindEvent",{ fg = async })
	vim.api.nvim_set_hl(0, "LspKindField",{ fg = variable })
	vim.api.nvim_set_hl(0, "LspKindFile",{ fg = filesystem })
	vim.api.nvim_set_hl(0, "LspKindFolder",{ fg = filesystem })
	vim.api.nvim_set_hl(0, "LspKindFunction",{ fg = func })
	vim.api.nvim_set_hl(0, "LspKindInterface",{ fg = struct })
	vim.api.nvim_set_hl(0, "LspKindKey",{ fg = constant })
	vim.api.nvim_set_hl(0, "LspKindKeyword",{ fg = keyword })
	vim.api.nvim_set_hl(0, "LspKindMethod",{ fg = func })
	vim.api.nvim_set_hl(0, "LspKindModule",{ fg = struct })
	vim.api.nvim_set_hl(0, "LspKindNamespace",{ fg = struct })
	vim.api.nvim_set_hl(0, "LspKindNull",{ fg = constant })
	vim.api.nvim_set_hl(0, "LspKindNumber",{ fg = constant })
	vim.api.nvim_set_hl(0, "LspKindObject",{ fg = struct })
	vim.api.nvim_set_hl(0, "LspKindOperator",{ fg = keyword })
	vim.api.nvim_set_hl(0, "LspKindPackage",{ fg = filesystem })
	vim.api.nvim_set_hl(0, "LspKindProperty",{ fg = variable })
	vim.api.nvim_set_hl(0, "LspKindReference",{ fg = keyword })
	vim.api.nvim_set_hl(0, "LspKindSnippet",{ fg = snippet })
	vim.api.nvim_set_hl(0, "LspKindString",{ fg = str })
	vim.api.nvim_set_hl(0, "LspKindStruct",{ fg = struct })
	vim.api.nvim_set_hl(0, "LspKindText",{ fg = str })
	vim.api.nvim_set_hl(0, "LspKindTypeParameter",{ fg = variable })
	vim.api.nvim_set_hl(0, "LspKindUnit",{ fg = struct })
	vim.api.nvim_set_hl(0, "LspKindValue",{ fg = variable })
	vim.api.nvim_set_hl(0, "LspKindVariable",{ fg = variable })


	vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = color_map.bg, bg = color_map.purple_dark })
	vim.api.nvim_set_hl(0, "BlinkCmpKindArray", { fg = color_map.bg, bg = h("LspKindArray").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindBoolean", { fg = color_map.bg, bg = h("LspKindBoolean").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindClass",{ fg = color_map.bg, bg = h("LspKindClass").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindColor",{ fg = color_map.bg, bg = h("LspKindColor").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindConstant",{ fg = color_map.bg, bg = h("LspKindConstant").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindConstructor",{ fg = color_map.bg, bg = h("LspKindConstructor").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindEnum",{ fg = color_map.bg, bg = h("LspKindEnum").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindEnumMember",{ fg = color_map.bg, bg = h("LspKindEnumMember").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindEvent",{ fg = color_map.bg, bg = h("LspKindEvent").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindField",{ fg = color_map.bg, bg = h("LspKindField").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindFile",{ fg = color_map.bg, bg = h("LspKindFile").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindFolder",{ fg = color_map.bg, bg = h("LspKindFolder").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindFunction",{ fg = color_map.bg, bg = h("LspKindFunction").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindInterface",{ fg = color_map.bg, bg = h("LspKindInterface").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindKey",{ fg = color_map.bg, bg = h("LspKindKey").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword",{ fg = color_map.bg, bg = h("LspKindKeyword").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindMethod",{ fg = color_map.bg, bg = h("LspKindMethod").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindModule",{ fg = color_map.bg, bg = h("LspKindModule").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindNamespace",{ fg = color_map.bg, bg = h("LspKindNamespace").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindNull",{ fg = color_map.bg, bg = h("LspKindNull").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindNumber",{ fg = color_map.bg, bg = h("LspKindNumber").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindObject",{ fg = color_map.bg, bg = h("LspKindObject").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindOperator",{ fg = color_map.bg, bg = h("LspKindOperator").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindPackage",{ fg = color_map.bg, bg = h("LspKindPackage").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindProperty",{ fg = color_map.bg, bg = h("LspKindProperty").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindReference",{ fg = color_map.bg, bg = h("LspKindReference").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet",{ fg = color_map.bg, bg = h("LspKindSnippet").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindString",{ fg = color_map.bg, bg = h("LspKindString").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindStruct",{ fg = color_map.bg, bg = h("LspKindStruct").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindText",{ fg = color_map.bg, bg = h("LspKindText").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindTypeParameter",{ fg = color_map.bg, bg = h("LspKindTypeParameter").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindUnit",{ fg = color_map.bg, bg = h("LspKindUnit").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindValue",{ fg = color_map.bg, bg = h("LspKindValue").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindVariable",{ fg = color_map.bg, bg = h("LspKindVariable").fg})
	vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { fg = color_map.bg, bg = color_map.green_light })


	vim.api.nvim_set_hl(0, "NavicText",               { fg = h("Comment").fg, force = true })
	vim.api.nvim_set_hl(0, "NavicSeparator",          { fg = h("Comment").fg, bold = true, force = true })

	vim.api.nvim_set_hl(0, "NavicIconsArray", { link = "LspKindArray" })
	vim.api.nvim_set_hl(0, "NavicIconsBoolean", { link = "LspKindBoolean" })
	vim.api.nvim_set_hl(0, "NavicIconsClass",{ link = "LspKindClass" })
	vim.api.nvim_set_hl(0, "NavicIconsColor",{ link = "LspKindColor" })
	vim.api.nvim_set_hl(0, "NavicIconsConstant",{ link = "LspKindConstant" })
	vim.api.nvim_set_hl(0, "NavicIconsConstructor",{ link = "LspKindConstructor" })
	vim.api.nvim_set_hl(0, "NavicIconsEnum",{ link = "LspKindEnum" })
	vim.api.nvim_set_hl(0, "NavicIconsEnumMember",{ link = "LspKindEnumMember" })
	vim.api.nvim_set_hl(0, "NavicIconsEvent",{ link = "LspKindEvent" })
	vim.api.nvim_set_hl(0, "NavicIconsField",{ link = "LspKindField" })
	vim.api.nvim_set_hl(0, "NavicIconsFile",{ link = "LspKindFile" })
	vim.api.nvim_set_hl(0, "NavicIconsFolder",{ link = "LspKindFolder" })
	vim.api.nvim_set_hl(0, "NavicIconsFunction",{ link = "LspKindFunction" })
	vim.api.nvim_set_hl(0, "NavicIconsInterface",{ link = "LspKindInterface" })
	vim.api.nvim_set_hl(0, "NavicIconsKey",{ link = "LspKindKey" })
	vim.api.nvim_set_hl(0, "NavicIconsKeyword",{ link = "LspKindKeyword" })
	vim.api.nvim_set_hl(0, "NavicIconsMethod",{ link = "LspKindMethod" })
	vim.api.nvim_set_hl(0, "NavicIconsModule",{ link = "LspKindModule" })
	vim.api.nvim_set_hl(0, "NavicIconsNamespace",{ link = "LspKindNamespace" })
	vim.api.nvim_set_hl(0, "NavicIconsNull",{ link = "LspKindNull" })
	vim.api.nvim_set_hl(0, "NavicIconsNumber",{ link = "LspKindNumber" })
	vim.api.nvim_set_hl(0, "NavicIconsObject",{ link = "LspKindObject" })
	vim.api.nvim_set_hl(0, "NavicIconsOperator",{ link = "LspKindOperator" })
	vim.api.nvim_set_hl(0, "NavicIconsPackage",{ link = "LspKindPackage" })
	vim.api.nvim_set_hl(0, "NavicIconsProperty",{ link = "LspKindProperty" })
	vim.api.nvim_set_hl(0, "NavicIconsReference",{ link = "LspKindReference" })
	vim.api.nvim_set_hl(0, "NavicIconsSnippet",{ link = "LspKindSnippet" })
	vim.api.nvim_set_hl(0, "NavicIconsString",{ link = "LspKindString" })
	vim.api.nvim_set_hl(0, "NavicIconsStruct",{ link = "LspKindStruct" })
	vim.api.nvim_set_hl(0, "NavicIconsText",{ link = "LspKindText" })
	vim.api.nvim_set_hl(0, "NavicIconsTypeParameter",{ link = "LspKindTypeParameter" })
	vim.api.nvim_set_hl(0, "NavicIconsUnit",{ link = "LspKindUnit" })
	vim.api.nvim_set_hl(0, "NavicIconsValue",{ link = "LspKindValue" })
	vim.api.nvim_set_hl(0, "NavicIconsVariable",{ link = "LspKindVariable" })
	-- stylua: ignore end

	--scrollbar
	local scroll_handle = color_map.bg_dark
	local scroll_norm = color_map.bg

	vim.api.nvim_set_hl(0, "ScrollbarHandle", { fg = "NONE", bg = scroll_handle })
	vim.api.nvim_set_hl(
		0,
		"ScrollbarCursorHandle",
		{ fg = color_map.accent, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarCursor",
		{ fg = color_map.accent, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarSearchHandle",
		{ fg = color_map.orange, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarSearch",
		{ fg = color_map.orange, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarErrorHandle",
		{ fg = color_map.error, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarError",
		{ fg = color_map.error, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarWarnHandle",
		{ fg = color_map.warn, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarWarn",
		{ fg = color_map.warn, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarInfoHandle",
		{ fg = color_map.info, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarInfo",
		{ fg = color_map.info, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarHintHandle",
		{ fg = color_map.hint, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarHint",
		{ fg = color_map.hint, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarMiscHandle",
		{ fg = color_map.fg, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarMisc",
		{ fg = color_map.fg, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarMarkHandle",
		{ fg = color_map.accent, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarMark",
		{ fg = color_map.accent, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarGitAdd",
		{ fg = color_map.green, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarGitAddHandle",
		{ fg = color_map.green, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarGitChange",
		{ fg = color_map.green, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarGitChangeHandle",
		{ fg = color_map.blue, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarGitDelete",
		{ fg = color_map.blue, bg = scroll_norm }
	)
	vim.api.nvim_set_hl(
		0,
		"ScrollbarGitDeleteHandle",
		{ fg = color_map.red, bg = scroll_handle }
	)
	vim.api.nvim_set_hl(0, "LightBulbVirtualText", { link = "ColorColumn" })

	vim.api.nvim_set_hl(
		0,
		"SymbolUsageRounding",
		{ fg = h("CursorLine").bg, italic = true }
	)
	vim.api.nvim_set_hl(
		0,
		"SymbolUsageContent",
		{ bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
	)
	vim.api.nvim_set_hl(
		0,
		"SymbolUsageRef",
		{ fg = h("Function").fg, bg = h("CursorLine").bg, italic = true }
	)
	vim.api.nvim_set_hl(
		0,
		"SymbolUsageDef",
		{ fg = h("Type").fg, bg = h("CursorLine").bg, italic = true }
	)
	vim.api.nvim_set_hl(
		0,
		"SymbolUsageImpl",
		{ fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true }
	)

	local avante_bg = color_map.float
	local avante_tit_bg = color_map.accent
	local avante_tit_fg = color_map.float
	local avante_sub_bg = color_map.cyan
	local avante_ter_bg = color_map.green

	vim.api.nvim_set_hl(
		0,
		"AvantePromptInput",
		{ fg = color_map.accent, bg = avante_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"AvanteTitle",
		{ fg = avante_tit_fg, bg = avante_tit_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"AvanteReversedTitle",
		{ fg = avante_tit_bg, bg = avante_bg }
	)

	vim.api.nvim_set_hl(
		0,
		"AvanteSubtitle",
		{ fg = avante_tit_fg, bg = avante_sub_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"AvanteReversedSubtitle",
		{ fg = avante_sub_bg, bg = avante_bg }
	)

	vim.api.nvim_set_hl(
		0,
		"AvanteThirdTitle",
		{ fg = avante_tit_fg, bg = avante_ter_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"AvanteReversedThirdTitle",
		{ fg = avante_ter_bg, bg = avante_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"AvantePromptInputBorder",
		{ fg = avante_bg, bg = avante_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"AvanteInputPromptSign",
		{ fg = color_map.accent, bg = avante_bg }
	)

	local tab_active_fg = color_map.bg
	local tab_active_bg = color_map.accent
	local tab_inactive_fg = color_map.fg
	local tab_inactive_bg = color_map.bg_light
	vim.api.nvim_set_hl(
		0,
		"TabLineFill",
		{ fg = tab_inactive_fg, bg = tab_inactive_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"TabLine",
		{ fg = tab_inactive_fg, bg = tab_inactive_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"TabLineSep",
		{ fg = tab_inactive_bg, bg = tab_inactive_fg }
	)
	vim.api.nvim_set_hl(0, "TabLineSel", {
		fg = tab_active_fg,
		bg = tab_active_bg,
	})
	vim.api.nvim_set_hl(0, "TabLineSelSep", {
		fg = tab_active_bg,
		bg = tab_active_fg,
	})
	vim.api.nvim_set_hl(
		0,
		"TabIndex",
		{ fg = tab_active_bg, bg = tab_inactive_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"TabIndexSel",
		{ fg = tab_active_fg, bg = tab_active_bg }
	)

	vim.api.nvim_set_hl(
		0,
		"HarpoonSeparator",
		{ fg = color_map.accent, bg = tab_inactive_bg }
	)
	vim.api.nvim_set_hl(0, "HarpoonInactive", { bg = tab_inactive_bg })
	vim.api.nvim_set_hl(
		0,
		"HarpoonActive",
		{ fg = tab_active_fg, bg = tab_active_bg, bold = true }
	)
	vim.api.nvim_set_hl(
		0,
		"HarpoonNumberActive",
		{ fg = tab_active_fg, bg = tab_active_bg, bold = true }
	)
	vim.api.nvim_set_hl(
		0,
		"HarpoonNumberInactive",
		{ bg = tab_inactive_bg, fg = color_map.accent }
	)

	vim.api.nvim_set_hl(0, "DapBreakpoint", {
		fg = color_map.red,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "DapBreakpointCondition", {
		fg = color_map.purple,
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "DapLogPoint", {
		fg = color_map.yellow,
		bg = sidebar_bg,
	})

	vim.api.nvim_set_hl(
		0,
		"SnacksZenIcon",
		{ fg = color_map.accent, bg = tab_inactive_bg }
	)
	vim.api.nvim_set_hl(0, "SnacksInputNormal", { fg = color_map.accent })
	vim.api.nvim_set_hl(0, "SnacksInputBorder", { fg = color_map.accent })
	vim.api.nvim_set_hl(0, "SnacksInputTitle", { fg = color_map.accent })
	vim.api.nvim_set_hl(0, "SnacksInputIcon", { fg = color_map.green })

	vim.api.nvim_set_hl(0, "UgUndo", { bg = color_map.red_dark })
	vim.api.nvim_set_hl(0, "UgRedo", { bg = color_map.green_dark })
	vim.api.nvim_set_hl(0, "UgYank", { bg = color_map.yellow_dark })
	vim.api.nvim_set_hl(0, "UgPaste", { bg = color_map.cyan_dark })
	vim.api.nvim_set_hl(0, "UgSearch", { bg = color_map.purple_dark })
	vim.api.nvim_set_hl(0, "UgComment", { bg = color_map.orange_dark })
	vim.api.nvim_set_hl(0, "UgCursor", { bg = color_map.pink_dark })

	vim.api.nvim_set_hl(0, "CoverageCovered", { fg = color_map.green })
	vim.api.nvim_set_hl(0, "CoverageUncovered", { fg = color_map.red })
	vim.api.nvim_set_hl(0, "CoveragePartial", { fg = color_map.yellow })

	vim.api.nvim_set_hl(
		0,
		"MyNeoTreeTabInactive",
		{ bg = color_map.bg_light, fg = tab_inactive_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"MyNeoTreeTabActive",
		{ bg = color_map.accent, fg = tab_active_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"MyNeoTreeTabSeparatorInactive",
		{ bg = color_map.bg_light, fg = tab_inactive_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"MyNeoTreeTabSeparatorActive",
		{ bg = color_map.bg_light, fg = color_map.accent }
	)

	local prog_fill = color_map.accent
	local prog_empty = color_map.fg
	vim.api.nvim_set_hl(0, "CodeStatsIcon", { fg = color_map.yellow })
	vim.api.nvim_set_hl(
		0,
		"ProgressFilled",
		{ fg = prog_fill, bg = prog_fill, bold = true }
	)
	vim.api.nvim_set_hl(0, "ProgressEmpty", { fg = prog_empty, bg = prog_empty })
	vim.api.nvim_set_hl(
		0,
		"TextFilled",
		{ fg = "#000000", bg = prog_fill, bold = true }
	) -- same bg as filled bar
	vim.api.nvim_set_hl(
		0,
		"TextEmpty",
		{ fg = "#000000", bg = prog_empty, bold = true }
	) -- same bg as empty bar
	vim.api.nvim_set_hl(0, "ProgressBorder", { fg = "#aaaaaa", bg = "#000000" })

	local fidget_bg = color_map.bg
	local fidget_ns = vim.api.nvim_create_namespace("fidget-window")
	vim.api.nvim_set_hl(
		fidget_ns,
		"FidgetDone",
		{ fg = color_map.green, bg = fidget_bg }
	)
	vim.api.nvim_set_hl(
		fidget_ns,
		"FidgetProgress",
		{ fg = color_map.yellow, bg = fidget_bg }
	)
	vim.api.nvim_set_hl(
		fidget_ns,
		"FidgetGroupName",
		{ fg = color_map.accent, bg = fidget_bg }
	)
	vim.api.nvim_set_hl(
		fidget_ns,
		"FidgetGroupIcon",
		{ fg = color_map.accent, bg = fidget_bg }
	)
	vim.api.nvim_set_hl(
		fidget_ns,
		"FidgetSep",
		{ fg = color_map.accent, bg = fidget_bg }
	)
	vim.api.nvim_set_hl(
		fidget_ns,
		"FidgetWindow",
		{ fg = color_map.fg_dark, bg = fidget_bg }
	)
	vim.api.nvim_set_hl(
		fidget_ns,
		"NormalFloat",
		{ fg = color_map.fg_dark, bg = fidget_bg }
	)

	vim.api.nvim_set_hl(
		0,
		"NvimSeparator",
		{ fg = color_map.accent, bg = sidebar_bg }
	)

	vim.api.nvim_set_hl(0, "OsWin", { fg = "#01beff" })
	vim.api.nvim_set_hl(0, "OsMac", { fg = "#2e2e2e" })

	vim.api.nvim_set_hl(
		0,
		"MarkSignHL",
		{ fg = color_map.accent, bold = true, italic = true }
	)
	vim.api.nvim_set_hl(0, "MarkSignNumHL", { link = "LineNr" })

	local todo_FIX = color_map.red
	local todo_WARN = color_map.yellow
	local todo_NOTE = color_map.green
	local todo_TODO = color_map.cyan
	local todo_PERF = color_map.pink
	local todo_TEST = color_map.purple

	vim.api.nvim_set_hl(0, "TodoBgFIX", { fg = color_map.bg, bg = todo_FIX })
	vim.api.nvim_set_hl(0, "TodoFgFIX", { fg = todo_FIX })
	vim.api.nvim_set_hl(0, "TodoSignFIX", { fg = todo_FIX })

	vim.api.nvim_set_hl(0, "TodoBgHACK", { fg = color_map.bg, bg = todo_WARN })
	vim.api.nvim_set_hl(0, "TodoFgHACK", { fg = todo_WARN })
	vim.api.nvim_set_hl(0, "TodoSignHACK", { fg = todo_WARN })

	vim.api.nvim_set_hl(0, "TodoBgNOTE", { fg = color_map.bg, bg = todo_NOTE })
	vim.api.nvim_set_hl(0, "TodoFgNOTE", { fg = todo_NOTE })
	vim.api.nvim_set_hl(0, "TodoSignNOTE", { fg = todo_NOTE })

	vim.api.nvim_set_hl(0, "TodoBgPERF", { fg = color_map.bg, bg = todo_PERF })
	vim.api.nvim_set_hl(0, "TodoFgPERF", { fg = todo_PERF })
	vim.api.nvim_set_hl(0, "TodoSignPERF", { fg = todo_PERF })

	vim.api.nvim_set_hl(0, "TodoBgTEST", { fg = color_map.bg, bg = todo_TEST })
	vim.api.nvim_set_hl(0, "TodoFgTEST", { fg = todo_TEST })
	vim.api.nvim_set_hl(0, "TodoSignTEST", { fg = todo_TEST })

	vim.api.nvim_set_hl(0, "TodoBgTODO", { fg = color_map.bg, bg = todo_TODO })
	vim.api.nvim_set_hl(0, "TodoFgTODO", { fg = todo_TODO })
	vim.api.nvim_set_hl(0, "TodoSignTODO", { fg = todo_TODO })

	vim.api.nvim_set_hl(0, "TodoBgWARN", { fg = color_map.bg, bg = todo_WARN })
	vim.api.nvim_set_hl(0, "TodoFgWARN", { fg = todo_WARN })
	vim.api.nvim_set_hl(0, "TodoSignWARN", { fg = todo_WARN })

	local usage_bg = "NONE"

	--stylua: ignore start
	vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg=usage_bg })
	vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg= h("Comment").fg, bg=usage_bg })
	vim.api.nvim_set_hl(0, "SymbolUsageText", { fg = h("Comment").fg, bg = usage_bg, italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg=color_map.cyan, bg=usage_bg })
	vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg=color_map.yellow, bg=usage_bg })
	vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg=color_map.purple, bg=usage_bg })
	--stylua: ignore end
end

return M
