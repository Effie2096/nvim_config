vim.cmd([[
function! VimNotify(msg, ...)
	" Compatible with vanilla vim, neovim 0.4.x, and 0.5.0+ (native)
	" Same spec as v:lua.vim.notify(msg, log, opts).
	let l:log_level = a:0 >= 1 ? a:000[0] : 'info'
	let l:opts = a:0 >= 2 ? a:000[1] : {}
	return luaeval("vim.notify(_A[1], _A[2], _A[3])", [a:msg, l:log_level, l:opts])
endfunction

" asyncrun autocmd events: notification callback when job finishes
augroup AsyncRunEvents
	autocmd!
	autocmd User AsyncRunStart	call OnAsyncRunJobStart()
	autocmd User AsyncRunStop	call OnAsyncRunJobFinished()
augroup END

let g:asyncrun_job_status = {}
function! OnAsyncRunJobStart() abort
	let l:jobid = 3000	 " asyncrun supports only ONE concurrent job
	let g:asyncrun_job_status[l:jobid] = {
		\ 'status': 'running',
		\ 'cmdline': g:asyncrun_info,
		\ }
endfunction

function! OnAsyncRunJobFinished() abort
	let l:jobid = 3000	 " asyncrun supports only ONE concurrent job
	let l:job = get(g:asyncrun_job_status, l:jobid, {})
	if l:job == {} | return | endif
	let l:job['status'] = g:asyncrun_status

	" Notifications.
	if l:job['status'] != "success"
		let l:failure_message = l:job['cmdline']
		let l:job_title = printf("AsyncRun")   " TODO: How to get the cmd or job info?
		call VimNotify('Job Failed: ' . l:failure_message, 'warn', {'title': l:job_title})

		" Automatically show quickfix window if the job has failed.
		" open the qf window at the bottom (regardless of overriden :Copen)
		call asyncrun#quickfix_toggle(9, v:true) | cbottom
	endif

	" Statusline integration
	" Remove the job from the statusline after 2 seconds
	if !exists('*timer_start')
		silent! unlet g:asyncrun_job_status[l:jobid]
	else
		call timer_start(2000, { -> execute(printf(
			  \"silent! unlet g:asyncrun_job_status[%d]", l:jobid)) })
	endif
endfunction
]])
