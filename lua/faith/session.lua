vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,globals"

local status_sess_ok, sessions = pcall(require, "sessions")
if not status_sess_ok then
	return
end

local session_path = vim.fn.stdpath("data") .. "/sessions"
sessions.setup({
	events = { "VimLeavePre" },
	session_filepath = vim.fn.glob(session_path .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"))
})

local status_work_ok, workspaces = pcall(require, "workspaces")
if not status_work_ok then
	return
end

local workspace_path = vim.fn.stdpath("data") .. "/workspaces"
workspaces.setup({
	path = vim.fn.glob(workspace_path),
	hooks = {
		open_pre = {
			"SessionsStop",
			"silent%bdelete!",
		},
		open = {
			function()
				sessions.load(vim.fn.glob(session_path .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")), { silent = true })
			end,
		}
	}
})
