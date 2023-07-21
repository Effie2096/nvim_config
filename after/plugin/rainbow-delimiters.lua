local has_rainbow_delimiters, rainbow_delimiters = pcall(require, "rainbow-delimiters")
if not has_rainbow_delimiters then
	return
end

vim.g.rainbow_delimiters = {
	strategy = {
		[""] = rainbow_delimiters.strategy["local"],
	},
	query = {
		[""] = "rainbow-delimiters",
		-- lua = "rainbow-blocks",
	},
	highlight = {
		"RainbowDelimiterRed",
		"RainbowDelimiterYellow",
		"RainbowDelimiterBlue",
		"RainbowDelimiterOrange",
		"RainbowDelimiterGreen",
		"RainbowDelimiterViolet",
		"RainbowDelimiterCyan",
	},
}
