local icons = require("faith.icons")
return {
	function()
		local search = vim.fn.searchcount({ maxcount = 0 })
		if next(search) ~= nil then
			if search.current > 0 and vim.v.hlsearch ~= 0 then
				return search.current .. "/" .. search.total
			end
		end
	end,
	icon = { icons.ui.FileSearch, color = "BarDiagWarn" },
	padding = { left = 0, right = 0 },
	separator = "",
	cond = function()
		return vim.v.hlsearch ~= 0
	end,
}
