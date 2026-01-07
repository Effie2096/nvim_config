vim.opt.title = true
vim.opt.titlestring = "Nvim: %t%( %M%)%( %a%)"

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.opt.backspace = "indent,eol,start"
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.cmdheight = 1
vim.opt.colorcolumn = "80"
vim.opt.conceallevel = 2
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line,number"
vim.opt.hidden = true
vim.opt.history = 5000
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.iskeyword:append({ "-" })
vim.opt.laststatus = 3
vim.opt.list = false
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a"
vim.opt.mouse = "nvi"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shortmess = vim.opt.shortmess + "c"
vim.opt.showmode = false
vim.opt.showtabline = 1
vim.opt.signcolumn = "yes:3"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.textwidth = 100
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.winminheight = 0
vim.opt.winminwidth = 4
vim.opt.wrap = false
vim.opt.writebackup = false
vim.opt.numberwidth = 3

-- Indentation {
local indentWidth = 2
vim.opt.tabstop = indentWidth
vim.opt.softtabstop = 0
vim.opt.shiftwidth = indentWidth
vim.opt.smarttab = true
vim.opt.expandtab = false
vim.opt.smartindent = false
vim.opt.autoindent = false
-- } Indentation

vim.opt.linebreak = true
vim.opt.showbreak = "▉" .. (string.rep(" ", indentWidth - 1) or "")
vim.opt.breakat = " ^I!@;:,./?([{"
vim.opt.breakindent = true
vim.opt.breakindentopt = { "shift:" .. ((indentWidth * 2) - 1), "sbr" }
vim.opt.pumheight = 20
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.nrformats = "alpha,hex,bin"
vim.opt.fillchars:append({
	horiz = " ", -- "─",
	horizup = "│", -- "┴",
	horizdown = " ", -- "┬",
	vert = "│",
	vertleft = "│", -- "┤",
	vertright = "│", -- "├",
	verthoriz = "│", -- "┼",
	diff = "╱",
})
