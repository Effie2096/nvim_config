local has_luasnip, ls = pcall(require, "luasnip")
if not has_luasnip then
	return
end

local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"meta",
		fmt(
			[[
[ti:{}]     # Title of the song
[ar:{}]     # Artist performing the song
[al:{}]     # Album the song is from
[au:{}]     # Author of the song
[lr:{}]     # Lyricist of the song
[length:{}] # Length of the song (mm:ss)
[by:{}]     # Author of the LRC file (not the song)
[offset:{}] # Specifies a global offset value for the lyric times, in milliseconds. The value is prefixed with either + or -, with + causing lyrics to appear sooner 

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
				i(0),
			}
		)
	),
	s(
		"ts",
		fmt("[{}:{}.{}]", {
			i(1, "00"),
			i(2, "00"),
			i(3, "00"),
		})
	),
}
