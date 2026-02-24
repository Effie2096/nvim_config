local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local vnoremap = fk.vnoremap
local xnoremap = fk.xnoremap
local inoremap = fk.inoremap
local tnoremap = fk.tnoremap

local desc = fk.desc

M = {}

local opts = { noremap = true, silent = true }

nnoremap("<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.api.nvim_exec2([[cabbrev h vert h]], { output = false })

nnoremap("<C-d>", "<C-d>zz", opts)
nnoremap("<C-u>", "<C-u>zz", opts)
-- keep search in middle of screen
nnoremap("n", "nzzzv", opts)
nnoremap("N", "Nzzzv", opts)

-- set more standard shortcut for saving
nnoremap("<C-s>", "<cmd>w<CR>", opts)

inoremap("<C-s>", "<cmd>w<CR>", opts)

nnoremap("]q", "<cmd>cnext<CR>zz", opts)
nnoremap("[q", "<cmd>cprevious<CR>zz", opts)
nnoremap("[Q", "<cmd>cfirst<CR>zz", opts)
nnoremap("]Q", "<cmd>clast<CR>zz", opts)

nnoremap("]l", "<cmd>lnext<CR>zz", opts)
nnoremap("[l", "<cmd>lprevious<CR>zz", opts)
nnoremap("[L", "<cmd>lfirst<CR>zz", opts)
nnoremap("]L", "<cmd>llast<CR>zz", opts)

-- keep cursor in same place when combining lines
nnoremap("J", "mzJ`z", opts)

xnoremap("<leader>p", '"_dP', opts)

nnoremap("<leader>y", '"+y', opts)
vnoremap("<leader>y", '"+y', opts)
nnoremap("<leader>Y", '"+Y', opts)

-- Set working dir to dir of current buffer's file
nnoremap(
	"<leader>cd",
	"<cmd>cd %:p:h<CR>",
	desc(
		opts,
		"[c]hange [d]irectory: Change Nvim's current working directory to the path of the current buffer."
	)
)

-- add new line without entering insertmode
nnoremap("<M-o>", "o<Esc>", opts)
nnoremap("<M-O>", "O<Esc>", opts)

-- Visual mode move lines {{
-- using <cmd> instead of : breaks this for some reason
vnoremap("<Down>", ":move '>+1<CR>:normal gv<CR>", opts)
vnoremap("<Up>", ":move '<-2<CR>:normal gv<CR>", opts)

-- Execute macro on visual range without stopping at non matching lines
xnoremap("@", function()
	return ":normal @" .. vim.fn.getcharstr() .. "<CR>"
end, { expr = true })

nnoremap("<C-w>q", "<cmd>close<CR>", opts)

-- index windows and add mappings for jumping directly to them
local function winNumberKeys(index)
	local mapping = "<C-w>" .. index
	local command = "<cmd>" .. index .. "wincmd w<CR>"
	nnoremap(mapping, command, { silent = true })
	tnoremap(mapping, command, { silent = true })
end

local i = 1
while i <= 9 do
	winNumberKeys(i)
	i = i + 1
end

-- Easy CAPS
-- inoremap("<S-U> <ESC>viwUi
nnoremap("<S-U>", "viwU<ESC>", opts)

local tab_next = function(next, count)
	if vim.fn.tabpagenr("$") > 1 then
		if count > vim.fn.tabpagenr("$") then
			return
		end
		vim.cmd(
			(count ~= 0 and count or "") .. (next and "tabnext" or "tabprevious")
		)
	else
		vim.cmd.tabnew()
	end
end

-- stylua: ignore start
nnoremap("gt", function() tab_next(true, vim.v.count) end, opts)
nnoremap("gT", function() tab_next(false, vim.v.count) end, opts)
-- stylua: ignore end

-- better indentation
vnoremap("<", "<gv", opts)
vnoremap(">", ">gv", opts)

-- enter insert mode on next line, with text after cursor on line after that
inoremap("<M-o>", "<Space><Esc>r<CR>O", opts)

-- nnoremap("che", "<cmd>norm f=c^<CR>", opts)
-- nnoremap("cle", "<cmd>norm f=c$<CR>", opts)
