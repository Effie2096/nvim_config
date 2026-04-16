local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
	return
end

local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local c = ls.choice_node

-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local rep = require("luasnip.extras").rep

---@param name string context that triggers snippet
---@param format string lua date format string
---@param nodes? LuaSnip.Node[] | nil extra nodes
---@return LuaSnip.Snippet
local make_date = function(name, format, nodes)
	nodes = nodes or {}
	table.insert(
		nodes,
		1,
		f(function()
			return os.date(format)
		end)
	)
	table.insert(nodes, i(0))
	return s(name, nodes)
end

-- TODO: calculate BST based on date ig lol <20-05-25>
return {
	make_date(
		"timestamp",
		"%Y-%m-%dT%H:%M:%S.000",
		{ c(1, { t("+00:00"), t("Z") }) }
	),
	make_date("rfc822", "%a, %d %b %Y %H:%M:%S", { t(" +0000") }),
	make_date("date", "%Y-%m-%d"),
	make_date("now", "%H:%M:%S"),
}
