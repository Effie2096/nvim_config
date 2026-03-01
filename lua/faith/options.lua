local icons = require("faith.icons")

vim.opt.title = true
vim.opt.titlestring = "Nvim: %t%( %M%)%( %a%)"

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.opt.backspace = "indent,eol,start"
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.cmdheight = 1
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
vim.opt.shortmess:append({ c = true })
vim.opt.showmode = false
vim.opt.showtabline = 1
vim.opt.signcolumn = "yes:3"
vim.opt.smartcase = true
vim.opt.splitbelow = false
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wrap = true
vim.opt.writebackup = false
vim.opt.numberwidth = 3

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
	horiz = icons.borders.square.top, -- "─",
	horizup = icons.borders.square.inter_bottom, -- "┴",
	horizdown = icons.borders.square.inter_top, -- "┬",
	vert = icons.borders.square.left,
	vertleft = icons.borders.square.inter_right, -- "┤",
	vertright = icons.borders.square.inter_left, -- "├",
	verthoriz = icons.borders.square.center, -- "┼",
	diff = icons.git.signs.diff,
})

-- default tcqj
vim.opt.formatoptions = {
	-- Auto formatting is BAD.
	a = false,
	-- Don't auto format my code. I have linters for that.
	t = false,
	-- In general, I like it when comments respect textwidth
	c = true,
	-- Allow formatting comments w/ gq
	q = true,
	-- O and o, don't continue comments
	o = false,
	-- But do continue when pressing enter.
	r = true,
	-- Indent past the formatlistpat, not underneath it.
	n = true,
	["2"] = false,
	-- Auto-remove comments if possible.
	j = true,
}
