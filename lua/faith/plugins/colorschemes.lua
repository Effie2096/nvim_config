local themes = {
	-- Dark
	dark = {
		{
			name = "Catppuccin Mocha",
			colorscheme = "catppuccin-mocha",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Tokyo Night",
			colorscheme = "tokyonight-night",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "TokyoDark",
			colorscheme = "tokyodark",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Nightfox Carbon",
			colorscheme = "carbonfox",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Monokai Spectrum",
			colorscheme = "monokai-pro-spectrum",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Matrix",
			colorscheme = "matrix",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Midnight",
			colorscheme = "midnight",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Sakura Dark",
			colorscheme = "sakura",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Yorumi Abyss",
			colorscheme = "yorumi",
			before = [[
				vim.o.background = "dark"
			]],
		},
	},

	-- Light
	light = {
		{
			name = "Catppuccin Latte",
			colorscheme = "catppuccin-latte",
			before = [[
				vim.o.background = "light"
			]],
		},
		{
			name = "Tokyo Day",
			colorscheme = "tokyonight-day",
			before = [[
				vim.o.background = "light"
			]],
		},
		{
			name = "Monokai Light",
			colorscheme = "monokai-pro-light",
			before = [[
				vim.o.background = "light"
			]],
		},
		{
			name = "Nightfox Day",
			colorscheme = "dayfox",
			before = [[
				vim.o.background = "light"
			]],
		},
		{
			name = "Sakura Light",
			colorscheme = "sakura",
			before = [[
				vim.o.background = "light"
			]],
		},
	},

	color = {
		{
			name = "Monokai Pro",
			colorscheme = "monokai-pro-default",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Monokai Octagon",
			colorscheme = "monokai-pro-octagon",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Monokai Machine",
			colorscheme = "monokai-pro-machine",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Monokai Ristretto",
			colorscheme = "monokai-pro-ristretto",
			before = [[
				vim.o.background = "dark"
			]],
		},
		{
			name = "Monokai Classic",
			colorscheme = "monokai-pro-classic",
			before = [[
				vim.o.background = "dark"
			]],
		},
	},
}

---@class ColorMap
---@field bg string
---@field bg_light string
---@field bg_dark string
---@field fg string
---@field fg_light string
---@field fg_dark string
---@field float string
---@field float_light string
---@field float_dark string
---@field surface string
---@field surface_light string
---@field surface_dark string
---@field accent string
---@field red string
---@field red_light string
---@field red_dark string
---@field green string
---@field green_light string
---@field green_dark string
---@field blue string
---@field blue_light string
---@field blue_dark string
---@field cyan string
---@field cyan_light string
---@field cyan_dark string
---@field pink string
---@field pink_light string
---@field pink_dark string
---@field purple string
---@field purple_light string
---@field purple_dark string
---@field yellow string
---@field yellow_light string
---@field yellow_dark string
---@field orange string
---@field orange_light string
---@field orange_dark string
---@field pale string
---@field pale_light string
---@field pale_dark string
---@field error string
---@field warn string
---@field hint string
---@field info string

