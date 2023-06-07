if not vim.fn.exists("g:cmake_command") == 1 then
	return
end

vim.cmd([[let g:cmake_link_compile_commands = 1]])
