M = {}

local default_padding = 1

function M.highlight_str(str, highlight)
	return '%#' .. highlight .. '#' .. str .. '%*'
end

function M.apply_padding(string, padding)
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

return M
