vim.opt.title = true
vim.opt.confirm = true
vim.opt.titlestring = "Nvim: %t%( %M%)%( %a%)"
vim.opt.iskeyword:remove({ "-" })
vim.opt.termguicolors = true
vim.opt.cmdheight = 1
vim.opt.conceallevel = 2
vim.opt.mouse = "nvi"
-- vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line,number"
vim.opt.scrolloff = 8
vim.opt.winminheight = 0
vim.opt.winminwidth = 4
vim.opt.backspace = "indent,eol,start"
vim.opt.showtabline = 1
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.history = 5000
vim.opt.shortmess = vim.opt.shortmess + "c"
vim.opt.signcolumn = "yes:3"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.hidden = true
vim.opt.textwidth = 100
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪"
vim.opt.breakat = " ^I!@;:,./?([{"
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:4"
vim.opt.showmode = false
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

-- set format options for each window otherwise it just doens't work for some reason :c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*",
	callback = function(data)
		local ext = vim.fn.fnamemodify(data.file, ":e")

		if ext == "md" then
			vim.opt.formatoptions:remove("c")
			vim.opt.formatoptions:remove("q")
			vim.opt.formatoptions:remove("j")
			vim.opt.formatoptions:remove("l")

			vim.opt.formatoptions:append("w")
			vim.opt.formatoptions:append("a")
			vim.opt.formatoptions:append("n")
		else
			-- defaults ig
			-- Auto formatting is BAD.
			vim.opt.formatoptions:remove("a")
			-- Don't auto format my code. I have linters for that.
			vim.opt.formatoptions:remove("t")
			-- In general, I like it when comments respect textwidth
			vim.opt.formatoptions:append("c")
			-- Allow formatting comments w/ gq
			vim.opt.formatoptions:append("q")
			-- O and o, don't continue comments
			vim.opt.formatoptions:remove("o")
			-- But do continue when pressing enter.
			vim.opt.formatoptions:append("r")
			-- Indent past the formatlistpat, not underneath it.
			vim.opt.formatoptions:append("n") -- doesn't work well with "2"
			vim.opt.formatoptions:remove("2")
			-- Auto-remove comments if possible.
			vim.opt.formatoptions:append("j")
		end
	end,
})

vim.api.nvim_create_autocmd({ "Filetype" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2

local number_toggle_group =
	vim.api.nvim_create_augroup("number_toggle", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" },
	{
		group = number_toggle_group,
		pattern = "*",
		callback = function()
			vim.cmd([[if &nu && mode() != "i" | set rnu | endif]])
		end,
	}
)
vim.api.nvim_create_autocmd(
	{ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" },
	{
		group = number_toggle_group,
		pattern = "*",
		callback = function()
			vim.cmd([[if &nu | set nornu | endif]])
		end,
	}
)

local function QuickFixDo(cmd)
	local bufs = {}
	local commands = vim.split(cmd, " ", {})
	local qflist = vim.fn["getqflist"]()
	for _, value in pairs(qflist) do
		for k, v in pairs(value) do
			if k == "bufnr" then
				bufs[v] = vim.fn.bufname(v)
			end
		end
	end
	for _, v in pairs(bufs) do
		vim.cmd({ cmd = "buffer", args = { v } })
		for _, value in pairs(commands) do
			vim.cmd(value)
		end
		vim.cmd("update")
	end
end
vim.api.nvim_create_user_command("Qfixdo", function(opts)
	QuickFixDo(opts.args)
end, { nargs = 1 })

vim.cmd([[
augroup MakeAutocmd
autocmd!
autocmd MakeAutocmd QuickFixCmdPost lmake call setloclist(
\ winnr(),
\ filter(getloclist(winnr()),
\ "v:val['valid']"), 'r'
\ )
augroup END
]])

-- vim.cmd[[
-- " set all options passed for all open windows in all tabs as well :3
-- function! s:set_all(option, val, ...) abort
--	let val = eval(a:val)

--	for t in range(1, tabpagenr('$'))
--		for w in range(1, tabpagewinnr(t, '$'))
--			if gettabwinvar(t, w, '&buftype') !=# ''
--				continue
--			endif
--			call settabwinvar(t, w, '&'.a:option, val)
--		endfor
--	endfor
-- endfunction

-- command! -complete=option -nargs=+ SetAll call s:set_all(<f-args>)
-- ]]

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

-- searching {
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.api.nvim_set_keymap(
	"n",
	"<esc>",
	"<cmd>noh<cr><esc>",
	{ noremap = true, silent = true }
)
-- } searching
