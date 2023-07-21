vim.g.use_codicons = true
local icons = {
	separators = {
		slant = { left = "", right = "" },
		rounded = { left = "", right = "" },
		arrow = { left = "", right = "" },
		straight = { left = "|", right = "|" },
		arrow_bracket = { left = "", right = "" },
		rounded_bracket = { left = "", right = "" },
		blank = { left = "", right = "" },
	},
	borders = {
		square = {
			top = "─",
			bottom = "─",
			left = "│",
			right = "│",
			top_left = "┌",
			top_right = "┐",
			bottom_left = "└",
			bottom_right = "┘",
			inter_left = "├",
			inter_right = "┤",
		},
		round = {
			top = "─",
			bottom = "─",
			left = "│",
			right = "│",
			top_left = "╭",
			top_right = "╮",
			bottom_left = "╰",
			bottom_right = "╯",
			inter_left = "├",
			inter_right = "┤",
		},
	},
	kind = {
		Array = " ",
		Boolean = "◩ ",
		Class = " ",
		Constant = " ",
		Constructor = " ",
		Enum = "練",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Function = " ",
		Interface = "練",
		Key = " ",
		Method = " ",
		Module = " ",
		Namespace = " ",
		Null = "ﳠ ",
		Number = " ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		String = " ",
		Struct = " ",
		TypeParameter = " ",
		Variable = " ",
	},
	ui = {
		ArrowClosed = "",
		ArrowOpen = "",
		ArrowFillClosed = "",
		ArrowFillOpen = "",
		ArrowNavLeft = " ",
		ArrowNavRight = " ",
		Lock = " ",
		Circle = " ",
		Circle_Empty = " ",
		Dot = "●",
		Mason = "◍ ",
		Diamond = "◆",
		Close = "",
		NewFile = " ",
		Search = " ",
		Multi_Select = " ",
		Caret_Arrow = " ",
		Lightbulb = "",
		Project = " ",
		Dashboard = " ",
		History = " ",
		Comment = " ",
		Bug = " ",
		Code = " ",
		Telescope = " ",
		Gear = " ",
		Package = " ",
		List = " ",
		BulletList = " ",
		SignIn = " ",
		SignOut = " ",
		Check = " ",
		Fire = " ",
		Note = " ",
		BookMark = " ",
		Pencil = " ",
		Question = " ",
		ChevronRight = "",
		Table = "",
		Calendar = "",
		CloudDownload = "",
		Stacks = " ",
		Scopes = "",
		Watches = " ",
		Ellipses = "…",
		Tab = " ",
		House = " ",
		Wand = " ",
	},
	debug = {
		Pause = "",
		Play = "",
		Step_into = "",
		Step_over = "",
		Step_out = "",
		Step_back = "",
		Run_last = "",
		Terminate = "",
		Breakpoint = "",
		BreakpointCond = "",
		BreakpointLog = "",
	},
	characters = {
		eol = "﬋",
		extends = "›",
		nbsp = "␣",
		precedes = "‹",
		space = "•",
		tab = "|->",
		trail = "×",
		indent = "▏",
		indent_focus = "▎",
	},
	diagnostic = {
		error = " ",
		warn = " ",
		hint = " ",
		info = " ",
	},
	git = {
		Add = "+",
		Mod = "~",
		Remove = "-",
		Octoface = " ",
		Branch = "",
		signs = {
			add = "▎",
			mod = "▎",
			delete = "▁",
			top_delete = "▔",
			change_delete = "~",
			untracked = "┊",
		},
	},
}

if vim.g.use_codicons then
	icons.kind = {
		Array = "",
		-- Array = " ",
		-- Boolean = "◩ ",
		Boolean = "",
		-- Class		 = " ",
		-- Class = " ",
		Class = "",
		Color = "",
		-- Constant		 = " ",
		-- Constant = "",
		Constant = "",
		-- Constructor	 = " ",
		-- Constructor = "",
		Constructor = "",
		-- Enum			 = " ",
		Enum = "",
		-- Enum = "練",
		EnumMember = "",
		-- EnumMember = " ",
		-- EnumMember = "",
		-- Event		 = " ",
		-- Event = "",
		Event = "",
		-- Field		 = " ",
		-- Field = " ",
		Field = "",
		-- File			 = " ",
		-- File = " ",
		File = "",
		Folder = "",
		-- Function		 = " ",
		-- Function = "",
		Function = "",
		-- Interface	 = "練",
		-- Interface = " ",
		Interface = "",
		-- Key = "",
		Key = "",
		Keyword = "",
		-- Method		 = " ",
		Method = "",
		-- Method = " ",
		Misc = "",
		-- Module		 = " ",
		-- Module = " ",
		Module = "",
		-- Namespace = "",
		Namespace = "",
		Null = "",
		-- Null = "ﳠ ",
		Number = "",
		-- Number = " ",
		Object = "",
		-- Object = " ",
		-- Operator		 = " ",
		-- Operator = " ",
		Operator = "",
		-- Package = " ",
		Package = "",
		-- Property		 = " ",
		-- Property = " ",
		Property = "",
		Reference = "",
		Snippet = "",
		String = "",
		-- String = " ",
		-- Struct		 = " ",
		Struct = "",
		-- Struct = " ",
		Text = "",
		-- TypeParameter = " ",
		TypeParameter = "",
		-- TypeParameter = " ",
		Unit = "",
		Value = "",
		-- Variable		 = " ",
		-- Variable = " ",
		Variable = "",
	}
end
return icons
