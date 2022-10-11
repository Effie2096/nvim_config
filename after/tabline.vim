" let g:taboo_tabline = 0
" " let g:taboo_modified_tab_flag = "[+]"
" " let g:taboo_renamed_tab_format = " %N %l%m "
" " let g:taboo_tab_format = " %N %f%m "


" "
" set tabline=%!MyTabLine()  " custom tab pages line
" function! MyTabLine()
" 	let leftSep      = ''
" 	let rightSep     = ' '
" 	let modifiedFlag = ''
" 	let close = ''
" 	let s = ''
" 	let s = '%#WinBarWinNum# Tabs  %#WinBarWinNumEnd#%*  '
" 	" loop through each tab page
" 	let tabHL = ''
" 	let tabSepHL = ''
" 	let tabNumHL = ''
" 	let tabModHL = ''
" 	let tabCloseHL = ''
" 	for i in range(tabpagenr('$'))
" 		if i + 1 == tabpagenr()
" 			let tabNumHL   = '%#TabLineSel#'
" 			let tabModHL   = '%#TabModifiedSelected#'
" 			let tabHL      = '%#TabLineSel#'
" 			let tabSepHL   = '%#TabLineSelSep#'
" 			let tabCloseHL = '%#TabLineSelClose#'
" 		else
" 			let tabNumHL   = '%#TabLineNum#'
" 			let tabModHL   = '%#TabModified#'
" 			let tabHL      = '%#TabLine#'
" 			let tabSepHL   = '%#TabLineSep#'
" 			let tabCloseHL = '%#TabLineClose#'
" 		endif
" 		let s .= tabSepHL
" 		let s .= leftSep
" 		let s .= tabHL
" 		let s .= tabNumHL

" 		" let numMap = {
" 		" 			\ '0': '🯰',
" 		" 			\ '1': '🯱',
" 		" 			\ '2': '🯲',
" 		" 			\ '3': '🯳',
" 		" 			\ '4': '🯴',
" 		" 			\ '5': '🯵',
" 		" 			\ '6': '🯶',
" 		" 			\ '7': '🯷',
" 		" 			\ '8': '🯸',
" 		" 			\ '9': '🯹'
" 		" 			\}
" 		" set the tab page number (for mouse clicks)
" 		let s .= '%' . (i + 1) . 'T '

" 		" set page number string
" 		" for n in split(i + 1, '\zs')
" 		" 	let s .= numMap[n]
" 		" endfor

" 		let s .= i + 1 . ' '
" 		" let s .= ' '

" 		let n = ''  " temp str for buf names
" 		let m = 0   " &modified counter
" 		" get buffer names and statuses
" 		let buflist = tabpagebuflist(i + 1)
" 		" loop through each buffer in a tab
" 		for b in buflist
" 			let buf = getbufvar(b, "&buftype")
" 			if buf == 'nofile'
" 				continue
" 			elseif buf == 'prompt'
" 				continue
" 			elseif buf == 'help'
" 				let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//') . ', '
" 			elseif buf == 'quickfix'
" 				let n .= '[Q]'
" 			elseif getbufvar(b, "&modifiable")
" 				let n .= fnamemodify(bufname(b), ':t') . ', ' " pathshorten(bufname(b))
" 			endif
" 			if getbufvar(b, "&modified")
" 				let m += 1
" 			endif
" 		endfor
" 		" let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
" 		let n = substitute(n, ', $', '', '')
" 		" add modified label
" 		if m > 0
" 			let s .= tabModHL
" 			let s .= modifiedFlag
" 			let s .= ' '
" 			let s .= tabHL
" 			" let s .= '[' . m . '+]'
" 		endif

" 		let tabooName = TabooTabName(i + 1)
" 		if tabooName != ""
" 			let s .= tabooName
" 			" let s .= ' '
" 			" let s .= ' ¦ '
" 		else
" 			" add buffer names
" 			if n == ''
" 				let s.= '[New]'
" 			else
" 				let s .= n
" 			endif
" 		endif

" 		let s .= tabHL
" 		" switch to no underlining and add final space
" 		" let s .= ' '
" 		" let s .= tabCloseHL
" 		" let s .= '%999X' . close
" 		" let s .= tabHL
" 		let s .= ' '
" 		let s .= tabSepHL
" 		let s .= ' '
" 	endfor
" 	" let s .= '%#TabLineFill#%T'



" 	"right-aligned close button
" 	" if tabpagenr('$') > 1
" 	" 	let s .= '%=%#TabLineFill#%999X '
" 	" endif
" 	return s
" endfunction
