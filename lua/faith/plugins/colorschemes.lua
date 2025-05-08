local themes = {
	-- Dark
	dark = {
		{
			name = "Catppuccin Mocha",
			colorscheme = "catppuccin-mocha",
		},
		{
			name = "Tokyo Night",
			colorscheme = "tokyonight-night",
		},
		{
			name = "TokyoDark",
			colorscheme = "tokyodark",
		},
		{
			name = "Nightfox Carbon",
			colorscheme = "carbonfox",
		},
		{
			name = "Monokai Spectrum",
			colorscheme = "monokai-pro-spectrum",
		},
	},

	-- Light
	light = {
		{
			name = "Catppuccin Latte",
			colorscheme = "catppuccin-latte",
		},
		{
			name = "Tokyo Day",
			colorscheme = "tokyonight-day",
		},
		{
			name = "Monokai Light",
			colorscheme = "monokai-pro-light",
		},
		{
			name = "Nightfox Day",
			colorscheme = "dayfox",
		},
	},

	color = {
		{
			name = "Monokai Pro",
			colorscheme = "monokai-pro-default",
		},
		{
			name = "Monokai Octagon",
			colorscheme = "monokai-pro-octagon",
		},
		{
			name = "Monokai Machine",
			colorscheme = "monokai-pro-machine",
		},
		{
			name = "Monokai Ristretto",
			colorscheme = "monokai-pro-ristretto",
		},
		{
			name = "Monokai Classic",
			colorscheme = "monokai-pro-classic",
		},
	},
}

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = { "*" },
	callback = function()
		if vim.g.transparent_enabled then
			require("transparent").clear_prefix("lualine_c")
		end

		local yank_group =
			vim.api.nvim_create_augroup("highlight_yank", { clear = true })
		vim.api.nvim_create_autocmd("TextYankPost", {
			group = yank_group,
			callback = function()
				vim.highlight.on_yank({
					higroup = "YankFlash",
					timeout = 40,
				})
			end,
		})
	end,
})

