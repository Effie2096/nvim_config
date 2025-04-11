local has_outline, outline = pcall(require, "outline")
if not has_outline then
	return
end

outline.setup({
	relative_width = false,
	keymaps = {
		up_and_jump = "<C-p>",
		down_and_jump = "<C-n>",
	},
})
