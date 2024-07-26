local ls = require("luasnip")
if not pcall(require, "luasnip") then
	return
end

local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"abstract",
		fmt(
			[[
			> [!ABSTRACT]
			> {}
			{}
			]],
			{ i(1), i(0) }
		)
	),
	s(
		"todo",
		fmt(
			[[
			> [!TODO]
			> {}
			{}
			]],
			{ i(1), i(0) }
		)
	),
	s(
		"success",
		fmt(
			[[
			> [!SUCCESS]
			> {}
			{}
			]],
			{ i(1), i(0) }
		)
	),
	s(
		"question",
		fmt(
			[[
			> [!QUESTION]
			> {}
			{}
			]],
			{ i(1), i(0) }
		)
	),
	s(
		"failure",
		fmt(
			[[
			> [!FAILURE]
			> {}
			{}
			]],
			{ i(1), i(0) }
		)
	),
	s(
		"danger",
		fmt(
			[[
			> [!DANGER]
			> {}
			{}
			]],
			{ i(1), i(0) }
		)
	),
	s(
		"bug",
		fmt(
			[[
			> [!BUG]
			> {}
			{}
			]],
			{ i(1), i(0) }
		)
	),
	s(
		"example",
		fmt(
			[[
			> [!EXAMPLE]
			> {}
			{}
			]],
			{ i(1), i(0) }
		)
	),
	s(
		"quote",
		fmt(
			[[
			> [!QUOTE]
			> *{}*
			{}
			]],
			{ i(1), i(0) }
		)
	),
}
