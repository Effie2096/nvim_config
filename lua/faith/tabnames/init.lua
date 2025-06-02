local tabnames_group = vim.api.nvim_create_augroup("tabnames", { clear = true })

vim.keymap.set("n", "<leader>ttn", function()
	require("faith.tabnames.tabnames").new_tab()
end, { desc = "[t]ab [n]ew: create new tab." })
vim.keymap.set("n", "<leader>ttr", function()
	require("faith.tabnames.tabnames").rename_tab()
end, { desc = "[t]ab [r]ename: rename current tab." })

vim.api.nvim_create_autocmd(
	{ "WinLeave", "WinEnter", "BufCreate", "BufLeave", "BufEnter" },
	{
		group = tabnames_group,
		callback = function()
			local tabnr = vim.fn.tabpagenr()
			local tabname = vim.fn.gettabvar(tabnr, "tabname")

			if tabname ~= "" then
				vim.fn.settabvar(tabnr, "tabname", tabname)
			end
		end,
	}
)
vim.api.nvim_create_autocmd({ "TabLeave", "TabEnter", "TabClosed" }, {
	group = tabnames_group,
	callback = function()
		require("faith.tabnames.tabnames").refresh_tabnames()
	end,
})

vim.api.nvim_create_user_command("TabRename", function(args)
	require("faith.tabnames.tabnames").rename_tab(args.fargs[1])
end, { nargs = "?", desc = "Rename the current tab" })

vim.api.nvim_create_user_command("TabOpen", function(args)
	require("faith.tabnames.tabnames").new_tab(args.fargs[1])
end, { nargs = "?", desc = "Open and name a new tab" })

vim.api.nvim_create_user_command(
	"TabReset",
	require("faith.tabnames.tabnames").clear_name,
	{ desc = "Remove custom tab name" }
)
