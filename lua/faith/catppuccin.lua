local catp_status_ok, catppuccin = pcall(require, "catppuccin")
if not catp_status_ok then
	return
end

-- configure it
catppuccin.setup({
	compile_path = vim.fn.glob(vim.fn.stdpath("cache") .. "/catppuccin"),
	transparent_background = vim.g.trasparent_enabled,
	term_colors = false,
	dim_inactive = {
		enable = false,
		shade = "dark",
		percentage = 0.15,
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

		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = accent, bg = signHl.background })

		local changeColor = colors.blue
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green, bg = signHl.background })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = changeColor, bg = signHl.background })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.red, bg = signHl.background })
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

		vim.api.nvim_set_hl(
			0,
			"CmpItemKindField",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@field" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindProperty",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@property" }).foreground }
		)
		vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = kindFG, bg = colors.yellow })
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindText",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@string" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindEnum",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@constant" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindKeyword",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@keyword" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindConstant",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@constant" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindConstructor",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@function" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindReference",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@function" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindFunction",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@function" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindStruct",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@structure" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindClass",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@storageclass" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindModule",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@storageclass" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindOperator",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@operator" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindVariable",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@variable" }).foreground }
		)
		vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = kindFG, bg = colors.blue })
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindUnit",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@storageclass" }).foreground }
		)
		vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = kindFG, bg = colors.mauve })
		vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = kindFG, bg = colors.yellow })
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindMethod",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@function" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindValue",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@constant" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindEnumMember",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@constant" }).foreground }
		)
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindInterface",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@storageclass" }).foreground }
		)
		vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = kindFG, bg = colors.sky })
		vim.api.nvim_set_hl(
			0,
			"CmpItemKindTypeParameter",
			{ fg = kindFG, bg = vim.api.nvim_get_hl(0, { name = "@operator" }).foreground }
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
			vim.api.nvim_set_hl(0, "HarpoonInactive", { link = "Tabline" })
			vim.api.nvim_set_hl(0, "HarpoonActive", { link = "TablineSel" })
			vim.api.nvim_set_hl(0, "HarpoonNumberActive", { link = "TablineSel" })
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
