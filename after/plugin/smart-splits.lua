local has_smart_splits, smart_splits = pcall(require, "smart-splits")
if not has_smart_splits then
	return
end

-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set("n", "<S-Left>", require("smart-splits").resize_left)
vim.keymap.set("n", "<S-Down>", require("smart-splits").resize_down)
vim.keymap.set("n", "<S-Up>", require("smart-splits").resize_up)
vim.keymap.set("n", "<S-Right>", require("smart-splits").resize_right)
-- moving between splits
vim.keymap.set("n", "<M-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<M-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<M-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<M-l>", require("smart-splits").move_cursor_right)
