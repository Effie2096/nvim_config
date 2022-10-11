vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,globals"

--[[ Exclude = {
	"TelescopePrompt",
	"help",
	"terminal",
	"notify",
	""
}

local function make_view()
	for _, value in pairs(Exclude) do
		if vim.bo.filetype == value then
			return
		end
	end
	vim.cmd("mkview")
end ]]

--[[ local group = vim.api.nvim_create_augroup("auto_views", { clear = true})
vim.api.nvim_create_autocmd({"BufWritePost"}, {
	pattern = "*",
	group = group,
	callback = function()
		make_view()
	end
})
vim.api.nvim_create_autocmd({"BufReadPost"}, {
	pattern = "*",
	group = group,
	command = ":silent! loadview"
}) ]]

local status_sess_ok, sessions = pcall(require, "sessions")
if not status_sess_ok then
	return
end

local session_path = vim.fn.stdpath("data") .. "/sessions"
sessions.setup({
	events = { "VimLeavePre" },
	session_filepath = session_path .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
})

local status_work_ok, workspaces = pcall(require, "workspaces")
if not status_work_ok then
	return
end

local workspace_path = vim.fn.stdpath("data") .. "/workspaces"
workspaces.setup({
	path = workspace_path,
	hooks = {
		add = {
			-- auto make a session named after cwd when creating a new workspace
			vim.cmd('SessionsSave')
		},
		open_pre = {
			"SessionsStop",
			"silent%bdelete!",
		},
		open = {
			function()
				sessions.load(session_path .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"), { silent = true })
			end,
		}
	}
})
