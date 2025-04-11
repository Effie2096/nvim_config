local has_overseer, overseer = pcall(require, "overseer")
if not has_overseer then
	return
end

overseer.setup({
	templates = {
		"builtin",
		"faith",
	},
	-- strategy = {
	-- 	"toggleterm",
	-- },
})

local opts = { silent = true, noremap = true }
vim.keymap.set({ "n", "i" }, "<F3>", function()
	require("overseer").run_template({
		tags = {
			require("overseer").TAG.BUILD,
		},
	})
	require("overseer").open({ enter = false })
end, opts)
vim.keymap.set({ "n", "i" }, "<F4>", function()
	require("overseer").run_template({
		tags = {
			require("overseer").TAG.RUN,
		},
	})
	require("overseer").open({ enter = false })
end, opts)
