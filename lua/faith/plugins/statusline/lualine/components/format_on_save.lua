local histr = require("faith.plugins.statusline.utils").histr

local get_formatters = function()
	if package.loaded.conform ~= nil then
		return vim.iter(require("conform").list_formatters())
			:filter(function(formatter)
				return formatter.available
			end)
			:totable()
	end
	return {}
end

return {
	function()
		local formatters = get_formatters()
		local names = vim.iter(formatters)
			:map(function(f)
				return f.name
			end)
			:join(", ")
		if #formatters > 1 then
			names = names:format("(%s)")
		end

		return (
			not (vim.g.disable_autoformat or vim.b.disable_autoformat)
			and #get_formatters() ~= 0
		)
				and string.format(
					"%s: %s",
					names,
					histr("On", "DiagnosticCheck", true)
				)
			or string.format(
				"%s: %s",
				names,
				histr("Off", "DiagnosticError", true)
			)
	end,
	padding = 1,
	cond = function()
		return #get_formatters() ~= 0
	end,
}
