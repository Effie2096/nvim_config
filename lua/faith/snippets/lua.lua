local ls = require("luasnip")
if not pcall(require, "luasnip") then
	return
end

local s = ls.s
local i = ls.insert_node
-- local t = ls.text_node
-- local c = ls.choice_node
local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt

-- local rep = require("luasnip.extras").rep

local same = function(index)
	return f(function(import_name)
		local parts = vim.split(import_name[1][1], ".", { plain = true })
		return string.gsub(parts[#parts], "-", "_") or ""
	end, { index })
end

return {
	s(
		"req",
		fmt([[local {} = require("{}")]], {
			same(1),
			i(1),
		})
	),
	s(
		"preq",
		fmt(
			[[
			local has_{}, {} = pcall(require, "{}")
			if not has_{} then
				return
			end{}
			]],
			{
				same(1),
				same(1),
				i(1),
				same(1),
				i(0),
			}
		)
	),
}
