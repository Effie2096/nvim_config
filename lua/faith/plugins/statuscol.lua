vim.pack.add({
	{ src = "https://github.com/luukvbaal/statuscol.nvim" },
}, { load = function() end })

local M = {}

function M.toggle_breakpoint(args)
	local dap = vim.F.npcall(require, "dap")
	if not dap then
		return
	end
	if args.mods:find("c") then
		require("persistent-breakpoints.api").set_conditional_breakpoint()
	else
		require("persistent-breakpoints.api").toggle_breakpoint()
	end
end
function M.lnum_click(args)
	if args.button == "l" then
		-- Toggle DAP (conditional) breakpoint on (clickmod)left click
		M.toggle_breakpoint(args)
	elseif args.button == "m" then
		vim.cmd("norm! yy") -- Yank on middle click
	elseif args.button == "r" then
		if args.clicks == 2 then
			vim.cmd("norm! dd") -- Cut on double right click
		else
			vim.cmd("norm! p") -- Paste on right click
		end
	end
end

local config = function()
	local statuscol = require("statuscol")
	statuscol.setup({
		setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
		-- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
		-- Although I recommend just using the segments field below to build your
		-- statuscolumn to benefit from the performance optimizations in this plugin.
		-- builtin.lnumfunc number string options
		ft_ignore = {
			"dapui_watches",
			"dapui_breakpoints",
			"dapui_console",
			"dapui_stacks",
			"dapui_scopes",
			"dap-repl",
			"lazy",
			"trouble",
			"toggleterm",
			"OverseerList",
			"undotree",
			"Outline",
			"neo-tree",
			"Avante",
			"AvanteSelectedFiles",
			"AvanteInput",
			"neotest-summary",
			"oil",
		},
		bt_ignore = { "terminal", "nofile" },
		thousands = false, -- or line number thousands separator string ("." / ",")
		relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
		-- Builtin 'statuscolumn' options
		-- Default segments (fold -> sign -> line number + separator), explained below
		segments = {
			{
				sign = {
					name = { "coverage" },
					maxwidth = 1,
					colwidth = 1,
					auto = true,
					wrap = false,
				},
			},
			{
				sign = {
					name = { ".*" },
					maxwidth = 4,
					colwidth = 2,
					auto = true,
					wrap = false,
				},
				click = "v:lua.ScSa",
			},
			{
				sign = {
					namespace = {
						"diagnostic%.signs%.sorted",
						"render%-markdown%.nvim",
					},
					text = { "💡", "🔎" },
					name = { "todo%-sign%-.*" },
					maxwidth = 1,
					colwidth = 2,
					auto = false,
					foldclosed = true,
				},
				click = "v:lua.ScSa",
			},
			{
				text = { require("statuscol.builtin").lnumfunc },
				condition = {
					true,
					require("statuscol.builtin").not_empty,
				},
				click = "v:lua.ScLa",
			},
			{
				sign = {
					namespace = { "gitsigns" },
					maxwidth = 1,
					colwidth = 1,
					fillchar = " ",
					fillcharhl = "SignColumn",
					auto = false,
					wrap = false,
				},
			},
			{
				text = { require("statuscol.builtin").foldfunc },
				click = "v:lua.ScFa",
			},
			{
				sign = {
					name = { "Dap" },
					maxwidth = 1,
					colwidth = 1,
					auto = false,
				},
			},
		},
		clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
		-- "a" for Alt, "c" for Ctrl and "m" for Meta.
		clickhandlers = { -- builtin click handlers
			Lnum = require("faith.plugins.statuscol").lnum_click,
			FoldClose = require("statuscol.builtin").foldclose_click,
			FoldOpen = require("statuscol.builtin").foldopen_click,
			FoldOther = require("statuscol.builtin").foldother_click,
			DapBreakpointRejected = require("faith.plugins.statuscol").toggle_breakpoint,
			DapBreakpoint = require("faith.plugins.statuscol").toggle_breakpoint,
			DapBreakpointCondition = require("faith.plugins.statuscol").toggle_breakpoint,
			["diagnostic.signs.sorted"] = require("statuscol.builtin").diagnostic_click,
			GitSignsTopdelete = require("statuscol.builtin").gitsigns_click,
			GitSignsUntracked = require("statuscol.builtin").gitsigns_click,
			GitSignsAdd = require("statuscol.builtin").gitsigns_click,
			GitSignsChange = require("statuscol.builtin").gitsigns_click,
			GitSignsChangedelete = require("statuscol.builtin").gitsigns_click,
			GitSignsDelete = require("statuscol.builtin").gitsigns_click,
			gitsigns_extmark_signs_ = require("statuscol.builtin").gitsigns_click,
		},
	})
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	once = true,
	callback = function()
		vim.cmd.packadd("statuscol.nvim")
		config()
	end,
})

return M
