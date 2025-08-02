local M = {}

-- local module_path = "faith.plugins.statusline.lualine.components."

local function get_color_codes(name)
	local hl = vim.api.nvim_get_hl(0, { name = name })
	local fg = string.format("#%06x", hl.fg and hl.fg or 0)
	local bg = string.format("#%06x", hl.bg and hl.bg or 0)
	return fg, bg
end

local function merge_colors(foreground, background)
	local new_name = foreground .. background
	local fg, _ = get_color_codes(foreground)
	local _, bg = get_color_codes(background)
	vim.api.nvim_set_hl(0, new_name, { fg = fg, bg = bg })
	return string.format("%%#%s#", new_name)
end

local function inverse_color(name)
	local fg, bg = get_color_codes(name)
	local new_name = name .. "_inversed"
	vim.api.nvim_set_hl(0, new_name, { fg = bg, bg = fg })
	return string.format("%%#%s#", new_name)
end

M.get_components = function()
	return vim.iter(
		vim.split(
			vim.fn.glob(
				vim.fn.stdpath("config")
					.. "/lua/faith/plugins/statusline/lualine/components/*.lua"
			),
			"\n"
		)
	)
		:filter(function(v)
			return v:find("init.lua", -8) == nil
		end)
		:map(function(v)
			return (
				v:gsub(vim.fn.stdpath("config") .. "/lua/", "")
					:gsub("%.lua", "")
			)
		end)
		:map(function(v)
			return {
				module = vim.fn.fnamemodify(v, ":t"),
				path = v:gsub("[\\\\/]", "%."),
			}
		end)
		:totable()
end

M.components = function()
	return vim.iter(M.get_components()):fold({}, function(acc, v)
		acc[v.module] = require(v.path)
		return acc
	end)
end

return M
