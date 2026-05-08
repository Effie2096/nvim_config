local icons = require("faith.icons")

vim.opt.title = true
vim.opt.titlestring = "Nvim: %t%( %M%)%( %a%)"

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.opt.backspace = "indent,eol,start"
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.cmdheight = 0
vim.opt.showcmdloc = "last"
vim.opt.conceallevel = 2
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.guicursor = {
	"v-c:block",
	"i-ci-ve:ver20",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250-inverse/reverse",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}
vim.opt.cursorlineopt = "line,number"
vim.opt.hidden = true
vim.opt.history = 5000
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.iskeyword:append({ "-" })
vim.opt.laststatus = 3
vim.opt.list = false
vim.opt.listchars = {
	eol = icons.characters.eol,
	tab = icons.characters.tab,
	space = icons.characters.space,
	trail = icons.characters.trail,
	extends = icons.characters.extends,
	precedes = icons.characters.precedes,
	nbsp = icons.characters.nbsp,
}
vim.opt.mouse = "a"
vim.opt.mousemoveevent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.smoothscroll = true
vim.opt.shortmess:append({ c = true })
vim.opt.showmode = false
vim.opt.showtabline = 1
vim.opt.signcolumn = "auto"
vim.opt.numberwidth = 3
vim.opt.smartcase = true
vim.opt.splitbelow = false
vim.opt.splitright = true
vim.opt.splitkeep = "screen"
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.textwidth = 80
vim.opt.colorcolumn = "0"
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 200
vim.opt.wrap = true
vim.opt.writebackup = false

-- Indentation {
local indentWidth = 2
vim.opt.tabstop = indentWidth
-- vim.opt.softtabstop = 0 -- 0 means this is Off
vim.opt.shiftwidth = indentWidth
-- vim.opt.smarttab = true
-- vim.opt.expandtab = false
-- vim.opt.smartindent = true
-- vim.opt.autoindent = true
-- } Indentation

vim.opt.linebreak = true
vim.opt.showbreak = icons.characters.showbreak
	.. (string.rep(" ", ((indentWidth * 2) - 1) or 0) or "")
vim.opt.breakat = " ^!@;:,./?([{<>"
vim.opt.breakindent = true
vim.opt.breakindentopt = { "shift:0" }
vim.opt.pumheight = 20
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.nrformats = "alpha,hex,bin"
vim.opt.fillchars:append({
	horiz = icons.borders.edge_thin.top, -- "─",
	horizup = icons.borders.edge_thin.top, -- "┴",
	horizdown = icons.borders.edge_thin.top_left, -- "┬",
	vert = icons.borders.edge_thin.left,
	vertleft = icons.borders.edge_thin.left, -- "┤",
	vertright = icons.borders.edge_thin.top_left, -- "├",
	verthoriz = icons.borders.edge_thin.top_left, -- "┼",
	diff = icons.git.signs.diff,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	group = vim.api.nvim_create_augroup("set_formatoptions", { clear = true }),
	pattern = "*",
	callback = function(_)
		-- default tcqj
		-- Auto formatting is BAD.
		vim.opt_local.formatoptions:remove("a")
		-- Don't auto format my code. I have linters for that.
		vim.opt_local.formatoptions:remove("t")
		-- In general, I like it when comments respect textwidth
		vim.opt_local.formatoptions:append("c")
		-- Allow formatting comments w/ gq
		vim.opt_local.formatoptions:append("q")
		-- O and o, don't continue comments
		vim.opt_local.formatoptions:remove("o")
		-- But do continue when pressing enter.
		vim.opt_local.formatoptions:append("r")
		-- Indent past the formatlistpat, not underneath it.
		vim.opt_local.formatoptions:append("n")
		vim.opt_local.formatoptions:remove("2")
		-- Auto-remove comments if possible.
		vim.opt_local.formatoptions:append("j")
	end,
})