return {
	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup({
				themes = vim.list_extend(
					themes.dark,
					vim.list_extend(
						themes.light,
						vim.list_extend({}, themes.color)
					)
				),
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = {
					-- "tokyonight",
					"tokyonight-night",
					"tokyonight-storm",
					"tokyonight-day",
					"tokyonight-moon",
				},
				callback = function(args)
					local colors = require("tokyonight.colors").setup({
						style = args.match:gsub("tokyonight%-", ""),
					})

					local accent = colors.magenta2
					local base = vim.g.transparent_enabled and "NONE"
						or colors.bg
					local mantle = vim.g.transparent_enabled and "NONE"
						or colors.bg_dark
					vim.api.nvim_set_hl(
						0,
						"Accent",
						{ fg = mantle, bg = accent, bold = true }
					)
					vim.api.nvim_set_hl(
						0,
						"AccentInverse",
						{ fg = accent, bg = mantle, bold = true }
					)

					for _, level in pairs({ "Error", "Warn", "Info", "Hint" }) do
						vim.api.nvim_set_hl(0, "BarDiag" .. level, {
							fg = vim.api.nvim_get_hl(
								0,
								{ name = "Diagnostic" .. level }
							).fg,
							bg = mantle,
						})
					end

					vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d4261" })
					vim.api.nvim_set_hl(0, "DiffText", {
						bg = "#3d5a8a",
						special = "#3d5a8a",
						underline = true,
					})

					vim.api.nvim_set_hl(
						0,
						"YankFlash",
						{ fg = colors.bg, bg = colors.magenta }
					)

					vim.api.nvim_set_hl(
						0,
						"Heading1",
						{ fg = colors.bg_popup, bg = colors.green }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading2",
						{ fg = colors.bg_popup, bg = colors.orange }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading3",
						{ fg = colors.bg_popup, bg = colors.magenta }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading4",
						{ fg = colors.bg_popup, bg = colors.blue1 }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading5",
						{ fg = colors.bg_popup, bg = colors.yellow }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading6",
						{ fg = colors.bg_popup, bg = colors.red }
					)
					vim.api.nvim_set_hl(
						0,
						"CodeBlock",
						{ bg = colors.bg_dark1 }
					)
					vim.api.nvim_set_hl(
						0,
						"HeadingBullet",
						{ fg = colors.bg_popup }
					)

					vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", {
						bg = colors.green,
						fg = colors.bg_popup,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", {
						bg = colors.orange,
						fg = colors.bg_popup,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", {
						bg = colors.magenta,
						fg = colors.bg_popup,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", {
						bg = colors.blue1,
						fg = colors.bg_popup,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", {
						bg = colors.yellow,
						fg = colors.bg_popup,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", {
						bg = colors.red,
						fg = colors.bg_popup,
					})

					vim.api.nvim_set_hl(
						0,
						"DiagnosticCheck",
						{ bg = mantle, fg = colors.green }
					)

					vim.api.nvim_set_hl(
						0,
						"@markup.quote",
						{ fg = colors.yellow, bold = false }
					)
					vim.api.nvim_set_hl(0, "@markup.italic", {
						fg = colors.magenta,
						italic = true,
					})
					vim.api.nvim_set_hl(
						0,
						"@markup.strong",
						{ fg = colors.red1, bold = true }
					)

					vim.api.nvim_set_hl(
						0,
						"HarpoonInactive",
						{ link = "Tabline" }
					)
					vim.api.nvim_set_hl(
						0,
						"HarpoonActive",
						{ fg = colors.bg, bg = colors.purple, bold = true }
					)
					vim.api.nvim_set_hl(
						0,
						"HarpoonNumberActive",
						{ fg = colors.bg, bg = colors.purple, bold = true }
					)
					vim.api.nvim_set_hl(
						0,
						"HarpoonNumberInactive",
						{ link = "Tabline" }
					)
				end,
			})
		end,
		opts = {
			on_highlights = function(highlights, colors)
				highlights.GitSignsAddInline =
					{ fg = colors.bg, bg = colors.green }
				highlights.GitSignsAddLnInline =
					{ fg = colors.bg, bg = colors.green }
				highlights.GitSignsChangeInline =
					{ fg = colors.bg, bg = colors.blue }
				highlights.GitSignsChangeLnInline =
					{ fg = colors.bg, bg = colors.blue }
				highlights.GitSignsDeleteInline =
					{ fg = colors.bg, bg = colors.red }
				highlights.GitSignsDeleteLnInline =
					{ fg = colors.bg, bg = colors.red }
				highlights.GitSignsChange = { fg = colors.blue, bg = colors.bg }
				highlights.GitSignsChangeNr =
					{ fg = colors.blue, bg = colors.bg }

				highlights.TelescopeNormal = { bg = colors.bg_popup }
				highlights.TelescopeSelection = { bg = colors.bg_highlight }
				highlights.TelescopePromptNormal = { bg = colors.bg_highlight }
				highlights.TelescopeBorder =
					{ fg = colors.bg_popup, bg = colors.bg_popup }
				highlights.TelescopePromptBorder =
					{ fg = colors.bg_highlight, bg = colors.bg_highlight }
				highlights.TelescopePromptTitle =
					{ fg = colors.bg_dark1, bg = colors.purple }
				highlights.TelescopePreviewTitle =
					{ fg = colors.bg_dark1, bg = colors.green }

				highlights.WinBar = { bg = colors.bg_dark }

				highlights.CmpItemKindSnippet =
					{ fg = colors.bg, bg = colors.magenta }
				highlights.CmpItemKindKeyword =
					{ fg = colors.bg, bg = colors.red }
				highlights.CmpItemKindText =
					{ fg = colors.bg, bg = colors.blue6 }
				highlights.CmpItemKindMethod =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindConstructor =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindFunction =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindFolder =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindModule =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindConstant =
					{ fg = colors.bg, bg = colors.orange }
				highlights.CmpItemKindField =
					{ fg = colors.bg, bg = colors.green }
				highlights.CmpItemKindProperty =
					{ fg = colors.bg, bg = colors.green }
				highlights.CmpItemKindEnum =
					{ fg = colors.bg, bg = colors.green }
				highlights.CmpItemKindUnit =
					{ fg = colors.bg, bg = colors.green }
				highlights.CmpItemKindClass =
					{ fg = colors.bg, bg = colors.yellow }
				highlights.CmpItemKindVariable =
					{ fg = colors.bg, bg = colors.terminal.yellow_bright }
				highlights.CmpItemKindFile =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindInterface =
					{ fg = colors.bg, bg = colors.yellow }
				highlights.CmpItemKindColor =
					{ fg = colors.bg, bg = colors.red }
				highlights.CmpItemKindReference =
					{ fg = colors.bg, bg = colors.red }
				highlights.CmpItemKindEnumMember =
					{ fg = colors.bg, bg = colors.red }
				highlights.CmpItemKindStruct =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindValue =
					{ fg = colors.bg, bg = colors.orange }
				highlights.CmpItemKindEvent =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindOperator =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindTypeParameter =
					{ fg = colors.bg, bg = colors.blue }
				highlights.CmpItemKindCopilot =
					{ fg = colors.bg, bg = colors.blue6 }
				highlights.IblScope = { fg = colors.magenta2 }
			end,
		},
	},

	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent_background = vim.g.transparent_enabled,
			terminal_colors = true,
			devicons = true, -- highlight the icons of `nvim-web-devicons`
			override = function(colors)
				local highlight_overrides = {
					GitSignsAddInline = {
						fg = colors.base.dark,
						bg = colors.base.green,
					},
					GitSignsAddLnInline = {
						fg = colors.base.dark,
						bg = colors.base.green,
					},
					GitSignsChangeInline = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					GitSignsChangeLnInline = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					GitSignsDeleteInline = {
						fg = colors.base.dark,
						bg = colors.base.red,
					},
					GitSignsDeleteLnInline = {
						fg = colors.base.dark,
						bg = colors.base.red,
					},
					GitSignsChange = {
						fg = colors.base.blue,
						bg = colors.base.dark,
					},
					GitSignsChangeNr = {
						fg = colors.base.blue,
						bg = colors.base.dark,
					},

					TelescopeNormal = { bg = colors.base.dimmed1 },
					TelescopeSelection = { bg = colors.base.dimmed4 },
					TelescopePromptNormal = { bg = colors.base.dimmed5 },
					TelescopeBorder = {
						fg = colors.base.dimmed2,
						bg = colors.base.dimmed2,
					},
					TelescopePromptBorder = {
						fg = colors.base.dimmed5,
						bg = colors.base.dimmed5,
					},
					TelescopePromptTitle = {
						fg = colors.base.black,
						bg = colors.base.magenta,
					},
					TelescopePreviewTitle = {
						fg = colors.base.black,
						bg = colors.base.green,
					},

					HarpoonInactive = { link = "Tabline" },
					HarpoonActive = {
						fg = colors.base.dark,
						bg = colors.base.magenta,
						bold = true,
					},
					HarpoonNumberActive = {
						fg = colors.base.dark,
						bg = colors.base.magenta,
						bold = true,
					},
					HarpoonNumberInactive = { link = "Tabline" },

					-- LspInlayHint = { fg = colors.base.overlay1, bg = colors.base.dark },

					WinBar = { bg = colors.base.black },

					CmpItemKindSnippet = {
						fg = colors.base.dark,
						bg = colors.base.magenta,
					},
					CmpItemKindKeyword = {
						fg = colors.base.dark,
						bg = colors.base.red,
					},
					CmpItemKindText = {
						fg = colors.base.dark,
						bg = colors.base.cyan,
					},
					CmpItemKindMethod = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindConstructor = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindFunction = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindFolder = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindModule = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindConstant = {
						fg = colors.base.dark,
						bg = colors.base.yellow,
					},
					CmpItemKindField = {
						fg = colors.base.dark,
						bg = colors.base.green,
					},
					CmpItemKindProperty = {
						fg = colors.base.dark,
						bg = colors.base.green,
					},
					CmpItemKindEnum = {
						fg = colors.base.dark,
						bg = colors.base.green,
					},
					CmpItemKindUnit = {
						fg = colors.base.dark,
						bg = colors.base.green,
					},
					CmpItemKindClass = {
						fg = colors.base.dark,
						bg = colors.base.yellow,
					},
					CmpItemKindVariable = {
						fg = colors.base.dark,
						bg = colors.base.white,
					},
					CmpItemKindFile = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindInterface = {
						fg = colors.base.dark,
						bg = colors.base.yellow,
					},
					CmpItemKindColor = {
						fg = colors.base.dark,
						bg = colors.base.red,
					},
					CmpItemKindReference = {
						fg = colors.base.dark,
						bg = colors.base.red,
					},
					CmpItemKindEnumMember = {
						fg = colors.base.dark,
						bg = colors.base.red,
					},
					CmpItemKindStruct = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindValue = {
						fg = colors.base.dark,
						bg = colors.base.yellow,
					},
					CmpItemKindEvent = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindOperator = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindTypeParameter = {
						fg = colors.base.dark,
						bg = colors.base.blue,
					},
					CmpItemKindCopilot = {
						fg = colors.base.dark,
						bg = colors.base.cyan,
					},
					IblScope = { fg = colors.base.magenta },
				}

				return highlight_overrides
			end,
		},
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = {
					"monokai-pro-spectrum",
					"monokai-pro-light",
					"monokai-pro-default",
					"monokai-pro-octagon",
					"monokai-pro-machine",
					"monokai-pro-ristretto",
					"monokai-pro-classic",
				},
				callback = function(args)
					local filter = args.match:gsub("monokai%-pro%-", "")
					filter = filter:gsub("default", "pro")
					local colors =
						require("monokai-pro.colorscheme").get(filter).base
					local translate = {
						mantle = "black",
						base = "dark",
						crust = "black",
						text = "white",
						subtext1 = "white",
						subtext0 = "white",
						red = "red",
						maroon = "red",
						peach = "blue",
						yellow = "yellow",
						green = "green",
						blue = "cyan",
						teal = "cyan",
						sky = "cyan",
						sapphire = "cyan",
						mauve = "magenta",
						pink = "magenta",
						lavender = "magenta",
						overlay2 = "dimmed1",
						overlay1 = "dimmed2",
						overlay0 = "dimmed2",
						surface2 = "dimmed3",
						surface1 = "dimmed4",
						surface0 = "dimmed5",
					}

					local accent = colors[translate.pink]
					local base = vim.g.transparent_enabled and "none"
						or colors[translate.base]
					local mantle = vim.g.transparent_enabled and "none"
						or colors[translate.mantle]
					vim.api.nvim_set_hl(
						0,
						"Accent",
						{ fg = base, bg = accent, bold = true }
					)
					vim.api.nvim_set_hl(
						0,
						"AccentInverse",
						{ fg = accent, bg = base, bold = true }
					)

					for _, level in pairs({ "Error", "Warn", "Info", "Hint" }) do
						vim.api.nvim_set_hl(0, "BarDiag" .. level, {
							fg = vim.api.nvim_get_hl(
								0,
								{ name = "Diagnostic" .. level }
							).fg,
							bg = mantle,
						})
					end

					vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d4261" })
					vim.api.nvim_set_hl(0, "DiffText", {
						bg = "#3d5a8a",
						special = "#3d5a8a",
						underline = true,
					})

					vim.api.nvim_set_hl(0, "YankFlash", {
						fg = colors[translate.base],
						bg = colors[translate.lavender],
					})

					vim.api.nvim_set_hl(0, "Heading1", {
						fg = colors[translate.surface0],
						bg = colors[translate.green],
					})
					vim.api.nvim_set_hl(0, "Heading2", {
						fg = colors[translate.surface0],
						bg = colors[translate.peach],
					})
					vim.api.nvim_set_hl(0, "Heading3", {
						fg = colors[translate.surface0],
						bg = colors[translate.mauve],
					})
					vim.api.nvim_set_hl(0, "Heading4", {
						fg = colors[translate.surface0],
						bg = colors[translate.sapphire],
					})
					vim.api.nvim_set_hl(0, "Heading5", {
						fg = colors[translate.surface0],
						bg = colors[translate.yellow],
					})
					vim.api.nvim_set_hl(0, "Heading6", {
						fg = colors[translate.surface0],
						bg = colors[translate.red],
					})
					vim.api.nvim_set_hl(
						0,
						"CodeBlock",
						{ bg = colors[translate.crust] }
					)
					vim.api.nvim_set_hl(
						0,
						"HeadingBullet",
						{ fg = colors[translate.surface0] }
					)

					vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", {
						bg = colors[translate.green],
						fg = colors[translate.surface0],
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", {
						bg = colors[translate.peach],
						fg = colors[translate.surface0],
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", {
						bg = colors[translate.mauve],
						fg = colors[translate.surface0],
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", {
						bg = colors[translate.sapphire],
						fg = colors[translate.surface0],
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", {
						bg = colors[translate.yellow],
						fg = colors[translate.surface0],
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", {
						bg = colors[translate.red],
						fg = colors[translate.surface0],
					})

					vim.api.nvim_set_hl(
						0,
						"DiagnosticCheck",
						{ bg = base, fg = colors[translate.green] }
					)

					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	"@markup.quote",
					-- 	{ fg = colors[translate.yellow,] bold = false }
					-- )
					-- vim.api.nvim_set_hl(0, "@markup.italic", {
					-- 	fg = colors[translate.rosewater,]
					-- 	italic = true,
					-- })
					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	"@markup.strong",
					-- 	{ fg = colors[translate.maroon,] bold = true }
					-- )
				end,
			})
		end,
	},
	{
		"tiagovla/tokyodark.nvim",
		opts = {
			transparent_background = vim.g.transparent_enabled,
			gamma = 1.0,
			custom_highlights = function(highlights, colors)
				return {
					GitSignsAddInline = { fg = colors.bg1, bg = colors.green },
					GitSignsAddLnInline = {
						fg = colors.bg1,
						bg = colors.green,
					},
					GitSignsChangeInline = {
						fg = colors.bg1,
						bg = colors.blue,
					},
					GitSignsChangeLnInline = {
						fg = colors.bg1,
						bg = colors.blue,
					},
					GitSignsDeleteInline = {
						fg = colors.bg1,
						bg = colors.red,
					},
					GitSignsDeleteLnInline = {
						fg = colors.bg1,
						bg = colors.red,
					},
					GitSignsChange = { fg = colors.blue, bg = colors.bg1 },
					GitSignsChangeNr = { fg = colors.blue, bg = colors.bg1 },

					TelescopeNormal = { bg = colors.bg1 },
					TelescopeSelection = { bg = colors.bg0 },
					TelescopePromptNormal = { bg = colors.bg0 },
					TelescopeBorder = {
						fg = colors.bg1,
						bg = colors.bg1,
					},
					TelescopePromptBorder = {
						fg = colors.bg0,
						bg = colors.bg0,
					},
					TelescopePromptTitle = {
						fg = colors.black,
						bg = colors.purple,
					},
					TelescopePreviewTitle = {
						fg = colors.black,
						bg = colors.green,
					},

					HarpoonInactive = { link = "Tabline" },
					HarpoonActive = {
						fg = colors.bg1,
						bg = colors.purple,
						bold = true,
					},
					HarpoonNumberActive = {
						fg = colors.bg1,
						bg = colors.purple,
						bold = true,
					},
					HarpoonNumberInactive = { link = "Tabline" },

					-- LspInlayHint = { fg = colors.overlay1, bg = colors.bg1 },

					WinBar = { bg = colors.bg0 },

					CmpItemKindSnippet = { fg = colors.bg1, bg = colors.purple },
					CmpItemKindKeyword = { fg = colors.bg1, bg = colors.red },
					CmpItemKindText = { fg = colors.bg1, bg = colors.cyan },
					CmpItemKindMethod = { fg = colors.bg1, bg = colors.blue },
					CmpItemKindConstructor = {
						fg = colors.bg1,
						bg = colors.blue,
					},
					CmpItemKindFunction = { fg = colors.bg1, bg = colors.blue },
					CmpItemKindFolder = { fg = colors.bg1, bg = colors.blue },
					CmpItemKindModule = { fg = colors.bg1, bg = colors.blue },
					CmpItemKindConstant = {
						fg = colors.bg1,
						bg = colors.orange,
					},
					CmpItemKindField = { fg = colors.bg1, bg = colors.green },
					CmpItemKindProperty = {
						fg = colors.bg1,
						bg = colors.green,
					},
					CmpItemKindEnum = { fg = colors.bg1, bg = colors.green },
					CmpItemKindUnit = { fg = colors.bg1, bg = colors.green },
					CmpItemKindClass = { fg = colors.bg1, bg = colors.yellow },
					CmpItemKindVariable = {
						fg = colors.bg1,
						bg = colors.flamingo,
					},
					CmpItemKindFile = { fg = colors.bg1, bg = colors.blue },
					CmpItemKindInterface = {
						fg = colors.bg1,
						bg = colors.yellow,
					},
					CmpItemKindColor = { fg = colors.bg1, bg = colors.red },
					CmpItemKindReference = { fg = colors.bg1, bg = colors.red },
					CmpItemKindEnumMember = {
						fg = colors.bg1,
						bg = colors.red,
					},
					CmpItemKindStruct = { fg = colors.bg1, bg = colors.blue },
					CmpItemKindValue = { fg = colors.bg1, bg = colors.orange },
					CmpItemKindEvent = { fg = colors.bg1, bg = colors.blue },
					CmpItemKindOperator = { fg = colors.bg1, bg = colors.blue },
					CmpItemKindTypeParameter = {
						fg = colors.bg1,
						bg = colors.blue,
					},
					CmpItemKindCopilot = { fg = colors.bg1, bg = colors.cyan },
					IblScope = { fg = colors.purple },
				}
			end,
		},
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "tokyodark" },
				callback = function()
					local colors = require("tokyodark.palette")

					local accent = colors.purple
					local base = vim.g.transparent_enabled and "NONE"
						or colors.bg0
					local mantle = vim.g.transparent_enabled and "NONE"
						or colors.bg1
					vim.api.nvim_set_hl(
						0,
						"Accent",
						{ fg = base, bg = accent, bold = true }
					)
					vim.api.nvim_set_hl(
						0,
						"AccentInverse",
						{ fg = accent, bg = base, bold = true }
					)

					for _, level in pairs({
						"Error",
						"Warn",
						"Info",
						"Hint",
					}) do
						vim.api.nvim_set_hl(0, "BarDiag" .. level, {
							fg = vim.api.nvim_get_hl(
								0,
								{ name = "Diagnostic" .. level }
							).fg,
							bg = mantle,
						})
					end

					vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d4261" })
					vim.api.nvim_set_hl(0, "DiffText", {
						bg = "#3d5a8a",
						special = "#3d5a8a",
						underline = true,
					})

					vim.api.nvim_set_hl(
						0,
						"YankFlash",
						{ fg = colors.base, bg = colors.purple }
					)

					vim.api.nvim_set_hl(
						0,
						"Heading1",
						{ fg = colors.bg5, bg = colors.green }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading2",
						{ fg = colors.bg5, bg = colors.orange }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading3",
						{ fg = colors.bg5, bg = colors.purple }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading4",
						{ fg = colors.bg5, bg = colors.blue }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading5",
						{ fg = colors.bg5, bg = colors.yellow }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading6",
						{ fg = colors.bg5, bg = colors.red }
					)
					vim.api.nvim_set_hl(0, "CodeBlock", { bg = colors.black })
					vim.api.nvim_set_hl(0, "HeadingBullet", { fg = colors.bg5 })

					vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", {
						bg = colors.green,
						fg = colors.bg5,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", {
						bg = colors.orange,
						fg = colors.bg5,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", {
						bg = colors.purple,
						fg = colors.bg5,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", {
						bg = colors.blue,
						fg = colors.bg5,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", {
						bg = colors.yellow,
						fg = colors.bg5,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", {
						bg = colors.red,
						fg = colors.bg5,
					})

					vim.api.nvim_set_hl(
						0,
						"DiagnosticCheck",
						{ bg = colors.bg1, fg = colors.green }
					)

					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	"@markup.quote",
					-- 	{ fg = colors.yellow, bold = false }
					-- )
					-- vim.api.nvim_set_hl(0, "@markup.italic", {
					-- 	fg = colors.rosewater,
					-- 	italic = true,
					-- })
					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	"@markup.strong",
					-- 	{ fg = colors.maroon, bold = true }
					-- )
					--

					vim.api.nvim_set_hl(
						0,
						"HarpoonInactive",
						{ link = "Tabline" }
					)
					vim.api.nvim_set_hl(0, "HarpoonActive", {
						fg = colors.bg1,
						bg = colors.purple,
						bold = true,
					})
					vim.api.nvim_set_hl(0, "HarpoonNumberActive", {
						fg = colors.bg1,
						bg = colors.purple,
						bold = true,
					})
					vim.api.nvim_set_hl(
						0,
						"HarpoonNumberInactive",
						{ link = "Tabline" }
					)
				end,
			})
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			options = {
				transparent = vim.g.transparent_enabled,
				terminal_colors = true,
				dim_inactive = false,
				styles = { -- Style to be applied to different syntax groups
					comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
					conditionals = "bold",
					constants = "NONE",
					functions = "NONE",
					keywords = "bold",
					numbers = "NONE",
					operators = "NONE",
					strings = "italic",
					types = "NONE",
					variables = "NONE",
				},
			},
			groups = {
				all = {
					GitSignsAddInline = { fg = "bg1", bg = "palette.green" },
					GitSignsAddLnInline = {
						fg = "bg1",
						bg = "palette.green",
					},
					GitSignsChangeInline = {
						fg = "bg1",
						bg = "palette.blue",
					},
					GitSignsChangeLnInline = {
						fg = "bg1",
						bg = "palette.blue",
					},
					GitSignsDeleteInline = {
						fg = "bg1",
						bg = "palette.red",
					},
					GitSignsDeleteLnInline = {
						fg = "bg1",
						bg = "palette.red",
					},
					GitSignsChange = { fg = "palette.blue", bg = "bg1" },
					GitSignsChangeNr = { fg = "palette.blue", bg = "bg1" },

					TelescopeNormal = { bg = "bg4" },
					TelescopeSelection = { bg = "bg3" },
					TelescopePromptNormal = { bg = "bg3" },
					TelescopeBorder = {
						fg = "bg4",
						bg = "bg4",
					},
					TelescopePromptBorder = {
						fg = "bg3",
						bg = "bg3",
					},
					TelescopePromptTitle = {
						fg = "fg1",
						bg = "palette.pink",
					},
					TelescopePreviewTitle = {
						fg = "fg1",
						bg = "palette.green",
					},
					-- LspInlayHint = { fg = colors.overlay1, bg = "bg1" },

					WinBar = { bg = "bg0" },
					IblScope = { fg = "palette.pink" },
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = {
					"nightfox",
					"dayfox",
					"dawnfox",
					"duskfox",
					"nordfox",
					"terafox",
					"carbonfox",
				},
				callback = function(args)
					local palette = require("nightfox.palette").load(args.match)

					local accent = palette.pink.base
					local base = vim.g.transparent_enabled and "none"
						or palette.bg1
					local mantle = vim.g.transparent_enabled and "none"
						or palette.bg0
					vim.api.nvim_set_hl(
						0,
						"Accent",
						{ fg = mantle, bg = accent, bold = true }
					)
					vim.api.nvim_set_hl(
						0,
						"AccentInverse",
						{ fg = accent, bg = mantle, bold = true }
					)

					for _, level in pairs({ "Error", "Warn", "Info", "Hint" }) do
						vim.api.nvim_set_hl(0, "BarDiag" .. level, {
							fg = vim.api.nvim_get_hl(
								0,
								{ name = "Diagnostic" .. level }
							).fg,
							bg = mantle,
						})
					end

					-- vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d4261" })
					-- vim.api.nvim_set_hl(0, "DiffText", {
					-- 	bg = "#3d5a8a",
					-- 	special = "#3d5a8a",
					-- 	underline = true,
					-- })

					vim.api.nvim_set_hl(
						0,
						"YankFlash",
						{ fg = base, bg = palette.magenta.bright }
					)

					vim.api.nvim_set_hl(
						0,
						"Heading1",
						{ fg = palette.fg0, bg = palette.green.base }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading2",
						{ fg = palette.fg0, bg = palette.orange.bright }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading3",
						{ fg = palette.fg0, bg = palette.magenta.bright }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading4",
						{ fg = palette.fg0, bg = palette.blue.bright }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading5",
						{ fg = palette.fg0, bg = palette.yellow.base }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading6",
						{ fg = palette.fg0, bg = palette.red.base }
					)
					vim.api.nvim_set_hl(0, "CodeBlock", { bg = palette.bg0 })
					vim.api.nvim_set_hl(0, "HeadingBullet", { fg = mantle })

					vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", {
						bg = palette.green.bright,
						fg = palette.bg0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", {
						bg = palette.orange.bright,
						fg = palette.bg0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", {
						bg = palette.magenta.bright,
						fg = palette.bg0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", {
						bg = palette.blue.bright,
						fg = palette.bg0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", {
						bg = palette.yellow.base,
						fg = palette.bg0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", {
						bg = palette.red.base,
						fg = palette.bg0,
					})

					vim.api.nvim_set_hl(
						0,
						"DiagnosticCheck",
						{ bg = mantle, fg = palette.green.base }
					)

					vim.api.nvim_set_hl(
						0,
						"HarpoonInactive",
						{ link = "Tabline" }
					)
					vim.api.nvim_set_hl(0, "HarpoonActive", {
						fg = palette.bg1,
						bg = palette.pink.base,
						bold = true,
					})
					vim.api.nvim_set_hl(0, "HarpoonNumberActive", {
						fg = palette.bg1,
						bg = palette.pink.base,
						bold = true,
					})
					vim.api.nvim_set_hl(
						0,
						"HarpoonNumberInactive",
						{ link = "Tabline" }
					)

					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	"@markup.quote",
					-- 	{ fg = palette.yellow.base, bg = base, style = "bold" }
					-- )
					-- vim.api.nvim_set_hl(0, "@markup.italic", {
					-- 	fg = palette.white.bright,
					-- 	bg = base,
					-- 	style = "italic",
					-- })
					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	"@markup.strong",
					-- 	{ fg = palette.red.dim, bg = base, style = "bold" }
					-- )
				end,
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "catppuccin*" },
				callback = function()
					local colors = require("catppuccin.palettes").get_palette()

					local accent = colors.pink
					local base = vim.g.transparent_enabled and "none"
						or colors.base
					local mantle = vim.g.transparent_enabled and "none"
						or colors.mantle
					vim.api.nvim_set_hl(
						0,
						"Accent",
						{ fg = base, bg = accent, bold = true }
					)
					vim.api.nvim_set_hl(
						0,
						"AccentInverse",
						{ fg = accent, bg = base, bold = true }
					)

					for _, level in pairs({ "Error", "Warn", "Info", "Hint" }) do
						vim.api.nvim_set_hl(0, "BarDiag" .. level, {
							fg = vim.api.nvim_get_hl(
								0,
								{ name = "Diagnostic" .. level }
							).fg,
							bg = mantle,
						})
					end

					vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d4261" })
					vim.api.nvim_set_hl(0, "DiffText", {
						bg = "#3d5a8a",
						special = "#3d5a8a",
						underline = true,
					})

					vim.api.nvim_set_hl(
						0,
						"YankFlash",
						{ fg = colors.base, bg = colors.lavender }
					)

					vim.api.nvim_set_hl(
						0,
						"Heading1",
						{ fg = colors.surface0, bg = colors.green }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading2",
						{ fg = colors.surface0, bg = colors.peach }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading3",
						{ fg = colors.surface0, bg = colors.mauve }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading4",
						{ fg = colors.surface0, bg = colors.sapphire }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading5",
						{ fg = colors.surface0, bg = colors.yellow }
					)
					vim.api.nvim_set_hl(
						0,
						"Heading6",
						{ fg = colors.surface0, bg = colors.red }
					)
					vim.api.nvim_set_hl(0, "CodeBlock", { bg = colors.crust })
					vim.api.nvim_set_hl(
						0,
						"HeadingBullet",
						{ fg = colors.surface0 }
					)

					vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", {
						bg = colors.green,
						fg = colors.surface0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", {
						bg = colors.peach,
						fg = colors.surface0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", {
						bg = colors.mauve,
						fg = colors.surface0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", {
						bg = colors.sapphire,
						fg = colors.surface0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", {
						bg = colors.yellow,
						fg = colors.surface0,
					})
					vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", {
						bg = colors.red,
						fg = colors.surface0,
					})

					vim.api.nvim_set_hl(
						0,
						"DiagnosticCheck",
						{ bg = mantle, fg = colors.green }
					)

					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	"@markup.quote",
					-- 	{ fg = colors.yellow, bold = false }
					-- )
					-- vim.api.nvim_set_hl(0, "@markup.italic", {
					-- 	fg = colors.rosewater,
					-- 	italic = true,
					-- })
					-- vim.api.nvim_set_hl(
					-- 	0,
					-- 	"@markup.strong",
					-- 	{ fg = colors.maroon, bold = true }
					-- )
				end,
			})
		end,
		opts = {
			compile_path = vim.fn.glob(
				vim.fn.stdpath("cache") .. "/catppuccin"
			),
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
				overseer = true,
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
				local highlight_overrides = {
					GitSignsAddInline = { fg = colors.base, bg = colors.green },
					GitSignsAddLnInline = {
						fg = colors.base,
						bg = colors.green,
					},
					GitSignsChangeInline = {
						fg = colors.base,
						bg = colors.blue,
					},
					GitSignsChangeLnInline = {
						fg = colors.base,
						bg = colors.blue,
					},
					GitSignsDeleteInline = {
						fg = colors.base,
						bg = colors.red,
					},
					GitSignsDeleteLnInline = {
						fg = colors.base,
						bg = colors.red,
					},
					GitSignsChange = { fg = colors.blue, bg = colors.base },
					GitSignsChangeNr = { fg = colors.blue, bg = colors.base },

					TelescopeNormal = { bg = colors.surface0 },
					TelescopeSelection = { bg = colors.surface1 },
					TelescopePromptNormal = { bg = colors.surface1 },
					TelescopeBorder = {
						fg = colors.surface0,
						bg = colors.surface0,
					},
					TelescopePromptBorder = {
						fg = colors.surface1,
						bg = colors.surface1,
					},
					TelescopePromptTitle = {
						fg = colors.crust,
						bg = colors.pink,
					},
					TelescopePreviewTitle = {
						fg = colors.crust,
						bg = colors.green,
					},

					HarpoonInactive = { link = "Tabline" },
					HarpoonActive = {
						fg = colors.base,
						bg = colors.pink,
						bold = true,
					},
					HarpoonNumberActive = {
						fg = colors.base,
						bg = colors.pink,
						bold = true,
					},
					HarpoonNumberInactive = { link = "Tabline" },

					-- LspInlayHint = { fg = colors.overlay1, bg = colors.base },

					WinBar = { bg = colors.mantle },

					CmpItemKindSnippet = { fg = colors.base, bg = colors.mauve },
					CmpItemKindKeyword = { fg = colors.base, bg = colors.red },
					CmpItemKindText = { fg = colors.base, bg = colors.teal },
					CmpItemKindMethod = { fg = colors.base, bg = colors.blue },
					CmpItemKindConstructor = {
						fg = colors.base,
						bg = colors.blue,
					},
					CmpItemKindFunction = { fg = colors.base, bg = colors.blue },
					CmpItemKindFolder = { fg = colors.base, bg = colors.blue },
					CmpItemKindModule = { fg = colors.base, bg = colors.blue },
					CmpItemKindConstant = {
						fg = colors.base,
						bg = colors.peach,
					},
					CmpItemKindField = { fg = colors.base, bg = colors.green },
					CmpItemKindProperty = {
						fg = colors.base,
						bg = colors.green,
					},
					CmpItemKindEnum = { fg = colors.base, bg = colors.green },
					CmpItemKindUnit = { fg = colors.base, bg = colors.green },
					CmpItemKindClass = { fg = colors.base, bg = colors.yellow },
					CmpItemKindVariable = {
						fg = colors.base,
						bg = colors.flamingo,
					},
					CmpItemKindFile = { fg = colors.base, bg = colors.blue },
					CmpItemKindInterface = {
						fg = colors.base,
						bg = colors.yellow,
					},
					CmpItemKindColor = { fg = colors.base, bg = colors.red },
					CmpItemKindReference = { fg = colors.base, bg = colors.red },
					CmpItemKindEnumMember = {
						fg = colors.base,
						bg = colors.red,
					},
					CmpItemKindStruct = { fg = colors.base, bg = colors.blue },
					CmpItemKindValue = { fg = colors.base, bg = colors.peach },
					CmpItemKindEvent = { fg = colors.base, bg = colors.blue },
					CmpItemKindOperator = { fg = colors.base, bg = colors.blue },
					CmpItemKindTypeParameter = {
						fg = colors.base,
						bg = colors.blue,
					},
					CmpItemKindCopilot = { fg = colors.base, bg = colors.teal },
				}

				return highlight_overrides
			end,
			highlight_overrides = {
				latte = function(colors)
					local highlight_overrides = {
						ObsidianTagCustom = {
							fg = colors.pink,
							bg = "#eedbee",
							bold = false,
						},
					}
					return highlight_overrides
				end,
				mocha = function(colors)
					local highlight_overrides = {
						ObsidianTagCustom = {
							fg = colors.pink,
							bg = "#493f53",
							bold = false,
						},
					}
					return highlight_overrides
				end,
			},
		},
	},
	{
		"xiyaowong/nvim-transparent",
		opts = function()
			-- require("transparent").clear_prefix("lualine_c_filetype_DevIcon")
			-- require("transparent").clear_prefix("lualine_c_overseer")
			local opts = {
				exclude_groups = {
					"Accent",
				},
				extra_groups = {
					"NormalFloat",
					"NvimTreeNormal",
					"NvimTreeWinSeparator",

					"WinBar",

					"AccentInverse",

					"FidgetTitle",
					"FidgetTask",

					"BufferCurrent",
					"BufferCurrentIndex",
					"BufferCurrentMod",
					"BufferCurrentSign",
					"BufferCurrentTarget",
					"BufferVisible",
					"BufferVisibleIndex",
					"BufferVisibleMod",
					"BufferVisibleSign",
					"BufferVisibleTarget",
					"BufferInactive",
					"BufferInactiveIndex",
					"BufferInactiveMod",
					"BufferInactiveSign",
					"BufferInactiveTarget",
					"BufferTabpages",
					"BufferTabpage",

					"BarDiagError",
					"BarDiagWarn",
					"BarDiagInfo",
					"BarDiagHint",
					"DiagnosticCheck",

					"TreesitterContextBottom",
					"TreesitterContextLineNumber",

					"lualine_c_normal",

					"barbecue_normal",
					"barbecue_modified",
					"barbecue_ellipsis",
					"barbecue_separator",
					"barbecue_dirname",
					"barbecue_basename",
					"barbecue_context",
					"barbecue_context_file",
					"barbecue_context_module",
					"barbecue_context_namespace",
					"barbecue_context_package",
					"barbecue_context_class",
					"barbecue_context_method",
					"barbecue_context_property",
					"barbecue_context_field",
					"barbecue_context_constructor",
					"barbecue_context_enum",
					"barbecue_context_interface",
					"barbecue_context_function",
					"barbecue_context_variable",
					"barbecue_context_constant",
					"barbecue_context_string",
					"barbecue_context_number",
					"barbecue_context_boolean",
					"barbecue_context_array",
					"barbecue_context_object",
					"barbecue_context_key",
					"barbecue_context_null",
					"barbecue_context_enum_member",
					"barbecue_context_struct",
					"barbecue_context_event",
					"barbecue_context_operator",
					"barbecue_context_type_parameter",

					"GitSignsAdd",
					"GitSignsChange",
					"GitSignsDelete",
					"GitSignsStagedAdd",
					"GitSignsStagedAddLn",
					"GitSignsStagedAddNr",
					"GitSignsStagedChange",
					"GitSignsStagedChangeDelete",
					"GitSignsStagedChangeDeleteLn",
					"GitSignsStagedChangeDeleteNr",
					"GitSignsStagedChangeLn",
					"GitSignsStagedChangeNr",
					"GitSignsStagedDelete",
					"GitSignsStagedDeleteNr",
					"GitSignsStagedTogdeleteNr",
					"GitSignsStagedTopdelete",
				},
			}

			return opts
		end,
	},
}
