local has_fidget, fidget = pcall(require, "fidget")
if not has_fidget then
	return
end

fidget.setup({
	window = {
		blend = 0,
	},
	text = {
		spinner = "dots",
	},
})
