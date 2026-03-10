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

	local function set_hl(names, val)
		if type(names) == "string" then
			vim.api.nvim_set_hl(0, names, val)
		else
			vim.iter(names):each(function(name)
				vim.api.nvim_set_hl(0, name, val)
			end)
		end
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

	set_hl("TransB", { bg = "#5bcffa" })
	set_hl("TransP", { bg = "#ffb5cd" })
	set_hl("TransW", { bg = "#ffffff" })

	local sidebar_bg = color_map.bg_dark
	set_hl("SignColumn", {
		bg = sidebar_bg,
	})
	set_hl("EndOfBuffer", {
		bg = "NONE",
		fg = color_map.bg,
	})
	set_hl("LineNr", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	set_hl("LineNrAbove", {
		fg = h("Comment").fg,
		bg = sidebar_bg,
	})
	set_hl("LineNrBelow", {
		fg = h("Comment").fg,
		bg = sidebar_bg,
	})
	set_hl("CursorLineSign", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	set_hl("CursorLineNr", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	set_hl("FoldColumn", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	set_hl("CursorLineFold", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	set_hl("Folded", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	set_hl("SpellBad", {
		fg = color_map.error,
		undercurl = true,
	})
	set_hl({ "SpellRare", "SpellLocal" }, {
		fg = color_map.warn,
		undercurl = true,
	})

	set_hl("SpellCap", {
		undercurl = true,
	})

	set_hl("NormalFloat", {
		fg = color_map.fg,
		bg = color_map.float,
	})
	set_hl("FloatBorder", {
		fg = color_map.accent,
		bg = color_map.float,
	})
	set_hl("WinSeparator", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})
	set_hl("ColorfulWinSep", {
		fg = color_map.accent,
		bg = sidebar_bg,
	})

	set_hl("LspSignatureActiveParameter", {
		fg = color_map.bg,
		bg = color_map.accent,
		italic = true,
	})

	vim.api.nvim_set_hl(
		0,
		"LspInlayHint",
		{ fg = h("Comment").fg, italic = true }
	)

	local statusline_bg = sidebar_bg
	set_hl("StatusLine", {
		fg = color_map.fg,
		bg = statusline_bg,
	})
	set_hl("StatusLineNC", {
		fg = color_map.fg,
		bg = statusline_bg,
	})
	set_hl("WinBar", {
		link = "StatusLine",
	})
	set_hl("WinBarNC", {
		link = "StatusLineNC",
	})

	set_hl("DiagnosticCheck", { fg = color_map.green })

	for _, level in pairs({ "Error", "Warn", "Info", "Hint" }) do
		set_hl("Diagnostic" .. level, {
			fg = color_map[level:lower()],
		})
		set_hl("DiagnosticVirtualText" .. level, {
			fg = color_map[level:lower()],
		})
		set_hl("DiagnosticVirtualLines" .. level, {
			fg = color_map[level:lower()],
		})
		set_hl("DiagnosticSign" .. level, {
			fg = color_map[level:lower()],
		})
		set_hl("BarDiag" .. level, {
			link = "Diagnostic" .. level,
		})
		set_hl("Diagnostic" .. level .. "Num", {
			link = "Diagnostic" .. level,
			bold = true,
			italic = true,
		})
	end
	set_hl("SessionAuto", {
		fg = color_map.yellow,
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
	set_hl("CodeBlock", { bg = color_map.bg_dark })
	set_hl("RenderMarkdownCode", { bg = color_map.bg_dark })
	set_hl("HeadingBullet", { fg = color_map.surface_dark })
	set_hl("Conceal", { bg = color_map.bg })
	set_hl("RenderMarkdownDash", { bg = "NONE", fg = color_map.fg })
	set_hl("RenderMarkdownWikiLink", { fg = color_map.cyan })
	set_hl("markdownFootnote", { fg = color_map.cyan_dark, bold = true })

	local mdh1 = color_map.green
	local mdh2 = color_map.orange
	local mdh3 = color_map.purple
	local mdh4 = color_map.blue_dark
	local mdh5 = color_map.yellow
	local mdh6 = color_map.red
	set_hl({
		"@markup.heading.1.markdown",
		"RenderMarkdownH1",
		"markdownH1",
	}, { fg = mdh1, bold = true })
	set_hl({ "RenderMarkdownH1Bg" }, {
		fg = mdh1,
		--
	})
	set_hl("RenderMarkdown_RenderMarkdownH1Bg_bg_as_fg", { fg = mdh1 })

	set_hl(
		{ "@markup.heading.2.markdown", "RenderMarkdownH2", "markdownH2" },
		{ fg = mdh2, bold = true }
	)
	set_hl({ "RenderMarkdownH2Bg" }, {
		fg = mdh2,
		-- fg = color_map.bg,
	})
	set_hl(
		"RenderMarkdown_RenderMarkdownH2Bg_bg_as_fg",
		{ fg = mdh2, force = true }
	)
	set_hl(
		{ "@markup.heading.3.markdown", "RenderMarkdownH3", "markdownH3" },
		{ fg = mdh3, bold = true }
	)
	set_hl({ "RenderMarkdownH3Bg" }, {
		fg = mdh3,
		-- fg = color_map.bg,
	})
	set_hl(
		"RenderMarkdown_RenderMarkdownH3Bg_bg_as_fg",
		{ fg = mdh3, force = true }
	)
	set_hl(
		{ "@markup.heading.4.markdown", "RenderMarkdownH4", "markdownH4" },
		{ fg = mdh4, bold = true }
	)
	set_hl({ "RenderMarkdownH4Bg" }, {
		fg = mdh4,
		-- fg = color_map.bg,
	})
	set_hl(
		"RenderMarkdown_RenderMarkdownH4Bg_bg_as_fg",
		{ fg = mdh4, force = true }
	)
	set_hl(
		{ "@markup.heading.5.markdown", "RenderMarkdownH5", "markdownH5" },
		{ fg = mdh5, bold = true }
	)
	set_hl({ "RenderMarkdownH5Bg" }, {
		fg = mdh5,
		-- fg = color_map.bg,
	})
	set_hl(
		"RenderMarkdown_RenderMarkdownH5Bg_bg_as_fg",
		{ fg = mdh5, force = true }
	)
	set_hl(
		{ "@markup.heading.6.markdown", "RenderMarkdownH6", "markdownH6" },
		{ fg = mdh6, bold = true }
	)
	set_hl({ "RenderMarkdownH6Bg" }, {
		fg = mdh6,
		-- fg = color_map.bg,
	})
	set_hl(
		"RenderMarkdown_RenderMarkdownH6Bg_bg_as_fg",
		{ fg = mdh6, force = true }
	)

	set_hl("RenderMarkdownChecked", {
		fg = color_map.green,
	})
	set_hl("RenderMarkdownUnchecked", {
		fg = color_map.blue,
	})
	set_hl("RenderMarkdownCancelled", {
		fg = h("Comment").fg,
	})
	set_hl("RenderMarkdownCancelledMainContent", {
		fg = h("Comment").fg,
		strikethrough = true,
	})
	set_hl("RenderMarkdownPaused", {
		fg = color_map.warn,
	})
	set_hl("RenderMarkdownUrgent", {
		fg = color_map.error,
	})
	set_hl("RenderMarkdownOptional", {
		fg = color_map.purple,
	})
	set_hl("RenderMarkdownInProgress", {
		fg = color_map.warn,
	})

	set_hl("RenderMarkdownInlineHighlight", {
		bg = color_map.yellow,
		fg = color_map.bg,
		bold = true,
	})
	set_hl("RenderMarkdownTableFill", { link = "Normal" })

	set_hl("TaskMeta_done", { fg = color_map.green })
	set_hl("TaskMeta_started", { fg = color_map.yellow })
	set_hl("TaskMeta_prio_high", { fg = color_map.red, bold = true })
	set_hl("TaskMeta_prio_medium", { fg = color_map.orange })
	set_hl("TaskMeta_prio_low", { fg = color_map.blue_light })

	set_hl("IblScope", { fg = color_map.accent })
	set_hl("IblWhitespace", { fg = h("Comment").fg })
	set_hl("NonText", { fg = color_map.bg_light })

	vim.api.nvim_set_hl(
		0,
		"@markup.quote",
		{ fg = color_map.yellow, bold = false }
	)
	set_hl("@markup.italic", {
		fg = color_map.purple_dark,
		italic = true,
	})
	set_hl("@markup.strong", { fg = color_map.red, bold = true })

	set_hl("RainbowRed", { fg = color_map.red })
	set_hl("RainbowYellow", { fg = color_map.yellow })
	set_hl("RainbowBlue", { fg = color_map.blue_dark })
	set_hl("RainbowOrange", { fg = color_map.orange })
	set_hl("RainbowGreen", { fg = color_map.green })
	set_hl("RainbowViolet", { fg = color_map.purple_dark })
	set_hl("RainbowCyan", { fg = color_map.green_light })

	vim.api.nvim_set_hl(
		0,
		"BlinkPairsUnmatched",
		{ fg = color_map.fg, bg = color_map.red, bold = true }
	)
	vim.api.nvim_set_hl(
		0,
		"BlinkPairsMatchParen",
		{ fg = color_map.bg, bg = color_map.accent, bold = true }
	)

	vim.api.nvim_set_hl(
		0,
		"DiffAdd",
		{ bg = color_map.green_light, fg = color_map.green_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"DiffChange",
		{ bg = color_map.blue_light, fg = color_map.blue_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"DiffDelete",
		{ bg = color_map.red_light, fg = color_map.red_dark }
	)
	set_hl("DiffText", {
		fg = color_map.bg,
		underline = true,
	})

	set_hl("BranchIndicator", { fg = color_map.blue })
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
	vim.api.nvim_set_hl(
		0,
		"GitSignsAdd",
		{ fg = color_map.green, bg = sidebar_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"GitSignsDelete",
		{ fg = color_map.red_light, bg = sidebar_bg }
	)
	set_hl("GitSignsChangedelete", {
		fg = color_map.blue,
		bg = color_map.red,
	})

	-- Telescope
	local telescope_bg = color_map.float
	local telescope_prompt_bg = color_map.bg_light
	local telescope_preview_bg = color_map.bg
	local telescope_border = color_map.accent

	vim.api.nvim_set_hl(
		0,
		"TelescopeSelectionCaret",
		{ fg = color_map.accent, bg = telescope_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"TelescopePromptCounter",
		{ fg = color_map.fg_dark, bg = telescope_prompt_bg }
	)
	set_hl("TelescopeSelection", { bg = color_map.float_dark })

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

	set_hl("TelescopePromptNormal", { bg = telescope_prompt_bg })
	set_hl("TelescopeResultsNormal", { bg = telescope_prompt_bg })
	set_hl("TelescopeNormal", { bg = telescope_bg })
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
	set_hl("TreesitterContext", {
		bg = ts_context_bg,
	})
	set_hl("TreesitterContextBottom", {
		bg = ts_context_bg,
		sp = color_map.accent,
		underline = ts_bottom,
	})
	set_hl("TreesitterContextSeparator", {
		bg = ts_context_bg,
	})
	local lnr = h("LineNrAbove")
	set_hl("TreesitterContextLineNumber", {
		fg = lnr.fg,
		bg = sidebar_bg,
	})
	set_hl("TreesitterContextLineNumberBottom", {
		fg = lnr.fg,
		bg = sidebar_bg,
		sp = color_map.accent,
		underline = ts_bottom,
	})

	local pmenu_bg = color_map.float_dark
	local pmenu_sel_bg = color_map.float

	set_hl("Pmenu", { fg = color_map.fg, bg = pmenu_bg })
	set_hl("PmenuThumb", { bg = pmenu_bg })
	set_hl("PmenuMatch", { bold = true })
	set_hl("PmenuExtra", { bg = pmenu_bg })
	set_hl("PmenuSbar", { fg = color_map.bg_dark, bg = pmenu_bg })
	set_hl("PmenuKind", { link = "Pmenu" })

	set_hl("PmenuSel", { bg = pmenu_sel_bg })
	set_hl("PmenuMatchSel", { bold = true, bg = pmenu_sel_bg })
	set_hl("PmenuExtraSel", { bold = true, bg = pmenu_sel_bg })
	set_hl("PmenuKindSel", { link = "PmenuSel" })

	-- stylua: ignore start
	set_hl("BlinkCmpMenu", { link = "Pmenu" })
	set_hl("BlinkCmpMenuBorder", { link = "Pmenu" })
	set_hl("BlinkCmpMenuSelection", { link = "PmenuSel" })
	set_hl("BlinkCmpScrollBarThumb", { link = "PmenuThumb" })
	set_hl("BlinkCmpScrollBarGutter", { link = "PmenuSbar" })
	set_hl("BlinkCmpLabel", { link = "Pmenu" })
	set_hl("BlinkCmpLabelDeprecated", { link = "PmenuExtra" })
	set_hl("BlinkCmpLabelMatch", { link = "Pmenu" })
	set_hl("BlinkCmpLabelDetail", { link = "PmenuExtra" })
	set_hl("BlinkCmpLabelDescription", { link = "PmenuExtra" })
	set_hl("BlinkCmpKind", { link = "PmenuKind" })
	set_hl("BlinkCmpSource", { link = "PmenuExtra" })
	set_hl("BlinkCmpGhostText", { link = "NonText" })
	set_hl("BlinkCmpDoc", { link = "NormalFloat" })
	set_hl("BlinkCmpDocBorder", { link = "NormalFloat" })
	set_hl("BlinkCmpDocSeparator", { link = "NormalFloat" })
	set_hl("BlinkCmpDocCursorLine", { link = "Visual" })
	set_hl("BlinkCmpSignatureHelp", { link = "NormalFloat" })
	set_hl("BlinkCmpSignatureHelpBorder", { link = "NormalFloat" })
	set_hl("BlinkCmpSignatureHelpActiveParameter", { link = "LspSignatureActiveParameter" })



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

	set_hl("LspKindArray", { fg = variable })
	set_hl("LspKindBoolean", { fg = constant })
	set_hl("LspKindClass",{ fg = struct })
	set_hl("LspKindColor",{ fg = constant })
	set_hl("LspKindConstant",{ fg = constant })
	set_hl("LspKindConstructor",{ fg = func })
	set_hl("LspKindEnum",{ fg = struct })
	set_hl("LspKindEnumMember",{ fg = constant })
	set_hl("LspKindEvent",{ fg = async })
	set_hl("LspKindField",{ fg = variable })
	set_hl("LspKindFile",{ fg = filesystem })
	set_hl("LspKindFolder",{ fg = filesystem })
	set_hl("LspKindFunction",{ fg = func })
	set_hl("LspKindInterface",{ fg = struct })
	set_hl("LspKindKey",{ fg = constant })
	set_hl("LspKindKeyword",{ fg = keyword })
	set_hl("LspKindMethod",{ fg = func })
	set_hl("LspKindModule",{ fg = struct })
	set_hl("LspKindNamespace",{ fg = struct })
	set_hl("LspKindNull",{ fg = constant })
	set_hl("LspKindNumber",{ fg = constant })
	set_hl("LspKindObject",{ fg = struct })
	set_hl("LspKindOperator",{ fg = keyword })
	set_hl("LspKindPackage",{ fg = filesystem })
	set_hl("LspKindProperty",{ fg = variable })
	set_hl("LspKindReference",{ fg = keyword })
	set_hl("LspKindSnippet",{ fg = snippet })
	set_hl("LspKindString",{ fg = str })
	set_hl("LspKindStruct",{ fg = struct })
	set_hl("LspKindText",{ fg = str })
	set_hl("LspKindTypeParameter",{ fg = variable })
	set_hl("LspKindUnit",{ fg = struct })
	set_hl("LspKindValue",{ fg = variable })
	set_hl("LspKindVariable",{ fg = variable })


	set_hl("BlinkCmpKindCopilot", { fg = color_map.bg, bg = color_map.green_light })

	set_hl("BlinkCmpKind", { fg = color_map.bg, bg = color_map.purple_dark })
	set_hl("BlinkCmpKindArray", { fg = color_map.bg, bg = h("LspKindArray").fg})
	set_hl("BlinkCmpKindBoolean", { fg = color_map.bg, bg = h("LspKindBoolean").fg})
	set_hl("BlinkCmpKindClass",{ fg = color_map.bg, bg = h("LspKindClass").fg})
	set_hl("BlinkCmpKindColor",{ fg = color_map.bg, bg = h("LspKindColor").fg})
	set_hl("BlinkCmpKindConstant",{ fg = color_map.bg, bg = h("LspKindConstant").fg})
	set_hl("BlinkCmpKindConstructor",{ fg = color_map.bg, bg = h("LspKindConstructor").fg})
	set_hl("BlinkCmpKindEnum",{ fg = color_map.bg, bg = h("LspKindEnum").fg})
	set_hl("BlinkCmpKindEnumMember",{ fg = color_map.bg, bg = h("LspKindEnumMember").fg})
	set_hl("BlinkCmpKindEvent",{ fg = color_map.bg, bg = h("LspKindEvent").fg})
	set_hl("BlinkCmpKindField",{ fg = color_map.bg, bg = h("LspKindField").fg})
	set_hl("BlinkCmpKindFile",{ fg = color_map.bg, bg = h("LspKindFile").fg})
	set_hl("BlinkCmpKindFolder",{ fg = color_map.bg, bg = h("LspKindFolder").fg})
	set_hl("BlinkCmpKindFunction",{ fg = color_map.bg, bg = h("LspKindFunction").fg})
	set_hl("BlinkCmpKindInterface",{ fg = color_map.bg, bg = h("LspKindInterface").fg})
	set_hl("BlinkCmpKindKey",{ fg = color_map.bg, bg = h("LspKindKey").fg})
	set_hl("BlinkCmpKindKeyword",{ fg = color_map.bg, bg = h("LspKindKeyword").fg})
	set_hl("BlinkCmpKindMethod",{ fg = color_map.bg, bg = h("LspKindMethod").fg})
	set_hl("BlinkCmpKindModule",{ fg = color_map.bg, bg = h("LspKindModule").fg})
	set_hl("BlinkCmpKindNamespace",{ fg = color_map.bg, bg = h("LspKindNamespace").fg})
	set_hl("BlinkCmpKindNull",{ fg = color_map.bg, bg = h("LspKindNull").fg})
	set_hl("BlinkCmpKindNumber",{ fg = color_map.bg, bg = h("LspKindNumber").fg})
	set_hl("BlinkCmpKindObject",{ fg = color_map.bg, bg = h("LspKindObject").fg})
	set_hl("BlinkCmpKindOperator",{ fg = color_map.bg, bg = h("LspKindOperator").fg})
	set_hl("BlinkCmpKindPackage",{ fg = color_map.bg, bg = h("LspKindPackage").fg})
	set_hl("BlinkCmpKindProperty",{ fg = color_map.bg, bg = h("LspKindProperty").fg})
	set_hl("BlinkCmpKindReference",{ fg = color_map.bg, bg = h("LspKindReference").fg})
	set_hl("BlinkCmpKindSnippet",{ fg = color_map.bg, bg = h("LspKindSnippet").fg})
	set_hl("BlinkCmpKindString",{ fg = color_map.bg, bg = h("LspKindString").fg})
	set_hl("BlinkCmpKindStruct",{ fg = color_map.bg, bg = h("LspKindStruct").fg})
	set_hl("BlinkCmpKindText",{ fg = color_map.bg, bg = h("LspKindText").fg})
	set_hl("BlinkCmpKindDict",{ fg = color_map.bg, bg = h("LspKindText").fg})
	set_hl("BlinkCmpKindTypeParameter",{ fg = color_map.bg, bg = h("LspKindTypeParameter").fg})
	set_hl("BlinkCmpKindUnit",{ fg = color_map.bg, bg = h("LspKindUnit").fg})
	set_hl("BlinkCmpKindValue",{ fg = color_map.bg, bg = h("LspKindValue").fg})
	set_hl("BlinkCmpKindVariable",{ fg = color_map.bg, bg = h("LspKindVariable").fg})


	set_hl("NavicText",               { fg = h("Comment").fg, force = true })
	set_hl("NavicSeparator",          { fg = h("Comment").fg, bold = true, force = true })

	set_hl("NavicIconsArray", { link = "LspKindArray" })
	set_hl("NavicIconsBoolean", { link = "LspKindBoolean" })
	set_hl("NavicIconsClass",{ link = "LspKindClass" })
	set_hl("NavicIconsColor",{ link = "LspKindColor" })
	set_hl("NavicIconsConstant",{ link = "LspKindConstant" })
	set_hl("NavicIconsConstructor",{ link = "LspKindConstructor" })
	set_hl("NavicIconsEnum",{ link = "LspKindEnum" })
	set_hl("NavicIconsEnumMember",{ link = "LspKindEnumMember" })
	set_hl("NavicIconsEvent",{ link = "LspKindEvent" })
	set_hl("NavicIconsField",{ link = "LspKindField" })
	set_hl("NavicIconsFile",{ link = "LspKindFile" })
	set_hl("NavicIconsFolder",{ link = "LspKindFolder" })
	set_hl("NavicIconsFunction",{ link = "LspKindFunction" })
	set_hl("NavicIconsInterface",{ link = "LspKindInterface" })
	set_hl("NavicIconsKey",{ link = "LspKindKey" })
	set_hl("NavicIconsKeyword",{ link = "LspKindKeyword" })
	set_hl("NavicIconsMethod",{ link = "LspKindMethod" })
	set_hl("NavicIconsModule",{ link = "LspKindModule" })
	set_hl("NavicIconsNamespace",{ link = "LspKindNamespace" })
	set_hl("NavicIconsNull",{ link = "LspKindNull" })
	set_hl("NavicIconsNumber",{ link = "LspKindNumber" })
	set_hl("NavicIconsObject",{ link = "LspKindObject" })
	set_hl("NavicIconsOperator",{ link = "LspKindOperator" })
	set_hl("NavicIconsPackage",{ link = "LspKindPackage" })
	set_hl("NavicIconsProperty",{ link = "LspKindProperty" })
	set_hl("NavicIconsReference",{ link = "LspKindReference" })
	set_hl("NavicIconsSnippet",{ link = "LspKindSnippet" })
	set_hl("NavicIconsString",{ link = "LspKindString" })
	set_hl("NavicIconsStruct",{ link = "LspKindStruct" })
	set_hl("NavicIconsText",{ link = "LspKindText" })
	set_hl("NavicIconsTypeParameter",{ link = "LspKindTypeParameter" })
	set_hl("NavicIconsUnit",{ link = "LspKindUnit" })
	set_hl("NavicIconsValue",{ link = "LspKindValue" })
	set_hl("NavicIconsVariable",{ link = "LspKindVariable" })
	-- stylua: ignore end

	--scrollbar
	local scroll_handle = color_map.bg_dark
	local scroll_norm = color_map.bg

	-- set_hl("ScrollView", {
	-- 	fg = "NONE",
	-- })
	set_hl("ScrollViewCursor", { fg = color_map.accent, bg = "NONE" })
	set_hl("ScrollViewMarks", { fg = color_map.purple_light, bg = "NONE" })
	set_hl("ScrollViewSearch", { fg = color_map.orange, bg = "NONE" })
	set_hl("ScrollViewSpell", { fg = color_map.error, bg = "NONE" })

	set_hl("LightBulbVirtualText", { link = "ColorColumn" })

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
	local tab_inactive_bg = statusline_bg
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
	set_hl("TabLineSel", {
		fg = tab_active_fg,
		bg = tab_active_bg,
	})
	set_hl("TabLineSelSep", {
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
	set_hl("HarpoonInactive", { bg = tab_inactive_bg })
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

	set_hl("DapBreakpoint", {
		fg = color_map.red,
		bg = sidebar_bg,
	})
	set_hl("DapBreakpointCondition", {
		fg = color_map.purple,
		bg = sidebar_bg,
	})
	set_hl("DapLogPoint", {
		fg = color_map.yellow,
		bg = sidebar_bg,
	})

	vim.api.nvim_set_hl(
		0,
		"SnacksZenIcon",
		{ fg = color_map.accent, bg = tab_inactive_bg }
	)
	set_hl("SnacksInputNormal", { fg = color_map.accent })
	set_hl("SnacksInputBorder", { fg = color_map.accent })
	set_hl("SnacksInputTitle", { fg = color_map.accent })
	set_hl("SnacksInputIcon", { fg = color_map.green })
	set_hl("SnacksDim", { fg = color_map.bg_light })

	set_hl("UgUndo", { bg = color_map.red_dark })
	set_hl("UgRedo", { bg = color_map.green_dark })
	set_hl("UgYank", { bg = color_map.yellow_dark })
	set_hl("UgPaste", { bg = color_map.cyan_dark })
	set_hl("UgSearch", { bg = color_map.purple_dark })
	set_hl("UgComment", { bg = color_map.orange_dark })
	set_hl("UgCursor", { bg = color_map.pink_dark })

	set_hl("CoverageCovered", { fg = color_map.green })
	set_hl("CoverageUncovered", { fg = color_map.red })
	set_hl("CoveragePartial", { fg = color_map.yellow })

	vim.api.nvim_set_hl(
		0,
		"MyNeoTreeTabInactive",
		{ bg = statusline_bg, fg = tab_inactive_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"MyNeoTreeTabActive",
		{ bg = color_map.accent, fg = tab_active_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"MyNeoTreeTabSeparatorInactive",
		{ bg = statusline_bg, fg = tab_inactive_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"MyNeoTreeTabSeparatorActive",
		{ bg = statusline_bg, fg = color_map.accent }
	)

	local prog_fill = color_map.accent
	local prog_empty = color_map.bg_light
	set_hl("CodeStatsIcon", { fg = color_map.yellow })
	vim.api.nvim_set_hl(
		0,
		"ProgressFilled",
		{ fg = prog_fill, bg = prog_fill, bold = true }
	)
	set_hl("ProgressEmpty", { fg = prog_empty, bg = prog_empty })
	vim.api.nvim_set_hl(
		0,
		"TextFilled",
		{ fg = color_map.fg, bg = prog_fill, bold = true }
	)
	vim.api.nvim_set_hl(
		0,
		"TextEmpty",
		{ fg = color_map.fg, bg = prog_empty, bold = true }
	)
	set_hl("ProgressBorder", { fg = "#aaaaaa", bg = "#000000" })

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

	set_hl("OsWin", { fg = "#01beff" })
	set_hl("OsMac", { fg = "#2e2e2e" })

	vim.api.nvim_set_hl(
		0,
		"MarkSignHL",
		{ fg = color_map.accent, bold = true, italic = true }
	)
	set_hl("MarkSignNumHL", { link = "LineNr" })

	local todo_FIX = color_map.red
	local todo_WARN = color_map.yellow
	local todo_NOTE = color_map.green
	local todo_TODO = color_map.cyan
	local todo_PERF = color_map.pink
	local todo_TEST = color_map.purple

	set_hl("TodoBgFIX", { fg = color_map.bg, bg = todo_FIX })
	set_hl("TodoFgFIX", { fg = todo_FIX })
	set_hl("TodoSignFIX", { fg = todo_FIX })

	set_hl("TodoBgHACK", { fg = color_map.bg, bg = todo_WARN })
	set_hl("TodoFgHACK", { fg = todo_WARN })
	set_hl("TodoSignHACK", { fg = todo_WARN })

	set_hl("TodoBgNOTE", { fg = color_map.bg, bg = todo_NOTE })
	set_hl("TodoFgNOTE", { fg = todo_NOTE })
	set_hl("TodoSignNOTE", { fg = todo_NOTE })

	set_hl("TodoBgPERF", { fg = color_map.bg, bg = todo_PERF })
	set_hl("TodoFgPERF", { fg = todo_PERF })
	set_hl("TodoSignPERF", { fg = todo_PERF })

	set_hl("TodoBgTEST", { fg = color_map.bg, bg = todo_TEST })
	set_hl("TodoFgTEST", { fg = todo_TEST })
	set_hl("TodoSignTEST", { fg = todo_TEST })

	set_hl("TodoBgTODO", { fg = color_map.bg, bg = todo_TODO })
	set_hl("TodoFgTODO", { fg = todo_TODO })
	set_hl("TodoSignTODO", { fg = todo_TODO })

	set_hl("TodoBgWARN", { fg = color_map.bg, bg = todo_WARN })
	set_hl("TodoFgWARN", { fg = todo_WARN })
	set_hl("TodoSignWARN", { fg = todo_WARN })

	local usage_bg = "NONE"

	--stylua: ignore start
	set_hl("SymbolUsageRounding", { fg=usage_bg })
	set_hl("SymbolUsageContent", { fg= h("Comment").fg, bg=usage_bg })
	set_hl("SymbolUsageText", { fg = h("Comment").fg, bg = usage_bg, italic = true })
	set_hl("SymbolUsageImpl", { fg=color_map.cyan, bg=usage_bg })
	set_hl("SymbolUsageRef", { fg=color_map.yellow, bg=usage_bg })
	set_hl("SymbolUsageDef", { fg=color_map.purple, bg=usage_bg })
	--stylua: ignore end

	require("lualine.config").apply_configuration({
		options = {
			theme = {
				normal = {
					a = { bg = statusline_bg, fg = color_map.fg },
					b = { bg = statusline_bg, fg = color_map.fg },
					c = { bg = statusline_bg, fg = color_map.fg },
				},

				insert = {
					a = { bg = statusline_bg, fg = color_map.fg },
					b = { bg = statusline_bg, fg = color_map.fg },
				},

				command = {
					a = { bg = statusline_bg, fg = color_map.fg },
					b = { bg = statusline_bg, fg = color_map.fg },
				},

				visual = {
					a = { bg = statusline_bg, fg = color_map.fg },
					b = { bg = statusline_bg, fg = color_map.fg },
				},

				replace = {
					a = { bg = statusline_bg, fg = color_map.fg },
					b = { bg = statusline_bg, fg = color_map.fg },
				},

				terminal = {
					a = { bg = statusline_bg, fg = color_map.fg },
					b = { bg = statusline_bg, fg = color_map.fg },
				},

				inactive = {
					a = { bg = statusline_bg, fg = color_map.fg },
					b = { bg = statusline_bg, fg = color_map.fg },
					c = { bg = statusline_bg, fg = color_map.fg },
				},
			},
		},
	})
	-- require("lualine").refresh()
end

return M
