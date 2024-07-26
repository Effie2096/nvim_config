local has_visual_whitespace, visual_whitespace = pcall(require, "visual-whitespace")
if not has_visual_whitespace then
	return
end

local icons = require("faith.icons").characters
visual_whitespace.setup({
	highlight = { link = "Visual" },
	space_char = icons.space,
	nl_char = icons.eol,
})
