local icons = require("faith.icons")

local M = {}

--- Wrap text in statusline highlight
---@param str string --Display text
---@param highlight string --Highlight group
---@param close? boolean --Whether to close highlight after text
M.histr = function(str, highlight, close)
	str = str or ""
	highlight = highlight or ""
	close = close or true

	return string.format(
		"%s%s%s%s%s",
		"%#",
		highlight,
		"#",
		str,
		close and "%*" or ""
	)
end

M.format_bubble = function(str)
	return string.format(
		"%s%s%s",
		M.histr(icons.separators.rounded.right, "AccentInverse"),
		M.histr(str, "Accent"),
		M.histr(icons.separators.rounded.left, "AccentInverse", true)
	)
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
M.trunc = function(
	str,
	trunc_width,
	trunc_len,
	hide_width,
	no_ellipsis,
	reverse
)
	local win_width = vim.fn.winwidth(0)
	if hide_width and win_width < hide_width then
		return ""
	elseif
		trunc_width
		and trunc_len
		and win_width < trunc_width
		and #str > trunc_len
	then
		if reverse then
			return str:sub(-trunc_len) .. (no_ellipsis and "" or "...")
		end
		return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
	end
	return str
end

M.is_loclist = function()
	return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

M.qf_label = function()
	return M.is_loclist() and "Location List" or "Quickfix List"
end

M.qf_title = function()
	if M.is_loclist() then
		return vim.fn.getloclist(0, { title = 0 }).title
	end
	return vim.fn.getqflist({ title = 0 }).title
end

return M
