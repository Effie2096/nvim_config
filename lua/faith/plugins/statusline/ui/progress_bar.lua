local histr = require("faith.plugins.statusline.utils").histr

return function(current, total, width, display)
	local ratio = current / total
	local filled_len = math.floor(ratio * width)
	local progress_text = display or string.format("%d/%d", current, total)
	local text_len = #progress_text
	local text_pos = math.ceil((width - text_len) / 2)

	local segments = {}

	for i = 1, width do
		if i >= text_pos + 1 and i < text_pos + 1 + text_len then
			local c = progress_text:sub(i - text_pos, i - text_pos)
			local hl = i <= filled_len and "TextFilled" or "TextEmpty"
			if c == "%" then
				c = "%%"
			end
			table.insert(segments, histr(c, hl))
		elseif i <= filled_len then
			table.insert(segments, histr(" ", "ProgressFilled"))
		else
			table.insert(segments, histr(" ", "ProgressEmpty"))
		end
	end

	table.insert(segments, "%*")

	return table.concat(segments)
end
