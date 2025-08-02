local histr = require("faith.plugins.statusline.utils").histr

local lualine_color = "WinBar"
local default_color = lualine_color
local color_start = "%#"
local color_end = "#"

local function parse_control_element(element)
	local e = element:match("(.*)%%#0#$")
	local color, action_element = e:match("^(.-)#%%(.+)$")
	color = color:gsub("^%%#", "")
	return color, "%" .. action_element
end

return function(separator, active)
	local background_color = lualine_color
	local controls_string = color_start .. default_color .. color_end
	for control_element in require("dapui.controls").controls():gmatch("%S+") do
		local color, action_element = parse_control_element(control_element)
		-- local new_color = merge_colors(color, default_color)
		local out = histr(separator, background_color)
			.. histr(" " .. action_element, color)
		controls_string = controls_string .. " " .. out
	end
	return controls_string
end
