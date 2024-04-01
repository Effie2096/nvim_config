local has_twilight, twilight = pcall(require, "twilight")
if not has_twilight then
	return
end

twilight.setup({
	dimming = {
		alpha = 0.25,
	},
	context = 10,
	treesitter = true,
	expand = {
		"function",
		"method",
		"table",
		"if_statement",
	},
})
