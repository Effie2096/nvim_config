" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" set foldlevel=99
" set foldlevelstart=99
" set foldcolumn=1
" set fillchars+=foldopen:,foldsep:│,foldclose:
" set fillchars+=foldopen:,foldsep:│,foldclose:
" set fillchars+=foldopen:,foldsep:\ ,foldclose:

" lua << EOF
" vim.treesitter.set_query("java", "folds", [[
" 	(class_declaration)
" 	(interface_declaration)
" 	(constructor_declaration)
" 	(method_declaration)
" ]])
" EOF
" lua << EOF
" vim.treesitter.set_query("java", "folds", [[
" 	(class_declaration (block) @fold)
" 	(interface_declaration (block) @fold)
" 	(constructor_declaration (block) @fold)
" 	(method_declaration (block) @fold)
" ]])
" EOF

" set foldtext=FoldText()
" function! FoldText()
" 	let l:lpadding = strlen(&fdc)
" 	redir => l:signs
" 	execute 'silent sign place buffer='.bufnr('%')
" 	redir End
" 	let l:lpadding += strlen(l:signs =~ 'id=' ? 2 : 0)

" 	if exists("+relativenumber")
" 		if (&number)
" 			let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
" 		elseif (&relativenumber)
" 			let l:lpadding += max([&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]) + 1
" 		endif
" 	else
" 		if (&number)
" 			let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
" 		endif
" 	endif

" 	" expand tabs
" 	let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
" 	let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

" 	let l:info = ' (' . (v:foldend - v:foldstart) . ' lines) '
" 	let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
" 	let l:width = winwidth(0) - l:lpadding - l:infolen

" 	let l:separator = ' ⋅⋅⋅ '
" 	let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
" 	let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
" 	let l:text = l:start
" 	let l:text .= l:separator
" 	let l:text .= l:end

" 	return l:text . ' ' . repeat('━', l:width - strlen(substitute(l:text, ".", "x", "g")) - 4) . l:info . ' '
" endfunction
