vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:p:h")})%)%( %a%) - %{v:servername}'
vim.opt.iskeyword = vim.opt.iskeyword + { "-" }
vim.opt.termguicolors = true
vim.opt.cmdheight = 1
vim.opt.mouse = "n"
-- vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3
vim.opt.colorcolumn = "100"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line,number"
vim.opt.scrolloff = 8
vim.opt.winminheight = 0
vim.opt.winminwidth = 4
vim.opt.backspace = "indent,eol,start"
vim.opt.showtabline = 2
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.history = 5000
vim.opt.shortmess = vim.opt.shortmess + "c"
vim.opt.signcolumn = "yes:3"
vim.opt.updatetime = 50
vim.opt.timeoutlen = 500
vim.opt.hidden = true
vim.opt.switchbuf = "usetab"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪"
vim.opt.breakat = " ^I!@;:,./?([{"
vim.opt.breakindent = true
vim.opt.breakindentopt = "sbr,shift:8"
vim.opt.showmode = false
vim.opt.pumheight = 20
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.nrformats = "alpha,hex,bin"

-- set format options for each window otherwise it just doens't work for some reason :c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*",
	callback = function()
		-- Auto formatting is BAD.
		vim.opt.formatoptions:remove("a")
		-- Don't auto format my code. I got linters for that.
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
		vim.opt.formatoptions:append("n")
		-- Auto-remove comments if possible.
		vim.opt.formatoptions:append("j")
		vim.opt.formatoptions:remove("2")
	end,
})

vim.api.nvim_create_autocmd({ "Filetype" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		---@diagnostic disable-next-line: assign-type-mismatch
		vim.opt_local.spell = true
	end,
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2

local function QuickFixDo(cmd)
	local bufs = {}
	local commands = vim.split(cmd, " ", {})
	local qflist = vim.fn["getqflist"]()
	for _, value in pairs(qflist) do
		for k, v in pairs(value) do
			if k == "bufnr" then
				bufs[v] = vim.fn["bufname"]({ v })
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
local indentWidth = 4
vim.opt.tabstop = indentWidth
-- vim.opt.softtabstop=indentWidth
vim.opt.shiftwidth = indentWidth
vim.opt.smarttab = true
vim.opt.expandtab = false
vim.opt.smartindent = false
vim.opt.autoindent = false
-- } Indentation

-- searching {
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.api.nvim_set_keymap("n", "<esc>", "<cmd>noh<cr><esc>", { noremap = true, silent = true })
-- } searching
