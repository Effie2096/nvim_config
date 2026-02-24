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
---@field error string
---@field warn string
---@field hint string
---@field info string

---@type table<string, function>
return {
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
			float = colors.surface1,
			float_light = colors.surface2,
			float_dark = colors.surface0,
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
	["kanagawa"] = function(scheme)
		local colors = require("kanagawa.colors").setup({ theme = scheme })

		---@type ColorMap
		local color_map = {
			bg = colors.theme.ui.bg,
			bg_light = colors.theme.ui.bg_gutter,
			bg_dark = colors.theme.ui.bg_dim,
			fg = colors.theme.ui.fg,
			fg_light = colors.theme.ui.fg_reverse,
			fg_dark = colors.theme.ui.fg_dim,
			float = colors.theme.ui.float.bg,
			float_light = colors.theme.ui.pmenu.bg_sel,
			float_dark = colors.theme.ui.pmenu.bg,
			surface = colors.theme.ui.bg_m2,
			surface_light = colors.theme.ui.bg_m1,
			surface_dark = colors.theme.ui.bg_m3,

			accent = colors.palette.sakuraPink,
			red = colors.palette.samuraiRed,
			red_light = colors.palette.peachRed,
			red_dark = colors.palette.lotusRed3,
			green = colors.palette.springGreen,
			green_light = colors.palette.lotusGreen3,
			green_dark = colors.palette.lotusGreen2,
			blue = colors.palette.crystalBlue,
			blue_light = colors.palette.lotusBlue3,
			blue_dark = colors.palette.lotusBlue4,
			cyan = colors.palette.springBlue,
			cyan_light = colors.palette.lightBlue,
			cyan_dark = colors.palette.waveAqua2,
			pink = colors.palette.sakuraPink,
			pink_light = colors.palette.lotusPink,
			pink_dark = colors.palette.dragonPink,
			purple = colors.palette.lotusViolet4,
			purple_light = colors.palette.oniViolet,
			purple_dark = colors.palette.lotusInk2,
			yellow = colors.palette.lotusYellow3,
			yellow_light = colors.palette.lotusYellow4,
			yellow_dark = colors.palette.lotusYellow2,
			orange = colors.palette.lotusOrange2,
			orange_light = colors.palette.surimiOrange,
			orange_dark = colors.palette.lotusOrange,
			error = colors.palette.samuraiRed,
			warn = colors.palette.roninYellow,
			info = colors.palette.waveAqua2,
			hint = colors.palette.dragonBlue,
		}

		return color_map
	end,
	["eldritch"] = function(scheme)
		local colors = require("eldritch.colors")

		---@type ColorMap
		local color_map = {
			bg = colors[scheme].bg,
			bg_light = colors[scheme].bg_highlight,
			bg_dark = colors[scheme].bg_dark,
			fg = colors[scheme].fg,
			fg_light = colors[scheme].fg_dark,
			fg_dark = colors[scheme].fg_gutter,
			float = colors[scheme].bg_dark,
			float_light = colors[scheme].bg_highlight,
			float_dark = colors[scheme].bg_highlight,
			surface = colors[scheme].bg_dark,
			surface_light = colors[scheme].bg_dark,
			surface_dark = colors[scheme].bg_popup,
			accent = colors[scheme].magenta2,
			red = colors[scheme].red,
			red_light = colors[scheme].bright_red,
			red_dark = colors[scheme].red,
			green = colors[scheme].green,
			green_light = colors[scheme].bright_green,
			green_dark = colors[scheme].dark_green,
			blue = colors[scheme].cyan,
			blue_light = colors[scheme].bright_cyan,
			blue_dark = colors[scheme].dark_cyan,
			cyan = colors[scheme].cyan,
			cyan_light = colors[scheme].bright_cyan,
			cyan_dark = colors[scheme].dark_cyan,
			pink = colors[scheme].pink,
			pink_light = colors[scheme].magenta2,
			pink_dark = colors[scheme].magenta2,
			purple = colors[scheme].purple,
			purple_light = colors[scheme].magenta,
			purple_dark = colors[scheme].magenta3,
			yellow = colors[scheme].yellow,
			yellow_light = colors[scheme].yellow,
			yellow_dark = colors[scheme].dark_yellow,
			orange = colors[scheme].orange,
			orange_light = colors[scheme].orange,
			orange_dark = colors[scheme].orange,
			error = colors[scheme].error,
			warn = colors[scheme].warning,
			info = colors[scheme].info,
			hint = colors[scheme].hint,
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
			float_dark = colors.bg_dark1,
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
			hint = colors.purple,
		}

		return color_map
	end,
	["nightfox"] = function(scheme)
		local colors = require("nightfox.palette").load(scheme)

		---@type ColorMap
		local color_map = {
			bg = colors.bg2,
			bg_light = colors.bg1,
			bg_dark = colors.bg0,
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
	["yorumi"] = function(_)
		local palette = require("yorumi.colors")

		---@type ColorMap
		local color_map = {
			bg = palette.yoru0,
			bg_light = palette.yoru2,
			bg_dark = palette.yoru1,
			fg = palette.tsuki3,
			fg_light = palette.tsuki4,
			fg_dark = palette.tsuki2,
			float = palette.kuroiBlack,
			float_light = palette.kuroiGray,
			float_dark = palette.kuroiViolet,
			surface = palette.yoru3,
			surface_light = palette.kuroiGray,
			surface_dark = palette.yoru2,
			accent = palette.kairoMagenta,
			red = palette.umiRed,
			red_light = palette.kairoRed,
			red_dark = palette.kuroiRed,
			green = palette.umiGreen,
			green_light = palette.sangoGreen,
			green_dark = palette.kuroiGreen,
			blue = palette.sangoBlue,
			blue_light = palette.kairoBlue,
			blue_dark = palette.kuroiBlue,
			cyan = palette.sangoCyan,
			cyan_light = palette.kairoCyan,
			cyan_dark = palette.umiCyan,
			pink = palette.sangoMagenta,
			pink_light = palette.kairoMagenta,
			pink_dark = palette.umiMagenta,
			purple = palette.sangoViolet,
			purple_light = palette.kairoViolet,
			purple_dark = palette.kuroiViolet,
			yellow = palette.sangoYellow,
			yellow_light = palette.kairoYellow,
			yellow_dark = palette.kuroiYellow,
			orange = palette.sangoOrange,
			orange_light = palette.kairoOrange,
			orange_dark = palette.umiOrange,
			error = palette.umiRed,
			warn = palette.umiOrange,
			info = palette.umiBlue,
			hint = palette.umiCyan,
		}

		return color_map
	end,
}
