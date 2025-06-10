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
		lazy = false,
		dependencies = {
			{
				"tiagovla/scope.nvim",
				lazy = false,
				init = function()
					vim.keymap.set(
						"n",
						"<leader>ttm",
						function()
							vim.api.nvim_cmd({
								cmd = "ScopeMoveBuf",
								args = vim.v.count ~= 0 and {
									vim.v.count,
								} or {},
							}, {})
						end,
						{ desc = "{n}[t]ab [m]ove buffer: move buffer to tab." }
					)
				end,
				config = true,
			},
		},
		config = function()
			require("resession").setup({
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
					tabnames = {},
				},
			})

			local function get_session_name()
				local name = vim.fn.getcwd()
				local branch =
					vim.trim(vim.fn.system("git branch --show-current"))
				if vim.v.shell_error == 0 then
					return name .. branch
				else
					return name
				end
			end
			-- Only load the session if nvim was started with no args
			if vim.fn.argc(-1) == 0 then
				require("resession").load(get_session_name(), {
					dir = "sessions/auto/",
					silence_errors = true,
				})
			end

			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					require("resession").save(get_session_name(), {
						dir = "sessions/auto/",
						notify = false,
					})
				end,
			})

			vim.keymap.set("n", "<leader>ss", function()
				require("resession").save()
			end, {
				desc = "[s]ession [s]tart: start recording session to a centralized location.",
			})
			vim.keymap.set("n", "<leader>sl", function()
				require("resession").load()
			end, { desc = "[s]ession [l]oad: load session." })
			vim.keymap.set("n", "<leader>sd", function()
				require("resession").delete()
			end, { desc = "[s]ession [d]elete: delete session." })
		end,
	},
	{
		"tpope/vim-obsession",
		enabled = false,
		init = function()
			vim.opt.sessionoptions =
				"blank,buffers,curdir,folds,help,tabpages,globals,winsize"
		end,
		config = function()
			vim.keymap.set({ "n" }, "<leader>ss", function()
				local root = vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
				vim.cmd("Obsess " .. session_dir .. root .. ".vim")
			end, {
				desc = "[s]ession [s]tart: start recording session to a centralized location.",
			})

			vim.keymap.set({ "n" }, "<leader>sd", function()
				vim.cmd([[Obsess!]])
			end, { desc = "[s]ession [d]elete: delete session." })

			vim.keymap.set({ "n" }, "<leader>sl", function()
				local root = vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t")
				local session_exists = vim.fn.empty(
					vim.fn.glob(session_dir .. root .. ".vim")
				) == 0
				local session_loaded = vim.fn.empty(vim.g.this_obsession) == 0
				if session_exists then
					if not session_loaded then
						vim.cmd("source " .. session_dir .. root .. ".vim")
					else
						vim.notify(
							"Session already active.",
							vim.log.levels.INFO,
							notify_opts
						)
					end
				else
					vim.notify(
						'Session for "' .. root .. '" does not exist.',
						vim.log.levels.INFO,
						notify_opts
					)
				end
			end, { desc = "[s]ession [l]oad: load session." })
		end,
	},
}
