local icons = require("faith.icons")
local progress_bar = require("faith.plugins.statusline.ui.progress_bar")
local histr = require("faith.plugins.statusline.utils").histr

local winbar_ignore = require(
	"faith.plugins.statusline.lualine.components.winbar"
).ignore.winbar_ignore

local M = {}

local LEVEL_FACTOR = 0.025

local calculate_level = function(xp)
	return math.floor(LEVEL_FACTOR * math.sqrt(xp))
end

local xp_for_level = function(level)
	return (level / LEVEL_FACTOR) ^ 2
end

M.total_xp = {
	function()
		return require("codestats").get_xp()
	end,
	fmt = function(s)
		if s and (s ~= "0" or nil) then
			local level = calculate_level(s)
			local xp_this_level = xp_for_level(level)
			local xp_next_level = xp_for_level(level + 1)

			local current = s - xp_this_level
			local total = xp_next_level - xp_this_level
			local percent = current / total

			return string.format(
				"%s %s %.1f%%%%",
				histr(level .. icons.ui.Star, "CodeStatsIcon"),
				progress_bar(current, total, 15),
				percent * 100
			)
		end
	end,
}

M.buf_xp = {
	function()
		return require("codestats").get_xp(0)
	end,
	color = "WinBar",
	padding = { left = 0, right = 1 },
	fmt = function(s)
		if s and (s ~= "0" or nil) then
			local level = calculate_level(s)
			local xp_this_level = xp_for_level(level)
			local xp_next_level = xp_for_level(level + 1)

			local current = s - xp_this_level
			local total = xp_next_level - xp_this_level
			local percent = current / total

			return string.format(
				"%s %s",
				histr(level .. icons.ui.Star, "CodeStatsIcon"),
				progress_bar(current, total, 7, string.format("%.1f%%", percent * 100))
			)
		end
	end,
	cond = function()
		return winbar_ignore() and vim.o.filetype ~= ""
	end,
}

return M