---@type table<string, function>
local theme_colormaps = {
	["catppuccin"] = function(scheme)
		local colors = require("catppuccin.palettes").get_palette(scheme)
		---@type ColorMap
		local color_map = {
			bg = colors.base,
			bg_light = colors.mantle,
			bg_dark = colors.crust,
			fg = colors.text,
			fg_light = colors.subtext1,
			fg_dark = colors.subtext0,
			float = colors.overlay1,
			float_light = colors.overlay2,
			float_dark = colors.overlay0,
			surface = colors.surface1,
			surface_light = colors.surface2,
			surface_dark = colors.surface0,
			accent = colors.pink,
			red = colors.red,
			red_light = colors.red,
			red_dark = colors.maroon,
			green = colors.green,
			green_light = colors.green,
			green_dark = colors.green,
			blue = colors.blue,
			blue_light = colors.sky,
			blue_dark = colors.sapphire,
			cyan = colors.teal,
			cyan_light = colors.teal,
			cyan_dark = colors.teal,
			pink = colors.pink,
			pink_light = colors.rosewater,
			pink_dark = colors.flamingo,
			purple = colors.mauve,
			purple_light = colors.lavender,
			purple_dark = colors.mauve,
			yellow = colors.yellow,
			yellow_light = colors.yellow,
			yellow_dark = colors.yellow,
			orange = colors.peach,
			orange_light = colors.peach,
			orange_dark = colors.peach,
			error = colors.red,
			warn = colors.peach,
			info = colors.sapphire,
			hint = colors.teal,
		}

		return color_map
	end,
	["tokyonight"] = function(scheme)
		local colors = require("tokyonight.colors").setup({ style = scheme })
		---@type ColorMap
		local color_map = {
			bg = colors.bg,
			bg_light = colors.bg_dark,
			bg_dark = colors.bg_dark1,
			fg = colors.fg,
			fg_light = colors.fg_float,
			fg_dark = colors.fg_dark,
			float = colors.bg_float,
			float_light = colors.bg_popup,
			float_dark = colors.bg_float,
			surface = colors.bg_dark,
			surface_light = colors.bg_float,
			surface_dark = colors.bg_dark1,
			accent = colors.magenta2,
			red = colors.red,
			red_light = colors.red,
			red_dark = colors.red1,
			green = colors.green,
			green_light = colors.green1,
			green_dark = colors.green2,
			blue = colors.blue,
			blue_light = colors.blue5,
			blue_dark = colors.blue0,
			cyan = colors.cyan,
			cyan_light = colors.cyan,
			cyan_dark = colors.cyan,
			pink = colors.magenta2,
			pink_light = colors.magenta2,
			pink_dark = colors.magenta2,
			purple = colors.magenta,
			purple_light = colors.magenta,
			purple_dark = colors.purple,
			yellow = colors.yellow,
			yellow_light = colors.yellow,
			yellow_dark = colors.yellow,
			orange = colors.orange,
			orange_light = colors.orange,
			orange_dark = colors.orange,
			error = colors.error,
			warn = colors.warning,
			info = colors.info,
			hint = colors.hint,
		}

		return color_map
	end,
	["monokai-pro"] = function(scheme)
		local colors = require("monokai-pro.colorscheme.palette." .. scheme)
		---@type ColorMap
		local color_map = {
			bg = colors.background,
			bg_light = colors.dark2,
			bg_dark = colors.dark1,
			fg = colors.text,
			fg_light = colors.text,
			fg_dark = colors.text,
			float = colors.dimmed4,
			float_light = colors.dimmed3,
			float_dark = colors.dimmed5,
			surface = colors.dimmed1,
			surface_light = colors.dimmed2,
			surface_dark = colors.dimmed3,
			accent = "#FE64A3",
			red = colors.accent1,
			red_light = colors.accent1,
			red_dark = colors.accent1,
			green = colors.accent4,
			green_light = colors.accent4,
			green_dark = colors.accent4,
			blue = colors.accent5,
			blue_light = colors.accent5,
			blue_dark = colors.accent5,
			cyan = colors.accent5,
			cyan_light = colors.accent5,
			cyan_dark = colors.accent5,
			pink = "#FE64A3",
			pink_light = "#FE64A3",
			pink_dark = "#FE64A3",
			purple = colors.accent6,
			purple_light = colors.accent6,
			purple_dark = colors.accent6,
			yellow = colors.accent3,
			yellow_light = colors.accent3,
			yellow_dark = colors.accent3,
			orange = colors.accent2,
			orange_light = colors.accent2,
			orange_dark = colors.accent2,
			error = colors.accent1,
			warn = colors.accent2,
			info = colors.accent5,
			hint = colors.accent6,
		}

		return color_map
	end,
	["tokyodark"] = function(_)
		local colors = require("tokyodark.palette")

		---@type ColorMap
		local color_map = {
			bg = colors.bg0,
			bg_light = colors.bg1,
			bg_dark = colors.black,
			fg = colors.fg,
			fg_light = colors.fg,
			fg_dark = colors.grey,
			float = colors.bg3,
			float_light = colors.bg4,
			float_dark = colors.bg2,
			surface = colors.bg3,
			surface_light = colors.bg4,
			surface_dark = colors.bg2,
			accent = "#FE64A3",
			red = colors.red,
			red_light = colors.bg_red,
			red_dark = colors.red,
			green = colors.green,
			green_light = colors.bg_green,
			green_dark = colors.cyan,
			blue = colors.blue,
			blue_light = colors.bg_blue,
			blue_dark = colors.blue,
			cyan = colors.cyan,
			cyan_light = colors.cyan,
			cyan_dark = colors.cyan,
			pink = "#FE64A3",
			pink_light = "#FE64A3",
			pink_dark = "#FE64A3",
			purple = colors.purple,
			purple_light = colors.purple,
			purple_dark = colors.purple,
			yellow = colors.yellow,
			yellow_light = colors.yellow,
			yellow_dark = colors.yellow,
			orange = colors.orange,
			orange_light = colors.orange,
			orange_dark = colors.orange,
			error = colors.red,
			warn = colors.yellow,
			info = colors.blue,
			hint = colors.cyan,
		}

		return color_map
	end,
	["nightfox"] = function(scheme)
		local colors = require("nightfox.palette").load(scheme)

		---@type ColorMap
		local color_map = {
			bg = colors.bg2,
			bg_light = colors.bg0,
			bg_dark = colors.bg1,
			fg = colors.fg1,
			fg_light = colors.fg0,
			fg_dark = colors.fg2,
			float = colors.bg3,
			float_light = colors.bg4,
			float_dark = colors.bg2,
			surface = colors.bg4,
			surface_light = colors.bg4,
			surface_dark = colors.bg3,
			accent = colors.pink.base,
			red = colors.red.base,
			red_light = colors.red.bright,
			red_dark = colors.red.dim,
			green = colors.green.base,
			green_light = colors.green.bright,
			green_dark = colors.green.dim,
			blue = colors.blue.base,
			blue_light = colors.blue.bright,
			blue_dark = colors.blue.dim,
			cyan = colors.cyan.base,
			cyan_light = colors.cyan.bright,
			cyan_dark = colors.cyan.dim,
			pink = colors.pink.base,
			pink_light = colors.pink.bright,
			pink_dark = colors.pink.dim,
			purple = colors.magenta.base,
			purple_light = colors.magenta.bright,
			purple_dark = colors.magenta.dim,
			yellow = colors.yellow.base,
			yellow_light = colors.yellow.bright,
			yellow_dark = colors.yellow.dim,
			orange = colors.orange.base,
			orange_light = colors.orange.bright,
			orange_dark = colors.orange.dim,
			error = colors.red.base,
			warn = colors.yellow.base,
			info = colors.blue.base,
			hint = colors.cyan.base,
		}

		return color_map
	end,

	["matrix"] = function(_)
		local colors = require("matrix.colors")

		---@type ColorMap
		local color_map = {
			bg = colors.matrix0_gui,
			bg_light = colors.matrix1_gui,
			bg_dark = colors.matrix2_gui,
			fg = colors.matrix6_gui,
			fg_light = colors.matrix4_gui,
			fg_dark = colors.matrix5_gui,
			float = colors.float,
			float_light = colors.matrix7_gui,
			float_dark = colors.matrix9_gui,
			surface = colors.matrix2_gui,
			surface_light = colors.matrix3_gui,
			surface_dark = colors.matrix1_gui,
			accent = "#FF00FF",
			red = colors.matrix11_gui,
			red_light = colors.matrix11_gui,
			red_dark = "#800000",
			green = colors.matrix14_gui,
			green_light = colors.matrix2_gui,
			green_dark = "#008000",
			blue = "#0088ff",
			blue_light = "#00ffff",
			blue_dark = "#0000FF",
			cyan = "#008080",
			cyan_light = "#008080",
			cyan_dark = "#008080",
			pink = "#ff00ff",
			pink_light = "#ff00ff",
			pink_dark = "#ff00ff",
			purple = "#800080",
			purple_light = "#800080",
			purple_dark = "#800080",
			yellow = colors.matrix13_gui,
			yellow_light = colors.matrix13_gui,
			yellow_dark = "#808000",
			orange = colors.matrix15_gui,
			orange_light = colors.matrix15_gui,
			orange_dark = colors.matrix12_gui,
			error = colors.matrix11_gui,
			warn = colors.matrix15_gui,
			info = colors.matrix10_gui,
			hint = "#008080",
		}

		return color_map
	end,
	["midnight"] = function(_)
		local colors = require("midnight.colors").palette
		local components = require("midnight.colors").components
		---@type ColorMap
		local color_map = {
			bg = components.bg,
			bg_light = colors.gray[7],
			bg_dark = colors.gray[8],
			fg = components.fg,
			fg_light = colors.gray[1],
			fg_dark = colors.gray[2],
			float = colors.gray[6],
			float_light = colors.gray[5],
			float_dark = colors.gray[7],
			surface = colors.gray[6],
			surface_light = colors.gray[5],
			surface_dark = colors.gray[7],
			accent = colors.magenta[2],
			red = colors.red[4],
			red_light = colors.red[3],
			red_dark = colors.red[5],
			green = colors.green[4],
			green_light = colors.green[3],
			green_dark = colors.green[5],
			blue = colors.blue[3],
			blue_light = colors.blue[2],
			blue_dark = colors.blue[4],
			cyan = colors.cyan[3],
			cyan_light = colors.cyan[2],
			cyan_dark = colors.cyan[4],
			pink = colors.magenta[2],
			pink_light = colors.magenta[1],
			pink_dark = colors.magenta[2],
			purple = colors.purple[3],
			purple_light = colors.purple[2],
			purple_dark = colors.purple[4],
			yellow = colors.yellow[2],
			yellow_light = colors.yellow[1],
			yellow_dark = colors.yellow[3],
			orange = colors.orange[2],
			orange_light = colors.orange[1],
			orange_dark = colors.orange[3],
			error = components.error,
			warn = components.warn,
			info = components.info,
			hint = components.hint,
		}

		return color_map
	end,
	["sakura"] = function(scheme)
		local lush = require("lush")
		local hsluv = lush.hsluv
		local hex = require("faith.plugins.color.hsl.convert").hsl_to_hex

		local palette = {
			dark = {
				bg0 = hex(hsluv(300, 6, 8)),
				bg1 = hex(hsluv(300, 6, 14)),
				bg2 = hex(hsluv(300, 8, 18)),
				bg3 = hex(hsluv(300, 8, 36)),

				vs0 = hex(hsluv(310, 12, 20)),
				vs1 = hex(hsluv(310, 6, 12)),

				fg0 = hex(hsluv(0, 25, 80)),
				fg1 = hex(hsluv(0, 25, 70)),
				fg8 = hex(hsluv(0, 15, 65)),
				fg9 = hex(hsluv(0, 10, 55)),

				er0 = hex(hsluv(7, 55, 50)),
				er9 = hex(hsluv(7, 55, 20)),

				yl0 = hex(hsluv(40, 40, 60)),
				yl8 = hex(hsluv(40, 40, 30)),
				yl9 = hex(hsluv(40, 40, 20)),

				sr0 = hex(hsluv(300, 40, 65)),
				sr1 = hex(hsluv(300, 35, 55)),
				sr9 = hex(hsluv(300, 35, 20)),

				gr0 = hex(hsluv(150, 35, 60)),
				gr9 = hex(hsluv(150, 35, 20)),

				gb0 = hex(hsluv(260, 35, 60)),
				gb1 = hex(hsluv(260, 35, 50)),
				gb9 = hex(hsluv(260, 35, 20)),

				gp0 = hex(hsluv(270, 50, 65)),
				gp1 = hex(hsluv(270, 40, 55)),
				gp9 = hex(hsluv(270, 35, 20)),

				sa0 = hex(hsluv(340, 35, 65)),
				sa1 = hex(hsluv(340, 35, 55)),
				sa2 = hex(hsluv(340, 30, 45)),

				pi0 = hex(hsluv(310, 15, 60)),
				pi1 = hex(hsluv(310, 15, 45)),
			},
			light = {
				bg0 = hex(hsluv(300, 6, 90)),
				bg1 = hex(hsluv(300, 6, 86)),
				bg2 = hex(hsluv(300, 8, 82)),
				bg3 = hex(hsluv(300, 8, 64)),

				vs0 = hex(hsluv(310, 15, 75)),
				vs1 = hex(hsluv(310, 5, 85)),

				fg0 = hex(hsluv(0, 25, 35)),
				fg1 = hex(hsluv(0, 25, 40)),
				fg8 = hex(hsluv(0, 15, 45)),
				fg9 = hex(hsluv(0, 10, 50)),

				er0 = hex(hsluv(7, 55, 45)),
				er9 = hex(hsluv(7, 45, 70)),

				yl0 = hex(hsluv(40, 45, 45)),
				yl8 = hex(hsluv(40, 45, 70)),
				yl9 = hex(hsluv(40, 40, 75)),

				sr0 = hex(hsluv(300, 45, 45)),
				sr1 = hex(hsluv(300, 45, 50)),
				sr9 = hex(hsluv(300, 35, 55)),

				gr0 = hex(hsluv(150, 35, 45)),
				gr9 = hex(hsluv(150, 35, 70)),

				gb0 = hex(hsluv(260, 35, 45)),
				gb1 = hex(hsluv(260, 35, 50)),
				gb9 = hex(hsluv(260, 35, 55)),

				gp0 = hex(hsluv(270, 50, 45)),
				gp1 = hex(hsluv(270, 40, 50)),
				gp9 = hex(hsluv(270, 35, 55)),

				sa0 = hex(hsluv(340, 40, 50)),
				sa1 = hex(hsluv(340, 35, 55)),
				sa2 = hex(hsluv(340, 30, 60)),

				pi0 = hex(hsluv(310, 20, 45)),
				pi1 = hex(hsluv(310, 15, 50)),
			},
		}

		---@type ColorMap
		local color_map = {
			bg = palette[scheme].bg0,
			bg_light = palette[scheme].bg2,
			bg_dark = palette[scheme].bg1,
			fg = palette[scheme].fg0,
			fg_light = palette[scheme].fg8,
			fg_dark = palette[scheme].fg1,
			float = palette[scheme].vs0,
			float_light = palette[scheme].vs0,
			float_dark = palette[scheme].vs1,
			surface = palette[scheme].pi1,
			surface_light = palette[scheme].pi1,
			surface_dark = palette[scheme].pi0,
			accent = palette[scheme].sa0,
			red = palette[scheme].er0,
			red_light = palette[scheme].er0,
			red_dark = palette[scheme].er9,
			green = palette[scheme].gr0,
			green_light = palette[scheme].gr0,
			green_dark = palette[scheme].gr9,
			blue = palette[scheme].gb1,
			blue_light = palette[scheme].gb0,
			blue_dark = palette[scheme].gb9,
			cyan = palette[scheme].gb1,
			cyan_light = palette[scheme].gb0,
			cyan_dark = palette[scheme].gb9,
			pink = palette[scheme].sa1,
			pink_light = palette[scheme].sa0,
			pink_dark = palette[scheme].sa9,
			purple = palette[scheme].gp1,
			purple_light = palette[scheme].gp0,
			purple_dark = palette[scheme].gp9,
			yellow = palette[scheme].yl0,
			yellow_light = palette[scheme].yl8,
			yellow_dark = palette[scheme].yl9,
			orange = palette[scheme].yl0,
			orange_light = palette[scheme].yl8,
			orange_dark = palette[scheme].yl9,
			error = palette[scheme].er0,
			warn = palette[scheme].yl0,
			info = palette[scheme].gp1,
			hint = palette[scheme].gr0,
		}

		return color_map
	end,
	["yorumi"] = function(scheme)
		local palette = {
			dark = {

				-- yoru
				yoru0 = "#060914",
				yoru1 = "#0C0F1A",
				yoru2 = "#121520",
				yoru3 = "#1D202B",

				-- tsuki
				tsuki0 = "#656771",
				tsuki1 = "#878996",
				tsuki2 = "#A7A9B5",
				tsuki3 = "#BDBFCB",
				tsuki4 = "#C6DFEC",

				-- kuroi
				kuroiRed = "#4E0E0E",
				kuroiGreen = "#1C4642",
				kuroiBlue = "#0D2C4E",
				kuroiYellow = "#6B5905",
				kuroiViolet = "#0E0D17",
				kuroiBlack = "#121210",
				kuroiGray = "#343742",

				-- umi
				umiRed = "#913B3B",
				umiOrange = "#9C672B",
				umiGreen = "#667C4B",
				umiBlue = "#42778A",
				umiYellow = "#9D672F",
				umiMagenta = "#8D3F5A",
				umiCyan = "#49837E",

				-- sango
				sangoRed = "#F05C60",
				sangoOrange = "#D29146",
				sangoGreen = "#80AA6E",
				sangoBlue = "#597BC0",
				sangoYellow = "#BA9A5E",
				sangoMagenta = "#B4647F",
				sangoViolet = "#A188C3",
				sangoCyan = "#7AA8A7",

				-- kairo
				kairoRed = "#F47171",
				kairoOrange = "#F3AB59",
				kairoGreen = "#9CB67D",
				kairoBlue = "#788AD3",
				kairoYellow = "#D6B476",
				kairoMagenta = "#DA72A2",
				kairoViolet = "#958EBE",
				kairoCyan = "#85C7B8",
			},
		}

		---@type ColorMap
		local color_map = {
			bg = palette[scheme].yoru0,
			bg_light = palette[scheme].yoru2,
			bg_dark = palette[scheme].yoru1,
			fg = palette[scheme].tsuki3,
			fg_light = palette[scheme].tsuki4,
			fg_dark = palette[scheme].tsuki2,
			float = palette[scheme].kuroiBlack,
			float_light = palette[scheme].kuroiGray,
			float_dark = palette[scheme].kuroiViolet,
			surface = palette[scheme].yoru3,
			surface_light = palette[scheme].kuroiGray,
			surface_dark = palette[scheme].yoru2,
			accent = palette[scheme].kairoMagenta,
			red = palette[scheme].umiRed,
			red_light = palette[scheme].kairoRed,
			red_dark = palette[scheme].kuroiRed,
			green = palette[scheme].umiGreen,
			green_light = palette[scheme].sangoGreen,
			green_dark = palette[scheme].kuroiGreen,
			blue = palette[scheme].sangoBlue,
			blue_light = palette[scheme].kairoBlue,
			blue_dark = palette[scheme].kuroiBlue,
			cyan = palette[scheme].sangoCyan,
			cyan_light = palette[scheme].kairoCyan,
			cyan_dark = palette[scheme].umiCyan,
			pink = palette[scheme].sangoMagenta,
			pink_light = palette[scheme].kairoMagenta,
			pink_dark = palette[scheme].umiMagenta,
			purple = palette[scheme].sangoViolet,
			purple_light = palette[scheme].kairoViolet,
			purple_dark = palette[scheme].kuroiViolet,
			yellow = palette[scheme].sangoYellow,
			yellow_light = palette[scheme].kairoYellow,
			yellow_dark = palette[scheme].kuroiYellow,
			orange = palette[scheme].sangoOrange,
			orange_light = palette[scheme].kairoOrange,
			orange_dark = palette[scheme].umiOrange,
			error = palette[scheme].umiRed,
			warn = palette[scheme].umiOrange,
			info = palette[scheme].umiBlue,
			hint = palette[scheme].umiCyan,
		}

		return color_map
	end,
}

