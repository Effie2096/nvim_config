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
		Dot = "",
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
		ChevronRight = "",
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
	},
}

if vim.g.use_codicons then
	icons.kind = {
		Array = " ",
		Boolean = "◩ ",
		-- Class		 = " ",
		Class = " ",
		Color = " ",
		Constant = " ",
		-- Constant		 = " ",
		Constructor = " ",
		-- Constructor	 = " ",
		Enum = "練",
		-- Enum			 = " ",
		-- EnumMember	 = " ",
		EnumMember = " ",
		Event = " ",
		-- Event		 = " ",
		-- Field		 = " ",
		Field = " ",
		-- File			 = " ",
		File = " ",
		Folder = " ",
		Function = " ",
		-- Function		 = " ",
		-- Interface	 = "練",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = " ",
		-- Method		 = " ",
		Misc = " ",
		Module = " ",
		-- Module		 = " ",
		Namespace = " ",
		Null = "ﳠ ",
		Number = " ",
		Object = " ",
		-- Operator		 = " ",
		Operator = " ",
		Package = " ",
		-- Property		 = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = " ",
		-- Struct		 = " ",
		Text = " ",
		TypeParameter = " ",
		-- TypeParameter = " ",
		Unit = " ",
		Value = " ",
		-- Variable		 = " ",
		Variable = " ",
	}
end
return icons
