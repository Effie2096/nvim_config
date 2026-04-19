return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		local kanagawa = require("kanagawa")

		vim.api.nvim_create_augroup("kanagawa_auto_compile", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			pattern = { "color.lua" },
			callback = function()
				local path = vim.fn.stdpath("config")
				vim.cmd(
					"luafile "
					.. vim.fn.glob(path .. "/lua/faith/plugins/color.lua")
				)
				vim.cmd.KanagawaCompile()
				return true
			end,
			group = "kanagawa_auto_compile",
		})

		kanagawa.setup({
			compile = true,             -- enable compiling the colorscheme
			undercurl = true,            -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true},
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false,         -- do not set background color
			dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
			terminalColors = true,       -- define vim.g.terminal_color_{0,17}
			colors = {                   -- add/modify theme and palette colors
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors)
				local palette = colors.palette
				local theme = colors.theme

				local accent = palette.sakuraPink

				local telescope_bg = theme.ui.bg
				local telescope_prompt_bg = theme.ui.bg
				local telescope_preview_bg = theme.ui.bg_dim
				local telescope_border = palette.sakuraPink

				local mdh1 = theme.syn.string
				local mdh2 = theme.syn.constant
				local mdh3 = theme.syn.keyword
				local mdh4 = theme.syn.fun
				local mdh5 = theme.syn.identifier
				local mdh6 = theme.syn.special2


				local filesystem = theme.syn.special1
				local func = theme.syn.fun
				local constant = theme.syn.constant
				local type = theme.syn.type
				local struct = theme.syn.type
				local keyword = theme.syn.keyword
				local async = theme.syn.punct
				local snippet = theme.syn.statement
				local variable = theme.syn.variable
				local str = theme.syn.string


				return {
					EndOfBuffer = { bg = "NONE", fg = theme.ui.bg },
					StatusLine = { bg = theme.ui.bg_gutter },
					StatusLineNC = { link = "StatusLine" },
					WinBar = { link = "StatusLine" },
					WinBarNC = { link = "StatusLine" },

					TelescopeSelectionCaret = { fg = accent, bg = theme.ui.bg_dim },

					TelescopePromptCounter = { fg = theme.ui.fg_dim, bg = telescope_prompt_bg },
					TelescopeSelection = { bg = theme.ui.bg_dim },

					TelescopePromptTitle = { fg = theme.ui.bg, bg = accent },
					TelescopePreviewTitle = { fg = theme.ui.bg, bg = accent },

					TelescopeNormal = { bg = telescope_bg },
					TelescopePromptNormal = { bg = telescope_prompt_bg },
					TelescopeResultsNormal = { bg = telescope_prompt_bg },
					TelescopePreviewNormal = { bg = telescope_preview_bg },

					TelescopeBorder = { fg = telescope_border, bg = telescope_bg },
					TelescopePromptBorder = { fg = telescope_border, bg = telescope_prompt_bg },
					TelescopeResultsBorder = { fg = telescope_border, bg = telescope_prompt_bg },
					TelescopePreviewBorder = { fg = telescope_border, bg = telescope_preview_bg },

					IblScope = { fg = accent },

					CodeBlock = { bg = theme.ui.bg_dim },
					RenderMarkdownCode = { bg = theme.ui.bg_dim },

					["@markup.heading.1.markdown"] = { fg = mdh1, bold = true },
					RenderMarkdownH1 = { link = "@markup.heading.1.markdown" },
					markdownH1 = { link = "@markup.heading.1.markdown" },
					RenderMarkdownH1Bg = { fg = mdh1, },
					RenderMarkdown_RenderMarkdownH1Bg_bg_as_fg= { fg = mdh1 },

					["@markup.heading.2.markdown"] = { fg = mdh2, bold = true },
					RenderMarkdownH2 = { link = "@markup.heading.2.markdown" },
					markdownH2 = { link = "@markup.heading.2.markdown" },
					RenderMarkdownH2Bg = { fg = mdh2, },
					RenderMarkdown_RenderMarkdownH2Bg_bg_as_fg= { fg = mdh2 },

					["@markup.heading.3.markdown"] = { fg = mdh3, bold = true },
					RenderMarkdownH3 = { link = "@markup.heading.3.markdown" },
					markdownH3 = { link = "@markup.heading.3.markdown" },
					RenderMarkdownH3Bg = { fg = mdh3, },
					RenderMarkdown_RenderMarkdownH3Bg_bg_as_fg= { fg = mdh3 },

					["@markup.heading.4.markdown"] = { fg = mdh4, bold = true },
					RenderMarkdownH4 = { link = "@markup.heading.4.markdown" },
					markdownH4 = { link = "@markup.heading.4.markdown" },
					RenderMarkdownH4Bg = { fg = mdh4, },
					RenderMarkdown_RenderMarkdownH4Bg_bg_as_fg= { fg = mdh4 },

					["@markup.heading.5.markdown"] = { fg = mdh5, bold = true },
					RenderMarkdownH5 = { link = "@markup.heading.5.markdown" },
					markdownH5 = { link = "@markup.heading.5.markdown" },
					RenderMarkdownH5Bg = { fg = mdh5, },
					RenderMarkdown_RenderMarkdownH5Bg_bg_as_fg= { fg = mdh5 },

					["@markup.heading.6.markdown"] = { fg = mdh6, bold = true },
					RenderMarkdownH6 = { link = "@markup.heading.6.markdown" },
					markdownH6 = { link = "@markup.heading.6.markdown" },
					RenderMarkdownH6Bg = { fg = mdh6, },
					RenderMarkdown_RenderMarkdownH6Bg_bg_as_fg= { fg = mdh6 },

					TaskMeta_done = { fg = theme.syn.string },
					TaskMeta_started = { fg = theme.syn.identifier },
					TaskMeta_prio_high = { fg = theme.syn.special2, bold = true },
					TaskMeta_prio_medium = { fg = theme.syn.constant },
					TaskMeta_prio_low = { fg = theme.syn.special1 },

					Directory =  { fg = filesystem },
					LspKindArray =  { fg = variable },
					LspKindBoolean =  { fg = constant },
					LspKindClass = { fg = struct },
					LspKindColor = { fg = constant },
					LspKindConstant = { fg = constant },
					LspKindConstructor = { fg = func },
					LspKindEnum = { fg = struct },
					LspKindEnumMember = { fg = constant },
					LspKindEvent = { fg = async },
					LspKindField = { fg = variable },
					LspKindFile = { fg = filesystem },
					LspKindFolder = { fg = filesystem },
					LspKindFunction = { fg = func },
					LspKindInterface = { fg = struct },
					LspKindKey = { fg = constant },
					LspKindKeyword = { fg = keyword },
					LspKindMethod = { fg = func },
					LspKindModule = { fg = struct },
					LspKindNamespace = { fg = struct },
					LspKindNull = { fg = constant },
					LspKindNumber = { fg = constant },
					LspKindObject = { fg = struct },
					LspKindOperator = { fg = keyword },
					LspKindPackage = { fg = filesystem },
					LspKindProperty = { fg = variable },
					LspKindReference = { fg = keyword },
					LspKindSnippet = { fg = snippet },
					LspKindString = { fg = str },
					LspKindStruct = { fg = struct },
					LspKindText = { fg = str },
					LspKindTypeParameter = { fg = variable },
					LspKindUnit = { fg = struct },
					LspKindValue = { fg = variable },
					LspKindVariable = { fg = variable },

					BlinkCmpKind = { fg= theme.ui.bg, bg = theme.syn.special1 },
					BlinkCmpKindArray =  { fg= theme.ui.bg, bg= variable },
					BlinkCmpKindBoolean =  { fg= theme.ui.bg, bg= constant },
					BlinkCmpKindClass = { fg= theme.ui.bg, bg= struct },
					BlinkCmpKindColor = { fg= theme.ui.bg, bg= constant },
					BlinkCmpKindConstant = { fg= theme.ui.bg, bg= constant },
					BlinkCmpKindConstructor = { fg= theme.ui.bg, bg= func },
					BlinkCmpKindEnum = { fg= theme.ui.bg, bg= struct },
					BlinkCmpKindEnumMember = { fg= theme.ui.bg, bg= constant },
					BlinkCmpKindEvent = { fg= theme.ui.bg, bg= async },
					BlinkCmpKindField = { fg= theme.ui.bg, bg= variable },
					BlinkCmpKindFile = { fg= theme.ui.bg, bg= filesystem },
					BlinkCmpKindFolder = { fg= theme.ui.bg, bg= filesystem },
					BlinkCmpKindFunction = { fg= theme.ui.bg, bg= func },
					BlinkCmpKindInterface = { fg= theme.ui.bg, bg= struct },
					BlinkCmpKindKey = { fg= theme.ui.bg, bg= constant },
					BlinkCmpKindKeyword = { fg= theme.ui.bg, bg= keyword },
					BlinkCmpKindMethod = { fg= theme.ui.bg, bg= func },
					BlinkCmpKindModule = { fg= theme.ui.bg, bg= struct },
					BlinkCmpKindNamespace = { fg= theme.ui.bg, bg= struct },
					BlinkCmpKindNull = { fg= theme.ui.bg, bg= constant },
					BlinkCmpKindNumber = { fg= theme.ui.bg, bg= constant },
					BlinkCmpKindObject = { fg= theme.ui.bg, bg= struct },
					BlinkCmpKindOperator = { fg= theme.ui.bg, bg= keyword },
					BlinkCmpKindPackage = { fg= theme.ui.bg, bg= filesystem },
					BlinkCmpKindProperty = { fg= theme.ui.bg, bg= variable },
					BlinkCmpKindReference = { fg= theme.ui.bg, bg= keyword },
					BlinkCmpKindSnippet = { fg= theme.ui.bg, bg= snippet },
					BlinkCmpKindString = { fg= theme.ui.bg, bg= str },
					BlinkCmpKindStruct = { fg= theme.ui.bg, bg= struct },
					BlinkCmpKindText = { fg= theme.ui.bg, bg= str },
					BlinkCmpKindDict ={ fg = theme.ui.bg, bg =str},
					BlinkCmpKindTypeParameter = { fg= theme.ui.bg, bg= variable },
					BlinkCmpKindUnit = { fg= theme.ui.bg, bg= struct },
					BlinkCmpKindValue = { fg= theme.ui.bg, bg= variable },
					BlinkCmpKindVariable = { fg= theme.ui.bg, bg= variable },
				}
			end,
			theme = "wave",
			background = {
				dark = "wave",
				light = "lotus"
			},
		})

		vim.cmd("colorscheme kanagawa")
	end
}
