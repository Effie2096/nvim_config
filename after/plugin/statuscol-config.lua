local has_statuscol, statuscol = pcall(require, "statuscol")
if not has_statuscol then
	return
end

local builtin = require("statuscol.builtin")
local icons = require("faith.icons")

statuscol.setup({
	setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
	-- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
	-- Although I recommend just using the segments field below to build your
	-- statuscolumn to benefit from the performance optimizations in this plugin.
	-- builtin.lnumfunc number string options
	thousands = false, -- or line number thousands separator string ("." / ",")
	relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
	-- Builtin 'statuscolumn' options
	-- Default segments (fold -> sign -> line number + separator), explained below
	segments = {
		{
			text = { builtin.foldfunc },
			click = "v:lua.ScFa",
		},
		{
			sign = {
				name = { ".*" },
				maxwidth = 4,
				colwidth = 1,
				auto = true,
				wrap = false,
			},
			click = "v:lua.ScSa",
		},
		{
			sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = false, foldclosed = true },
			click = "v:lua.ScSa",
		},
		{
			sign = { name = { "Dap" }, maxwidth = 1, colwidth = 1, auto = true },
		},
		{
			text = { builtin.lnumfunc, " " },
			condition = { true, builtin.not_empty },
			click = "v:lua.ScLa",
		},
		{
			sign = {
				namespace = { "gitsigns" },
				maxwidth = 1,
				colwidth = 1,
				-- fillchar = icons.git.signs.add,
				-- fillcharhl = "WinSeparator",
				auto = false,
			},
		},
	},
	clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
	-- "a" for Alt, "c" for Ctrl and "m" for Meta.
	clickhandlers = { -- builtin click handlers
		Lnum = builtin.lnum_click,
		FoldClose = builtin.foldclose_click,
		FoldOpen = builtin.foldopen_click,
		FoldOther = builtin.foldother_click,
		DapBreakpointRejected = builtin.toggle_breakpoint,
		DapBreakpoint = builtin.toggle_breakpoint,
		DapBreakpointCondition = builtin.toggle_breakpoint,
		["diagnostic/signs"] = builtin.diagnostic_click,
		GitSignsTopdelete = builtin.gitsigns_click,
		GitSignsUntracked = builtin.gitsigns_click,
		GitSignsAdd = builtin.gitsigns_click,
		GitSignsChange = builtin.gitsigns_click,
		GitSignsChangedelete = builtin.gitsigns_click,
		GitSignsDelete = builtin.gitsigns_click,
		gitsigns_extmark_signs_ = builtin.gitsigns_click,
	},
})
