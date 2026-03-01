local posix_shell_options = {
	shellcmdflag = "-c",
	shellpipe = "2>&1 | tee",
	shellquote = "",
	shellredir = ">%s 2>&1",
	shelltemp = true,
	shellxescape = "",
	shellxquote = "",
}

local cmd_options = {
	shell = "cmd",
	shellcmdflag = "/s /c",
	shellpipe = "2>&1 | tee",
	shellquote = "",
	shellredir = ">%s 2>&1",
	shelltemp = true,
	shellxescape = "",
	shellxquote = '"',
}

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
	shellcmdflag = "--login --stdin --no-newline -c",
	shellredir = "out+err> %s",
	shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record",
	shelltemp = false,
	shellxescape = "",
	shellxquote = "",
	shellquote = "",
}

local is_windows = vim.fn.has("win32") == 1

local active_shell = function()
	if vim.fn.executable("nu") == 1 then
		return nushell_options
	end
	if is_windows then
		return powershell_options
	end
	return posix_shell_options
end

for option, value in pairs(active_shell()) do
	vim.opt[option] = value
end
