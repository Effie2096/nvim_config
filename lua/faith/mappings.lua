M = {}

local opts = { noremap = true, silent = true }

local desc = function(outer, desc)
	return vim.tbl_extend("force", vim.deepcopy(outer), { desc = desc })
end

vim.keymap.set({"n"}, "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.api.nvim_exec2([[cabbrev h vert h]], { output = false })

vim.keymap.set({"n"}, "<C-d>", "<C-d>zz", opts)
vim.keymap.set({"n"}, "<C-u>", "<C-u>zz", opts)
-- keep search in middle of screen
vim.keymap.set({"n"}, "n", "nzzzv", opts)
vim.keymap.set({"n"}, "N", "Nzzzv", opts)

-- set more standard shortcut for saving
vim.keymap.set({"n", "i"}, "<C-s>", "<cmd>w<CR>", opts)

-- keep cursor in same place when combining lines
vim.keymap.set({"n"}, "J", "mzJ`z", opts)

vim.keymap.set({"x"}, "<leader>p", '"_dP', opts)

vim.keymap.set({"n", "v"}, "<leader>y", '"+y', opts)
vim.keymap.set({"n"}, "<leader>Y", '"+Y', opts)

-- Set working dir to dir of current buffer's file
vim.keymap.set({"n"}, 
	"<leader>cd",
	"<cmd>cd %:p:h<CR>",
	desc(
		opts,
		"[c]hange [d]irectory: Change Nvim's current working directory to the path of the current buffer."
	)
)

-- add new line without entering insertmode
vim.keymap.set({"n"}, "<M-o>", "o<Esc>", opts)
vim.keymap.set({"n"}, "<M-O>", "O<Esc>", opts)

-- Visual mode move lines {{
-- using <cmd> instead of : breaks this for some reason
vim.keymap.set({"v"}, "<Down>", ":move '>+1<CR>:normal gv<CR>", opts)
vim.keymap.set({"v"}, "<Up>", ":move '<-2<CR>:normal gv<CR>", opts)

-- Execute macro on visual range without stopping at non matching lines
vim.keymap.set({"x"}, "@", function()
	return ":normal @" .. vim.fn.getcharstr() .. "<CR>"
end, { expr = true })

vim.keymap.set({"n"}, "<C-w>q", "<cmd>close<CR>", opts)

-- index windows and add mappings for jumping directly to them
local function winNumberKeys(index)
	local mapping = "<C-w>" .. index
	local command = "<cmd>" .. index .. "wincmd w<CR>"
	vim.keymap.set({"n"}, mapping, command, { silent = true })
	vim.keymap.set({"t"}, mapping, command, { silent = true })
end

local i = 1
while i <= 9 do
	winNumberKeys(i)
	i = i + 1
end

-- Easy CAPS
vim.keymap.set({"n"}, "<S-U>", "viwU<ESC>", opts)

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
vim.keymap.set({"n"}, "gt", function() tab_next(true, vim.v.count) end, opts)
vim.keymap.set({"n"}, "gT", function() tab_next(false, vim.v.count) end, opts)
-- stylua: ignore end

-- better indentation
vim.keymap.set({"v"}, "<", "<gv", opts)
vim.keymap.set({"v"}, ">", ">gv", opts)

-- enter insert mode on next line, with text after cursor on line after that
vim.keymap.set({"i"}, "<M-o>", "<Space><Esc>r<CR>O", opts)

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set(
	"t",
	"<Esc><Esc>",
	"<C-\\><C-n>",
	{ desc = "Exit terminal mode" }
)
