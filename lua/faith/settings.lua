vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:p:h")})%)%( %a%) - %{v:servername}'
vim.opt.iskeyword = vim.opt.iskeyword + { "-" }													-- treat dash separated words as a word text object
vim.opt.termguicolors = true
-- vim.opt.ruler = true																										-- Show the cursor position all the time
vim.opt.cmdheight=0
vim.opt.mouse="n"																												-- Enable your mouse
-- vim.opt.splitbelow = true																								-- Horizontal splits will automatically be below
vim.opt.splitright = true																								-- Vertical splits will automatically be to the right
vim.opt.laststatus=3																									-- Always display the status line
-- vim.opt.winbar ="%=%{tabpagewinnr(tabpagenr())}%m %f%="
-- vim.opt.cursorline = true																								-- Enable highlighting of the current line
vim.opt.scrolloff=8
vim.opt.winminheight = 0
vim.opt.winminwidth = 0
vim.opt.backspace="indent,eol,start"																		-- Allow backspace to traverse these characters
vim.opt.showtabline=2																										-- Always show tabs
vim.opt.backup = false																									-- This is recommended by coc
vim.opt.writebackup = false																							-- This is recommended by coc
vim.opt.shortmess = vim.opt.shortmess + "c"															-- Don't pass messages to |ins-completion-menu|.
vim.opt.signcolumn="yes:2"																							-- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.updatetime=100																									-- Faster completion
-- set timeoutlen=100																										-- By default timeoutlen is 1000 ms
vim.opt.hidden = true																										-- suppresses buffer warnings when switching buffers
vim.opt.switchbuf="usetab"
vim.opt.wrap = true																											-- Display long lines as just one line
vim.opt.linebreak = true
vim.opt.breakat=" ^I!@;:,./?([{"
vim.opt.breakindent = true
vim.opt.breakindentopt="shift:16"
vim.opt.showmode = false
vim.opt.pumheight=20																										-- Makes popup menu smaller
vim.opt.encoding="utf-8"																								-- The encoding displayed
vim.opt.fileencoding="utf-8"																							-- The encoding written to file
vim.opt.fileformat="unix"
vim.opt.nrformats="alpha,hex,bin"

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
	pattern = "*",
	callback = function ()
		vim.opt.formatoptions:remove('a') -- Auto formatting is BAD.
		vim.opt.formatoptions:remove('t') -- Don't auto format my code. I got linters for that.
		vim.opt.formatoptions:append('c') -- In general, I like it when comments respect textwidth
		vim.opt.formatoptions:append('q') -- Allow formatting comments w/ gq
		vim.opt.formatoptions:remove('o') -- O and o, don't continue comments
		vim.opt.formatoptions:append('r') -- But do continue when pressing enter.
		vim.opt.formatoptions:append('n') -- Indent past the formatlistpat, not underneath it.
		vim.opt.formatoptions:append('j') -- Auto-remove comments if possible.
		vim.opt.formatoptions:remove('2')
	end
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2

--[[ local numberToggle = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({"BufEnter","FocusGained","InsertLeave","WinEnter"},{
	group = numberToggle,
	callback = function ()
		if vim.opt.number then
			vim.opt.relativenumber = true
		end
	end
})
vim.api.nvim_create_autocmd({"BufLeave","FocusLost","InsertEnter","WinLeave"},{
	group = numberToggle,
	callback = function ()
		if vim.opt.number then
			vim.opt.relativenumber = false
		end
	end
}) ]]

local function QuickFixDo(cmd)
	local bufs = {}
	local commands = vim.split(cmd, " ")
	local qflist = vim.call('getqflist')
	for _, value in pairs(qflist) do
		for k, v in pairs(value) do
			if k == "bufnr" then
				bufs[v] = vim.call('bufname', v)
			end
		end
	end
	for _, v in pairs(bufs) do
		vim.cmd({cmd = 'buffer', args = { v }})
		for _, value in pairs(commands) do
			vim.cmd(value)
		end
		vim.cmd('update')
	end
end
vim.api.nvim_create_user_command(
	"Qfixdo",
	function (opts)
		QuickFixDo(opts.args)
	end,
	{ nargs = 1 }
)

vim.cmd[[
augroup MakeAutocmd
autocmd!
autocmd MakeAutocmd QuickFixCmdPost lmake call setloclist(
\ winnr(),
\ filter(getloclist(winnr()),
\ "v:val['valid']"), 'r'
\ )
augroup END
]]
--[[ " set all options passed for all open windows in all tabs as well :3
function! s:set_all(option, val, ...) abort
	let val = eval(a:val)

	for t in range(1, tabpagenr('$'))
		for w in range(1, tabpagewinnr(t, '$'))
			if gettabwinvar(t, w, '&buftype') !=# ''
				continue
			endif
			call settabwinvar(t, w, '&'.a:option, val)
		endfor
	endfor
endfunction

command! -complete=option -nargs=+ SetAll call s:set_all(<f-args>) ]]

-- Indentation {
local indentWidth = 2
vim.opt.tabstop=indentWidth
-- vim.opt.softtabstop=indentWidth								-- Insert 4 spaces for a tab
vim.opt.shiftwidth=indentWidth 								-- Change the number of space characters inserted for indentation
vim.opt.smarttab = true        								-- Makes tabbing smarter will realize you have 2 vs 4
vim.opt.expandtab = false      								-- Converts tabs to spaces
vim.opt.smartindent = false     								-- Makes indenting smart
vim.opt.autoindent = false      								-- Good auto indent
-- } Indentation

-- searching {
vim.opt.ignorecase = true											-- Searches aren't case sensitive if lowercase
vim.opt.smartcase = true 											-- Overrides 'ignorecase' if search contains uppsercase chars
vim.opt.incsearch = true 											-- Highlights search matches AS it is typed
vim.opt.hlsearch = true  											-- Maintains search highlights of previous search
vim.api.nvim_set_keymap('n', '<esc>', "<cmd>noh<cr><esc>", {noremap = true, silent = true})
-- } searching

local winFocusGroup = vim.api.nvim_create_augroup("WindowFocusSets", { clear = true })
vim.api.nvim_create_autocmd({"VimEnter", "WinEnter", "BufWinEnter"},{
	callback = function() vim.opt_local.cursorline = true end, group = winFocusGroup
})
vim.api.nvim_create_autocmd("WinLeave",{
	callback = function() vim.opt_local.cursorline = false end, group = winFocusGroup
})

-- " set path+=**
-- set wildmenu
-- " Don't offer to open certain...
-- " ...directories
-- set wildignore+=*\\bin\\*,*\\tmp\\*,*\\build\\*,*\\.git\\*,*\\.github\\*,*\\.vs\\*,*\\Library\\*,*\\Logs\\*,*\\obj\\*,*\\Packages\\*,*\\node_modules\\*,*\\ProjectSettings\\*,

-- set wildignore+=*.swp,*.zip,*.exe,*.mid,*.jar,*.class,*.mm,*.o,*.obj
-- set wildignore+=*.csproj,*.sln,*.cache,*.asset,*.prefs,*.dwlt,*.db,*.catalog,*.graph,*.meta
-- " ...images
-- set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
-- " ...docs
-- set wildignore+=*.pdf

-- set wildmode=full

-- " save undo trees in files
-- set undofile
-- set undolevels=10000
