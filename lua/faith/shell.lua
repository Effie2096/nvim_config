local powershell_options = {
	shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
	shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
	shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
	shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
	shellquote = "",
	shellxquote = "",
}

local nushell_options = {
	shell = "nu",
	shellcmdflag = "-c",
	shellredir = "",
	shellpipe = "",
	shellquote = "",
	shellxquote = "",
}

local is_windows = vim.fn.has("win32") == 1

local active_shell = function()
	if vim.fn.executable("nu") == 1 then
		return nushell_options
	end
end

for option, value in pairs(active_shell()) do
	vim.opt[option] = value
end
