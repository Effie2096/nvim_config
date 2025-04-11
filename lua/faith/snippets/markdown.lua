local ls = require("luasnip")
if not pcall(require, "luasnip") then
	return
end

local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local callouts = {
	note = { raw = "[!NOTE]" },
	tip = { raw = "[!TIP]" },
	important = { raw = "[!IMPORTANT]" },
	warning = { raw = "[!WARNING]" },
	caution = { raw = "[!CAUTION]" },
	-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
	abstract = { raw = "[!ABSTRACT]" },
	summary = { raw = "[!SUMMARY]" },
	tldr = { raw = "[!TLDR]" },
	info = { raw = "[!INFO]" },
	todo = { raw = "[!TODO]" },
	hint = { raw = "[!HINT]" },
	success = { raw = "[!SUCCESS]" },
	check = { raw = "[!CHECK]" },
	done = { raw = "[!DONE]" },
	question = { raw = "[!QUESTION]" },
	help = { raw = "[!HELP]" },
	faq = { raw = "[!FAQ]" },
	attention = { raw = "[!ATTENTION]" },
	failure = { raw = "[!FAILURE]" },
	fail = { raw = "[!FAIL]" },
	missing = { raw = "[!MISSING]" },
	danger = { raw = "[!DANGER]" },
	error = { raw = "[!ERROR]" },
	bug = { raw = "[!BUG]" },
	example = { raw = "[!EXAMPLE]" },
	quote = { raw = "[!QUOTE]" },
	cite = { raw = "[!CITE]" },
}

local function make_snippet(name, raw)
	return s(
		name,
		fmt(
			string.format(
				[[
			> %s
			> {}
			{}
			]],
				raw
			),
			{ i(1), i(0) }
		)
	)
end

local snippets = function()
	local list = {}
	for k, v in pairs(callouts) do
		table.insert(list, make_snippet(k, v.raw))
	end
	return list
end

local snips = snippets()

return snips
