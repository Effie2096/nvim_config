local session_dir = vim.fn.stdpath("data") .. "/sessions/"

local notify_opts = { title = "Session" }

-- if sessions dir doesn't exist, create it
if vim.fn.isdirectory(session_dir) == 0 then
	local ok, err = pcall(vim.fn.mkdir, session_dir, "p")

	if ok then
		vim.notify(
			"Session dir initialized at " .. session_dir,
			vim.log.levels.INFO,
			notify_opts
		)
	else
		vim.notify(
			"Failed to initialize session dir.\nReason:\n" .. err,
			vim.log.levels.ERROR,
			notify_opts
		)
	end
end

return {
	{
		"stevearc/resession.nvim",
		dependencies = {
			{
				"tiagovla/scope.nvim",
				init = function()
					vim.keymap.set("n", "<leader>ttm", function()
						vim.api.nvim_cmd({
							cmd = "ScopeMoveBuf",
							args = vim.v.count ~= 0 and {
								vim.v.count,
							} or {},
						}, {})
					end, { desc = "{n}[t]ab [m]ove buffer: move buffer to tab." })
				end,
				config = true,
			},
		},
		config = function()
			local resession = require("resession")
			resession.setup({
				dir = "sessions",
				options = {
					"binary",
					"bufhidden",
					"buflisted",
					"diff",
					"filetype",
					"modifiable",
					"previewwindow",
					"readonly",
					"scrollbind",
					"winfixheight",
					"winfixwidth",
				},
				buf_filter = function(bufnr)
					local buftype = vim.bo[bufnr].buftype
					local filetype = vim.bo[bufnr].filetype
					if buftype == "help" then
						return true
					end
					if buftype ~= "" and buftype ~= "acwrite" then
						return false
					end
					if filetype == "gitcommit" then
						return false
					end
					if vim.api.nvim_buf_get_name(bufnr) == "" then
						return false
					end
					return vim.bo[bufnr].buflisted
				end,
				extensions = {
					quickfix = {},
					overseer = {},
					scope = {},
					oil = {},
					tabnames = {},
				},
			})

			local function get_session_name()
				local name = vim.fn.getcwd()
				local branch = vim.trim(vim.fn.system("git branch --show-current"))
				if vim.v.shell_error == 0 then
					return ("%s__%s"):format(name, branch)
				else
					return name
				end
			end

			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					-- Only load the session if nvim was started with no args
					if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
						resession.load(get_session_name(), {
							dir = "sessions/auto/",
							silence_errors = true,
						})
					end
				end,
				nested = true, -- needed for plugins that add stuff on VimEnter not working
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					resession.save(get_session_name(), {
						dir = "sessions/auto/",
						notify = false,
					})
				end,
			})
			vim.api.nvim_create_autocmd("StdinReadPre", {
				callback = function()
					-- Store this for later
					vim.g.using_stdin = true
				end,
			})

			resession.add_hook("post_load", function()
				vim.cmd.doautoall("BufReadPost") -- fix first buffer on load not having anything set up correctly
			end)

			vim.keymap.set("n", "<leader>ss", function()
				resession.save()
			end, {
				desc = "[s]ession [s]tart: start recording session to a centralized location.",
			})
			vim.keymap.set("n", "<leader>sl", function()
				resession.load()
			end, { desc = "[s]ession [l]oad: load session." })
			vim.keymap.set("n", "<leader>sd", function()
				resession.delete()
			end, { desc = "[s]ession [d]elete: delete session." })
		end,
	},
}
