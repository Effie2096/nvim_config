local has_coverage, coverage = pcall(require, "coverage")
if not has_coverage then
	return
end

local colors = require("catppuccin.palettes").get_palette()

coverage.setup({
	highlights = {
		covered = { fg = colors.green },
		partial = { fg = colors.yellow },
		uncovered = { fg = colors.red },
	},
	signs = {
		covered = { hl = "CoverageCovered", text = "█" },
		partial = { hl = "CoveragePartial", text = "█" },
		uncovered = { hl = "CoverageUncovered", text = "█" },
	},
	lang = {
		rust = {
			coverage_file = "lcov.info",
		},
	},
})