---@param theme string
local function apply_theme_overrides(theme, scheme)
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
		{ fg = color_map.accent, bg = color_map.bg_light, bold = true }
	)

	local sidebar_bg = color_map.bg_light
	vim.api.nvim_set_hl(0, "SignColumn", {
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "EndOfBuffer", {
		bg = color_map.bg,
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

	vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
		fg = color_map.bg,
		bg = color_map.accent,
		italic = true,
	})

	vim.api.nvim_set_hl(0, "LspInlayHint", { fg = h("Comment").fg })

	vim.api.nvim_set_hl(0, "StatusLine", {
		fg = color_map.fg,
		bg = color_map.bg_light,
	})
	vim.api.nvim_set_hl(0, "WinBar", {
		fg = color_map.fg,
		bg = color_map.bg_light,
	})

	vim.api.nvim_set_hl(
		0,
		"DiagnosticCheck",
		{ fg = color_map.green, bg = color_map.bg_light }
	)

	for _, level in pairs({ "Error", "Warn", "Info", "Hint" }) do
		vim.api.nvim_set_hl(0, "Diagnostic" .. level, {
			fg = color_map[level:lower()],
		})
		vim.api.nvim_set_hl(0, "BarDiag" .. level, {
			link = "Diagnostic" .. level,
			bg = color_map.bg_light,
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

	-- vim.api.nvim_set_hl(
	-- 	0,
	-- 	"YankFlash",
	-- 	{ fg = color_map.surface_dark, bg = color_map.purple_light }
	-- )

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
	vim.api.nvim_set_hl(
		0,
		"@markup.strong",
		{ fg = color_map.red, bold = true }
	)

	vim.api.nvim_set_hl(0, "RainbowRed", { fg = color_map.red })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = color_map.yellow })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = color_map.blue_dark })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = color_map.orange })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = color_map.green })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = color_map.purple_dark })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = color_map.green_light })

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

	vim.api.nvim_set_hl(
		0,
		"TelescopePromptNormal",
		{ bg = telescope_prompt_bg }
	)
	vim.api.nvim_set_hl(
		0,
		"TelescopeResultsNormal",
		{ bg = telescope_prompt_bg }
	)
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
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
		bg = sidebar_bg,
	})
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", {
		bg = sidebar_bg,
		sp = color_map.accent,
		underline = ts_bottom,
	})

	vim.api.nvim_set_hl(0, "WinBar", { bg = color_map.bg_light })

	local cmp_bg = color_map.float
	vim.api.nvim_set_hl(0, "Pmenu", { fg = color_map.fg, bg = cmp_bg })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = color_map.accent, bg = cmp_bg })
	vim.api.nvim_set_hl(0, "PmenuSbar", { fg = color_map.accent, bg = cmp_bg })
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindDefault",
		{ fg = color_map.bg, bg = color_map.purple_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemAbbrDefault",
		{ fg = color_map.bg, bg = color_map.purple_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemMenuDefault",
		{ fg = color_map.bg, bg = color_map.purple_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindSnippet",
		{ fg = color_map.bg, bg = color_map.purple_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindKeyword",
		{ fg = color_map.bg, bg = color_map.red }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindText",
		{ fg = color_map.bg, bg = color_map.green_light }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindMethod",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindConstructor",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindFunction",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindFolder",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindModule",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindConstant",
		{ fg = color_map.bg, bg = color_map.orange }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindField",
		{ fg = color_map.bg, bg = color_map.green }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindProperty",
		{ fg = color_map.bg, bg = color_map.green }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindEnum",
		{ fg = color_map.bg, bg = color_map.green }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindUnit",
		{ fg = color_map.bg, bg = color_map.green }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindClass",
		{ fg = color_map.bg, bg = color_map.yellow }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindVariable",
		{ fg = color_map.bg, bg = color_map.pink_dark }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindFile",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindInterface",
		{ fg = color_map.bg, bg = color_map.yellow }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindColor",
		{ fg = color_map.bg, bg = color_map.red }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindReference",
		{ fg = color_map.bg, bg = color_map.red }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindEnumMember",
		{ fg = color_map.bg, bg = color_map.red }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindStruct",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindValue",
		{ fg = color_map.bg, bg = color_map.orange }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindEvent",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindOperator",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindTypeParameter",
		{ fg = color_map.bg, bg = color_map.blue }
	)
	vim.api.nvim_set_hl(
		0,
		"CmpItemKindCopilot",
		{ fg = color_map.bg, bg = color_map.green_light }
	)

	--scrollbar
	local scroll_handle = color_map.bg_dark
	local scroll_norm = color_map.bg

	vim.api.nvim_set_hl(
		0,
		"ScrollbarHandle",
		{ fg = "NONE", bg = scroll_handle }
	)
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

	local avante_bg = h("NormalFloat").bg
	local avante_tit_bg = color_map.accent
	local avante_tit_fg = color_map.bg
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
		"NeoTreeTabInactive",
		{ bg = color_map.bg_light, fg = tab_inactive_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"NeoTreeTabActive",
		{ bg = color_map.accent, fg = tab_active_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"NeoTreeTabSeparatorInactive",
		{ bg = color_map.bg_light, fg = tab_inactive_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"NeoTreeTabSeparatorActive",
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
	vim.api.nvim_set_hl(
		0,
		"ProgressEmpty",
		{ fg = prog_empty, bg = prog_empty }
	)
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

end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = { "*" },
	callback = function()
		if vim.g.transparent_enabled then
			require("transparent").clear_prefix("lualine_c")
		end
	end,
})

return {
	{
		"zaldih/themery.nvim",
		lazy = false,
		priority = 1000,
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
					apply_theme_overrides(
						"tokyonight",
						args.match:gsub("tokyonight%-", "")
					)
				end,
			})
		end,
		opts = {},
	},
	{
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
	{
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
	{
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
	{
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
	{
		"anAcc22/sakura.nvim",
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
	{
		"yorumicolors/yorumi.nvim",
		init = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = { "yorumi" },
				callback = function(args)
					apply_theme_overrides("yorumi", vim.o.background)
				end,
			})
		end,
	},
	{
		"xiyaowong/nvim-transparent",
		opts = function()
			require("transparent").clear_prefix("lualine_a")
			require("transparent").clear_prefix("lualine_b")
			require("transparent").clear_prefix("lualine_c")
			require("transparent").clear_prefix("lualine_x")
			require("transparent").clear_prefix("lualine_y")
			-- require("transparent").clear_prefix("lualine_z")
			-- require("transparent").clear_prefix("lualine_c_filetype_DevIcon")
			local opts = {
				exclude_groups = {
					"Accent",
					"TabLineSel",
					"TabLineSelSep",

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

					"NormalFloat",
					"NvimTreeNormal",
					"NvimTreeWinSeparator",

					"lualine_transparent",

					"WinBar",
					"TabLine",
					"TabLineSep",

					"HarpoonSeparator",
					"HarpoonInactive",
					"HarpoonNumberInactive",

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
