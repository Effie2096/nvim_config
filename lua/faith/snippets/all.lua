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

local timestamp = function()
	return os.date("%Y-%m-%dT%H:%M:%S.000")
end

local rfc = function()
	return os.date("%a, %d %b %Y %H:%M:%S")
end

-- TODO: calculate BST based on date ig lol <20-05-25>
return {
	s("timestamp", {
		f(timestamp, {}),
		c(1, { t("+01:00"), t("Z") }),
		i(0),
	}),
	s("rfc822", {
		f(rfc, {}),
		c(1, { t(" +0100"), t(" GMT") }),
		i(0),
	}),
}
