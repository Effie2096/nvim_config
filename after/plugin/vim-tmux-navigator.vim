if exists("g:loaded_tmux_navigator") && !(has("win32"))
	" Disable tmux navigator when zooming the Vim pane
	let g:tmux_navigator_disable_when_zoomed = 0

	let g:tmux_navigator_no_mappings = 1

	noremap <silent> <M-h> :<C-U>TmuxNavigateLeft<cr>
	noremap <silent> <M-j> :<C-U>TmuxNavigateDown<cr>
	noremap <silent> <M-k> :<C-U>TmuxNavigateUp<cr>
	noremap <silent> <M-l> :<C-U>TmuxNavigateRight<cr>
	noremap <silent> <M-\> :<C-U>TmuxNavigatePrevious<cr>
endif
