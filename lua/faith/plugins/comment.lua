local has_ts_context_commentstring, ts_context_commentstring =
	pcall(require, "ts_context_commentstring")
if not has_ts_context_commentstring then
	return
end
local has_Comment, Comment = pcall(require, "Comment")
if not has_Comment then
	return
end

ts_context_commentstring.setup({
	kanata = { __default = ";; %s", __multiline = "#| %s |#" },
})

local tcc =
	require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()

Comment.setup({
	opleader = {
		line = "gc",
		block = "gb",
	},
	mappings = {
		basic = true,
		extra = true,
	},
	ignore = "^$",
	pre_hook = tcc,
})

vim.keymap.set(
	{ "n" },
	"g>",
	require("Comment.api").call("comment.linewise", "g@"),
	{ expr = true, desc = "Comment region linewise" }
)
vim.keymap.set(
	{ "n" },
	"g>c",
	require("Comment.api").call("comment.linewise.current", "g@$"),
	{ expr = true, desc = "Comment current line" }
)
vim.keymap.set(
	{ "n" },
	"g>b",
	require("Comment.api").call("comment.blockwise.current", "g@$"),
	{ expr = true, desc = "Comment current block" }
)

vim.keymap.set(
	{ "n" },
	"g<",
	require("Comment.api").call("uncomment.linewise", "g@"),
	{ expr = true, desc = "Uncomment region linewise" }
)
vim.keymap.set(
	{ "n" },
	"g<c",
	require("Comment.api").call("uncomment.linewise.current", "g@$"),
	{ expr = true, desc = "Uncomment current line" }
)
vim.keymap.set(
	{ "n" },
	"g<b",
	require("Comment.api").call("uncomment.blockwise.current", "g@$"),
	{ expr = true, desc = "Uncomment current block" }
)

local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

vim.keymap.set({ "x" }, "g>", function()
	vim.api.nvim_feedkeys(esc, "nx", false)
	require("Comment.api").locked("comment.linewise")(vim.fn.visualmode())
end, { desc = "Comment region linewise (visual)" })

vim.keymap.set({ "x" }, "g<", function()
	vim.api.nvim_feedkeys(esc, "nx", false)
	require("Comment.api").locked("uncomment.linewise")(vim.fn.visualmode())
end, { desc = "Uncomment region linewise (visual)" })
