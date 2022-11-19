local status_ok, faith_keymap = pcall(require, 'faith.keymap')
if not status_ok then
	return
end

local nnoremap = faith_keymap.nnoremap
local vnoremap = faith_keymap.vnoremap
local xnoremap = faith_keymap.xnoremap
local inoremap = faith_keymap.inoremap
local tnoremap = faith_keymap.tnoremap

M = {}

local opts = { noremap = true, silent = true }

nnoremap("<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_exec([[cabbrev h vert h]], false)
tnoremap("<ESC>", "<C-\\><C-n>", opts)
inoremap("<C-w>k", "<Esc><C-w>k", opts)

-- Terminal go back to normal mode
tnoremap("<Esc>", "<C-\\><C-n>")
tnoremap(":q!", "<C-\\><C-n>:q!<CR>")
-- set more standard shortcut for saving
nnoremap("<C-s>", "<cmd>w<CR>", opts)

inoremap("<C-s>", "<cmd>w<CR>", opts)

nnoremap("]q", "<cmd>cnext<CR>zz", opts)
nnoremap("[q", "<cmd>cprevious<CR>zz", opts)
nnoremap("[Q", "<cmd>cfirst<CR>zz", opts)
nnoremap("]Q", "<cmd>clast<CR>zz", opts)

-- Set working dir to dir of current buffer's file
nnoremap("<leader>cd", "<cmd>cd %:p:h<CR>", opts)

-- add new line without entering insertmode
nnoremap("<M-o>", "o<Esc>", opts)
nnoremap("<M-O>", "O<Esc>", opts)

-- Visual mode move lines {{
-- using <cmd> instead of : breaks this for some reason
vnoremap("<Down>", ":move '>+1<CR>gv=gv", opts)
vnoremap("<Up>", ":move '<-2<CR>gv=gv", opts)

-- Execute macro on visual range without stopping at non matching lines
-- TODO: find out how to do this in lua
--[[ xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
	echo "@".getcmdline()
	execute ":'<,'>normal @".nr2char(getchar())
endfunction ]]

nnoremap("z]", "<cmd>silent! normal! zx<CR>zczjzozz", opts)
nnoremap("z[", "<cmd>silent! normal! zx<CR>zczkzo[zzz", opts)

nnoremap("<C-w>q", "<cmd>close<CR>", opts)
-- Use alt + hjkl to resize windows
nnoremap("<M-h>", "<cmd>vertical resize -2<CR>", opts)
nnoremap("<M-j>", "<cmd>resize -2<CR>", opts)
nnoremap("<M-k>", "<cmd>resize +2<CR>", opts)
nnoremap("<M-l>", "<cmd>vertical resize +2<CR>", opts)

-- index windows and add mappings for jumping directly to them
local function winNumberKeys(index)
	local mapping = "<C-w>" .. index
	local command = "<cmd>" .. index .. "wincmd w<CR>"
	nnoremap(mapping, command, { silent = true })
end

local i = 1
while i <= 9 do
	winNumberKeys(i)
	i = i + 1
end

-- Easy CAPS
-- inoremap("<S-U> <ESC>viwUi
nnoremap("<S-U>", "viwU<ESC>", opts)

-- TAB in normal mode will move to next buffer
nnoremap("<TAB>", "<cmd>bnext<CR>", opts)
-- SHIFT-TAB will go back
nnoremap("<S-TAB>", "<cmd>bprevious<CR>", opts)

nnoremap("<PageUp>", "<cmd>tabnext<CR>", opts)
nnoremap("<PageDown>", "<cmd>tabprevious<CR>", opts)

-- better indentation
vnoremap("<", "<gv", opts)
vnoremap(">", ">gv", opts)

-- enter insert mode on next line, with text after cursor on line after that
inoremap("<M-o>", "<Space><Esc>r<CR>O", opts)

-- Delete current buffer without closing split
nnoremap("<leader>bc", "<cmd>bp |bd #<CR>", opts)
