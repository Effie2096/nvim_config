M = {}

local default_padding = 1

M.highlight_str = function (str, highlight)
	return '%#' .. highlight .. '#' .. str .. '%*'
end

M.apply_padding = function (string, padding)
	local f = require('faith.functions')
	local l_padding, r_padding

	-- use default if padding not specified
	if f.isempty(padding) then
		padding = default_padding
	end

	-- check if padding is a number or a table
	if type(padding) == 'number' then
		l_padding, r_padding = padding, padding
	elseif type(padding) == 'table' then
		if f.exists("pad.left") then
			if type(padding.left) == 'number' then
				l_padding = padding.left
			end
		end
		if f.exists("pad.right") then
			if type(padding.right) == 'number' then
				r_padding = padding.right
			end
		end
	end

	-- don't pad empty elements
	if not f.isempty(string) then
		if l_padding then
			string = string.insert(string, string.rep(' ', l_padding), 0)
		end
		if r_padding then
			string = string.insert(string, string.rep(' ', r_padding), #string)
		end
	end

	return string
end

---Escape % in str so it doesn't get picked as stl item.
---@param str string
---@return string
function M.stl_escape(str)
  if type(str) ~= 'string' then
    return str
  end
	---@diagnostic disable-next-line: redundant-return-value
  return str:gsub('%%', '%%%%')
end

-- TODO: Add container which user can scroll when truncated <17-11-22, Effie2096>
--[[ M.create_section = function (segments, seperator, max_length)
	local section = table.concat(segments, seperator, 1, #segments)
	local section_length = fn.strdisplaywidth(section)

	if section_length > max_length then
		return "too long lol"
	end
	return section
end ]]

return M