local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then
	Reloader = require
else
	Reloader = plenary_reload.reload_module
end

RELOAD = function(...)
	return Reloader(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end

P = function(v)
	print(vim.inspect(v))
	return v
end
function Eatchar(pat)
	local c = vim.fn.nr2char(vim.fn.getchar(0))
	return (c ~= pat) and "" or c
end
vim.api.nvim_exec2(
	[[cabbrev p lua P()<Left><C-R>=Eatchar('\s')<CR>]],
	{ output = false }
)
