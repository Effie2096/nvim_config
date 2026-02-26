vim.opt.spellfile =
	vim.fn.glob(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", true, false)
for d in pairs(vim.fn.glob("~/.vim/spell/*.add", true, true)) do
	if
		vim.fn.filereadable(d)
		and (
			not vim.fn.filereadable(d .. ".spl")
			or vim.fn.getftime(d) > vim.fn.getftime(d .. ".spl")
		)
	then
		vim.exec("mkspell! " .. vim.fn.fnameescape(d))
	end
end
