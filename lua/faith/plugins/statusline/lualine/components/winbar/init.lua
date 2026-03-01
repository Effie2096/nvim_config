local icons = require("faith.icons")

local M = {}

M.ignore = require("faith.plugins.statusline.lualine.components.winbar.ignore")
M.dap_bar =
	require("faith.plugins.statusline.lualine.components.winbar.dap_bar")

_G.__cached_neo_tree_selector = nil
_G.__get_selector = function()
	return _G.__cached_neo_tree_selector
end

M.winbar_ft_icons = {
	dapui_watches = {
		hl = "DAPUIWatchesValue",
		icon = icons.ui.Watches,
	},
	dapui_breakpoints = {
		hl = "DapBreakpoint",
		icon = icons.ui.Bug,
	},
	dapui_stacks = {
		hl = "DAPUISource",
		icon = icons.ui.Stacks,
	},
	dapui_scopes = {
		hl = "DAPUIScope",
		icon = icons.ui.Scopes,
	},
	["dap-repl"] = {
		icon = icons.ui.Repeat,
		name = "REPL",
	},
	dapui_console = {
		hl = "DevIconTerminal",
		icon = require("nvim-web-devicons").get_icon_by_filetype("terminal", {}),
	},
	DiffviewFiles = {
		icon = icons.git.Diff,
		name = "Diffview",
	},
	Outline = {
		icon = icons.ui.BulletList,
		name = "Outline",
	},
	aerial = {
		icon = icons.ui.BulletList,
		name = "Outline",
	},
	trouble = {
		icon = " ",
		name = "",
	},
	toggleterm = {
		hl = "DiagnosticCheck",
		icon = icons.ui.Term,
		name = function()
			local name = {}
			name.name = "Terminal"
			name.data = vim.b.toggle_number
			return name
		end,
	},
	terminal = {
		hl = "DevIconTerminal",
		icon = require("nvim-web-devicons").get_icon_by_filetype(
			"terminal",
			{ default = false }
		) .. " ",
		name = "Terminal",
	},
	OverseerList = {
		hl = "DiagnosticCheck",
		icon = icons.ui.StatusList,
		name = "Overseer",
	},
	undotree = {
		hl = "DiagnosticCheck",
		icon = icons.ui.Undo,
		name = "Undo",
	},
	Avante = {
		icon = icons.ui.Chat,
		name = "Avante",
	},
	AvanteSelectedFiles = {
		name = "Context",
	},
	AvanteInput = {
		name = "Ask Avante",
	},
	["neo-tree"] = {
		name = string.format(" %s ", "%{%v:lua.__get_selector()%}"),
	},
	qf = {},
	fugitive = {
		hl = "DevIconGit",
		icon = require("nvim-web-devicons").get_icon_by_filetype("git", {}),
		name = "Fugitive",
	},
	["neotest-summary"] = {
		hl = "DiagnosticCheck",
		icon = icons.ui.Beaker,
		name = "Tests",
	},
	oil = {
		hl = "OilDir",
		icon = icons.ui.Project,
		name = function()
			local name = {}
			name.name = "Oil"
			name.data = require("oil").get_url_for_path(nil, false):gsub("oil://", "")
			return name
		end,
	},
}

return M
