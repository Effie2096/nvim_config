vim.pack.add({
	{ src = "https://github.com/nvim-neotest/neotest" },
}, { load = function() end })

local config = function()
	local neotest = require("neotest")
	local opts = {
		consumers = {
			overseer = require("neotest.consumers.overseer"),
		},
		adapters = {},
	}
	neotest.setup(opts)
end
local load = function()
	if not package.loaded.neotest then
		vim.cmd.packadd("neotest")
		config()
	end
end

vim.api.nvim_create_user_command("Neotest", function(opts)
	load()
	vim.cmd.Neotest({ args = opts.fargs, bang = opts.bang })
end, {
	bang = true,
	nargs = "*",
})
local function test_map(modes, lhs, rhs, opts)
	vim.keymap.set(modes, lhs, function()
		load()

		rhs()
	end, opts)
end
test_map({ "n" }, "<leader>trr", function()
	require("neotest").run.run()
end, { desc = "[t]est nearest." })
test_map({ "n" }, "<leader>trf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "[T]est file." })
test_map({ "n" }, "<leader>tra", function()
	require("neotest").run.run({ suite = true })
end, { desc = "[t]est [a]ll" })
test_map({ "n" }, "<leader>trl", function()
	require("neotest").run.run_last()
end, { desc = "[t]est [l]ast." })
test_map({ "n" }, "<leader>trg", function()
	local last = require("neotest").run.get_last_run()
	if last == nil then
		vim.notify("No test ran yet")
		return
	end
	local filename = string.gsub(
		vim.fn.split(require("neotest").run.get_last_run(), "::")[1],
		'"',
		""
	)
	-- double check file hasn't been deleted since last run
	if vim.fn.filereadable(filename) > 0 then
		vim.cmd.drop(filename)
	end
end, { desc = "[t]est [g]o: Go to last file tests were ran." })
test_map({ "n" }, "<leader>to", function()
	-- require("neotest").output_panel.toggle()
	require("overseer").toggle({
		enter = false,
		direction = "bottom",
	})
	require("neotest").summary.toggle()
end, { desc = "[t]est [o]utput: " })
