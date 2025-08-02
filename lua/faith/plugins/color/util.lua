local M = {}

M.clamp = function(val, min, max)
	return math.min(max, math.max(min, val))
end

-- round float, implementation rounds 0.5 upwards.
M.round = function(val)
	return math.floor(val + 0.5)
end

return M
