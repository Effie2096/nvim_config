local icons = require("faith.icons")
local progress_bar = require("faith.statusline.ui.progress_bar")
local histr = require("faith.statusline.utils").histr

local M = {}

local LEVEL_FACTOR = 0.025

local calculate_level = function(xp)
	return math.floor(LEVEL_FACTOR * math.sqrt(xp))
end

local xp_for_level = function(level)
	return (level / LEVEL_FACTOR) ^ 2
end

local display_raw = function(level, current, total, percent)
	return ("level %s %s/%s %.1f%%"):format(
		level,
		current, total,
		percent
	)
end
local display_status = function(level, current, total, percent)
	return ("%s %s %.1f%%%%"):format(

		histr(level .. icons.ui.Star, "CodeStatsIcon"),
		progress_bar(current, total, 15),
		percent
	)
end

M.total_xp = function(raw)
	if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "" then
		return ""
	end
	raw = raw or false

	local xp =  require("codestats").get_xp()
	if xp and (xp ~= "0" or nil) then
		local level = calculate_level(xp)
		local xp_this_level = xp_for_level(level)
		local xp_next_level = xp_for_level(level + 1)

		local current = xp - xp_this_level
		local total = xp_next_level - xp_this_level
		local percent = current / total * 100

		if raw then
			return display_raw(level, current, total, percent)
		end

		return display_status(level, current, total, percent)
	end
end

M.buf_xp = function(raw)
	if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "" then
		return ""
	end

	raw = raw or false
	local xp = require("codestats").get_xp(0)

	if xp and (xp ~= "0" or nil) then
		local level = calculate_level(xp)
		local xp_this_level = xp_for_level(level)
		local xp_next_level = xp_for_level(level + 1)

		local current = xp - xp_this_level
		local total = xp_next_level - xp_this_level
		local percent = current / total * 100

		if raw then
			return display_raw(level, current, total, percent)
		end

		return display_status(level, current, total, percent)
	end
end

return M
