local has_fidget, fidget = pcall(require, "fidget")
if not has_fidget then
	return
end

fidget.setup({
	notification = {
		window = {
			winblend = 0, -- needs 0 for catppuccin integration
		},
	},
	integration = {
		["nvim-tree"] = {
			enable = true,
		},
	},
})
