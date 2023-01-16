local ls = require("luasnip")
if not pcall(require, "luasnip") then
	return
end

local s = ls.s
local i = ls.insert_node
local t = ls.text_node
-- local c = ls.choice_node
-- local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt

local rep = require("luasnip.extras").rep

return {
	s("req", fmt("local {} = require('{}')", { i(1), rep(1) })),
	s(
		"preq",
		fmt("local {}, {} = pcall(require, '{}')\nif not {} then\n	return\nend{}", {
			i(1, "status_ok"),
			i(2, t("")),
			rep(2),
			rep(1),
			i(0),
		})
	),
}
