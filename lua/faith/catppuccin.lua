local catp_status_ok, catppuccin = pcall(require, "catppuccin")
if not catp_status_ok then
	return
end

-- configure it
catppuccin.setup({
	compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
	transparent_background = true,
	term_colors = false,
	dim_inactive = {
		enable = false,
		shade = "dark",
		percentage = 0.15
	},
	styles = {
		comments = { "italic" },
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
		-- mason = true
	}
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "catppuccin.lua" },
	callback = function()
		local path = vim.fn.stdpath("config")
		vim.cmd("luafile" .. path .. "/lua/faith/catppuccin.lua")
		require('catppuccin').compile()
	end
})

--[[ vim.api.nvim_create_autocmd("ColorSchemePre", {
	pattern = "*",
	callback = function ()
	end,
}) ]]

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local colors = require 'catppuccin.palettes'.get_palette()
		local changeColor = colors.blue
		vim.api.nvim_exec('highlight GitSignsChange guifg=' .. changeColor, false)
		vim.api.nvim_exec('highlight GitSignsChangeNr guifg=' .. changeColor, false)
		vim.api.nvim_exec('highlight GitSignsChangeLn guifg=' .. changeColor .. ' guibg=' .. colors.base, false)

		vim.api.nvim_set_hl(0, "LspInlayHint", { fg = '#d8d8d8', bg = '#3a3a3a' })

		local tabFill = colors.mantle
		local tabBG = colors.surface1
		local tabFG = colors.subtext0
		local tabSelBG = colors.sapphire
		local tabSelFG = colors.crust
		local tabSepBG = tabFill
		local tabSepFG = tabBG
		local tabSepSelFG = tabSelBG
		local modified = colors.red

		vim.api.nvim_set_hl(0, "TabLineFill", { bg = tabFill })
		vim.api.nvim_set_hl(0, "TabLineNum", { fg = colors.text, bg = tabBG })
		vim.api.nvim_set_hl(0, "TabLine", { fg = tabFG, bg = tabBG })
		vim.api.nvim_set_hl(0, "TabLineSel", { fg = tabSelFG, bg = tabSelBG, bold = true })
		vim.api.nvim_set_hl(0, "TabModified", { fg = modified, bg = tabBG })
		vim.api.nvim_set_hl(0, "TabModifiedSelected", { fg = modified, bg = tabSelBG })
		vim.api.nvim_set_hl(0, "TabLineSep", { fg = tabSepFG, bg = tabSepBG })
		vim.api.nvim_set_hl(0, "TabLineSelSep", { fg = tabSepSelFG, bg = tabSepBG })
		-- vim.api.nvim_set_hl(0, "TabLineClose",		 { fg = colors.red, bg = tabBG })
		-- vim.api.nvim_set_hl(0, "TabLineSelClose",		{ fg = colors.red, bg = tabSelBG })

		local numBG = colors.pink
		local numFG = colors.crust
		local fileBG = colors.surface2
		local fileFG = colors.subtext1
		local navBG = colors.surface1
		local navFG = colors.rosewater --subtext0
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
		vim.api.nvim_set_hl(0, "WinBarWinNumEnd", { fg = numBG,  --[[ bg = colors.base ]] })
		vim.api.nvim_set_hl(0, "WinBarFile", { fg = fileFG, --[[ bg = fileBG, ]] bold = true })
		vim.api.nvim_set_hl(0, "WinBarFileModified", { fg = modified, --[[ bg = fileBG, ]] bold = true })
		vim.api.nvim_set_hl(0, "WinBarNavic", { fg = fileFG, --[[ bg = navBG ]] })
		vim.api.nvim_set_hl(0, "WinBarFileSep", { fg = fileBG, --[[ bg = navBG ]] })
		vim.api.nvim_set_hl(0, "WinBarFileEnd", { fg = fileBG, --[[ bg = colors.base ]] })
		vim.api.nvim_set_hl(0, "WinBarNavicEnd", { fg = navBG, --[[ bg = colors.base ]] })

		--[[ local navicHLGroups = { "NavicIconsFile", "NavicIconsModule", "NavicIconsNamespace", "NavicIconsPackage",
			"NavicIconsClass", "NavicIconsMethod", "NavicIconsProperty", "NavicIconsField", "NavicIconsConstructor",
			"NavicIconsEnum", "NavicIconsInterface", "NavicIconsFunction", "NavicIconsVariable", "NavicIconsConstant",
			"NavicIconsString", "NavicIconsNumber", "NavicIconsBoolean", "NavicIconsArray", "NavicIconsObject", "NavicIconsKey",
			"NavicIconsNull", "NavicIconsEnumMember", "NavicIconsStruct", "NavicIconsEvent", "NavicIconsOperator",
			"NavicIconsTypeParameter", "NavicText", "NavicSeparator", }

		for _, value in pairs(navicHLGroups) do
			vim.api.nvim_set_hl(0, value, { bg = navBG, fg = navFG })
		end ]]

		local telescope_normal = colors.surface0
		local telescope_prompt = colors.surface1

		vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = telescope_normal })
		vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = telescope_prompt })
		vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = telescope_prompt })
		vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.blue, bg = telescope_normal })
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.blue, bg = telescope_prompt })
		vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = colors.crust, bg = colors.pink })
		vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = colors.crust, bg = colors.green })

		local icons = require('nvim-web-devicons').get_icons()
		for _, value in pairs(icons) do
			local hl_name = 'WinbarDevIcon' .. value.name
			vim.api.nvim_set_hl(0, hl_name, { fg = value.color, bg = fileBG })
		end

		local white_space_colors = vim.api.nvim_get_hl_by_name("Whitespace", true)
		vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", { fg = white_space_colors.foreground })
		vim.api.nvim_set_hl(0, "IndentBlanklineSpaceCharBlankline", { fg = white_space_colors.foreground })

		vim.api.nvim_set_hl(0, "IndentBlanklineContextStart", { sp = colors.text, underline = true })

		vim.cmd [[highlight ExtraWhitespace ctermfg=red guifg=red gui=nocombine]]

		vim.api.nvim_set_hl(0, "TermCursor", { bg = colors.pink })

		-- Color Column
		vim.api.nvim_exec('hi ColorColumn guifg=' .. colors.red .. ' guibg=' .. colors.surface2, false)

		vim.api.nvim_exec('hi YankFlash guifg=' .. colors.base .. ' guibg=' .. colors.lavender, false)

	end
})

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-blinkon10,r-cr-o:hor20,a:-TermCursor"

-- Only display colorcolumn on lines that exceed it
vim.cmd [[au BufWinEnter,BufReadPost * call matchadd('ColorColumn', '\%81v', 100)]]

vim.cmd [[
		augroup highlight_yank
		autocmd!
		au TextYankPost * silent lua vim.highlight.on_yank({higroup="YankFlash", timeout=40})
		augroup END
]]

vim.cmd [[2match ExtraWhitespace /\s\+$/]]
vim.cmd [[autocmd BufWinEnter * 2match ExtraWhitespace /\s\+$/]]
vim.cmd [[autocmd InsertEnter * 2match ExtraWhitespace /\s\+\%#\@<!$/]]
vim.cmd [[autocmd InsertLeave * 2match ExtraWhitespace /\s\+$/]]
vim.cmd [[autocmd BufWinLeave * call clearmatches()]]
