local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
	return
end

local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cookm",
		fmt(
			[[
			>> [duplicate]: ref

			---
			title: {}
			source: {}
			servings: {}
			description: {}
			image: {}
			time.prep: {}
			time.cook: {}
			time: {}
			difficulty: {}
			category: {}
			diet: {}
			tags: {}
			---

			{}
		]],
			{
				i(1),
				i(2),
				i(3),
				i(4),
				i(5),
				i(6),
				i(7),
				i(8),
				i(9),
				i(10),
				i(11),
				i(12),
				i(0),
			}
		)
	),
}
