local themes = require("faith.plugins.color.themes")
local apply_theme_overrides =
	require("faith.plugins.color.overrides").apply_theme_overrides

-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	pattern = { "*" },
-- 	callback = function()
-- 		if vim.g.transparent_enabled then
-- 			require("transparent").clear_prefix("lualine_c")
-- 		end
-- 	end,
-- })

return {
	{
		"zaldih/themery.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("themery").setup({
				themes = vim.list_extend(
					themes.dark,
					vim.list_extend(themes.light, vim.list_extend({}, themes.color))
				),
			})
			require("faith.plugins.color.background")
		end,
	},
	{ -- eldritch
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			dim_inactive = false, -- dims inactive windows, transparent must be false for this to work
			styles = {
				-- Style to be applied to different syntax groups
				-- Value is any valid attr-list value for `:help nvim_set_hl`
				comments = { italic = true },
				keywords = {},
				functions = {},
				variables = {},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = {
					"eldritch",
					"eldritch-dark",
					"eldritch-minimal",
				},
				callback = function(args)
					local scheme = args.match:find("eldritch%-")
					local filter = scheme == nil and "default"
						or (args.match:find("dark") == nil and "minimal" or "darker")
					apply_theme_overrides("eldritch", filter)
				end,
			})
		end,
	},
	{ -- tokyonight
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
					apply_theme_overrides(
						"tokyonight",
						args.match:gsub("tokyonight%-", "")
					)
				end,
			})
		end,
		opts = {},
	},
	{ -- monokai
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent_background = vim.g.transparent_enabled,
			terminal_colors = true,
			devicons = false, -- highlight the icons of `nvim-web-devicons`
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
					apply_theme_overrides("monokai-pro", filter)
				end,
			})
		end,
	},
	{ -- tokyodark
		"tiagovla/tokyodark.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent_background = vim.g.transparent_enabled,
			gamma = 1.0,
		},
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "tokyodark" },
				callback = function()
					apply_theme_overrides("tokyodark")
				end,
			})
		end,
	},
	{ -- nightfox
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
					apply_theme_overrides("nightfox", args.match)
				end,
			})
		end,
	},
	{ -- catppuccin
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "catppuccin*" },
				callback = function(args)
					apply_theme_overrides(
						"catppuccin",
						args.match:gsub("catppuccin%-", "")
					)
				end,
			})
		end,
		opts = {
			compile_path = vim.fn.glob(vim.fn.stdpath("cache") .. "/catppuccin"),
			transparent_background = vim.g.transparent_enabled,
			term_colors = true,
			dim_inactive = {
				enable = true,
				shade = "dark",
				percentage = 0.15,
			},
			styles = {
				comments = { "italic" },
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
	{ -- matrix
		"iruzo/matrix-nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.matrix_contrast = true
			vim.g.matrix_borders = false
			vim.g.matrix_disable_background = false
			vim.g.matrix_cursorline_transparent = true
			vim.g.matrix_italic = true

			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "matrix" },
				callback = function()
					apply_theme_overrides("matrix")
				end,
			})
		end,
	},
	{ -- midnight
		"dasupradyumna/midnight.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "midnight" },
				callback = function()
					apply_theme_overrides("midnight")
				end,
			})
		end,
	},
	{ -- sakura
		"anAcc22/sakura.nvim",
		lazy = false,
		priority = 1000,
		dependencies = "rktjmp/lush.nvim",
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "sakura" },
				callback = function()
					apply_theme_overrides("sakura", vim.o.background)
				end,
			})
		end,
	},
	{ -- yorumi
		"yorumicolors/yorumi.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "yorumi" },
				callback = function(args)
					apply_theme_overrides("yorumi", vim.o.background)
				end,
			})
		end,
	},
	{ -- nvim-transparent
		"xiyaowong/nvim-transparent",
		cmd = {
			"TransparentToggle",
			"TransparentEnable",
			"TransparentDisable",
		},
		opts = function()
			require("transparent").clear_prefix("lualine_a")
			require("transparent").clear_prefix("lualine_b")
			require("transparent").clear_prefix("lualine_c")
			require("transparent").clear_prefix("lualine_x")
			require("transparent").clear_prefix("lualine_y")
			-- require("transparent").clear_prefix("lualine_z")
			-- require("transparent").clear_prefix("lualine_c_filetype_DevIcon")

			require("transparent").clear_prefix("NeoTree")

			local opts = {
				exclude_groups = {
					"Accent",
					"TabLineSel",
					"TabLineSelSep",

					"NormalFloat",

					"PmenuMatchSel",
					"PmenuExtraSel",
					"PmenuKindSel",
					"PmenuThumb",
					"PmenuMatch",
					"PmenuExtra",
					"PmenuSbar",
					"PmenuKind",
					"PmenuSel",
					"Pmenu",

					"UgUndo",
					"UgRedo",
					"UgYank",
					"UgPaste",
					"UgSearch",
					"UgComment",
					"UgCursor",
				},
				extra_groups = {
					"FoldColumn",
					"CursorLineFold",
					"Folded",
					"CursorLineSign",

					"WinSeparator",
					"ColorfulWinSep",

					"FloatBorder",

					"lualine_transparent",

					"TabLine",
					"TabLineSep",
					"TabLineFill",

					"HarpoonSeparator",
					"HarpoonInactive",
					"HarpoonNumberInactive",

					"AccentInverse",

					"FidgetTitle",
					"FidgetTask",
					"FidgetDone",
					"FidgetProgress",
					"FidgetGroupName",
					"FidgetGroupIcon",
					"FidgetSep",
					"FidgetWindow",

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
					"TreesitterContext",
					"TreesitterContextSeparator",
					"TreesitterContextLineNumberBottom",

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

					"ScrollbarHint",
					"ScrollbarInfo",
					"ScrollbarMisc",
					"ScrollbarWarn",
					"ScrollbarError",
					"ScrollbarCursor",
					"ScrollbarGitAdd",
					"ScrollbarSearch",
					"ScrollbarGitChange",
					"ScrollbarGitDelete",

					"ScrollbarMark",
				},
			}

			return opts
		end,
	},
}
