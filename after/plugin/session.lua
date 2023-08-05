vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize"

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local desc = fk.desc

local session_dir = vim.fn.stdpath("data") .. "/sessions/"

local notify_opts = { title = "Session" }

-- if sessions dir doesn't exist, create it
if vim.fn.isdirectory(session_dir) == 0 then
	local ok, err = pcall(vim.fn.mkdir, session_dir, "p")

	if ok then
		vim.notify("Session dir initialized at " .. session_dir, vim.log.levels.INFO, notify_opts)
	else
		vim.notify("Failed to initialize session dir.\nReason:\n" .. err, vim.log.levels.ERROR, notify_opts)
	end
end

local opts = { noremap = true, silent = true }
nnoremap("<leader>ss", function()
	local root = vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
	vim.cmd("Obsess " .. session_dir .. root .. ".vim")
end, desc(opts, "[s]ession [s]tart: start recording session to a centralized location."))

nnoremap("<leader>sd", function()
	vim.cmd([[Obsess!]])
end, desc(opts, "[s]ession [d]elete: delete session."))

nnoremap("<leader>sl", function()
	local root = vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
	local session_exists = vim.fn.empty(vim.fn.glob(session_dir .. root .. ".vim")) == 0
	local session_loaded = vim.fn.empty(vim.g.this_obsession) == 0
	if session_exists then
		if not session_loaded then
			vim.cmd("source " .. session_dir .. root .. ".vim")
		else
			vim.notify("Session already active.", vim.log.levels.INFO, notify_opts)
		end
	else
		vim.notify('Session for "' .. root .. '" does not exist.', vim.log.levels.INFO, notify_opts)
	end
end, desc(opts, "[s]ession [l]oad: load session."))
