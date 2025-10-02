local uv = vim.loop

-- Your schedule of changes
local schedule = {
	{
		hour = 8,
		min = 0,
		background = "light",
		colorscheme = "Catppuccin Latte",
	},
	{
		hour = 20,
		min = 0,
		background = "dark",
		colorscheme = "Catppuccin Mocha",
	},
}

table.sort(schedule, function(a, b)
	if a.hour == b.hour then
		return a.min < b.min
	end
	return a.hour < b.hour
end)

local function apply(entry)
	if entry.colorscheme then
		require("themery").setThemeByName(entry.colorscheme)
	end
	if entry.background then
		vim.o.background = entry.background
	end
end

-- figure out which entry is "current" and which is "next"
local function current_and_next()
	local now = os.date("*t")
	for i = #schedule, 1, -1 do
		local e = schedule[i]
		if now.hour > e.hour or (now.hour == e.hour and now.min >= e.min) then
			local next_idx = (i % #schedule) + 1
			return e, i, schedule[next_idx], next_idx
		end
	end
	-- if before the first entry, wrap to last as current
	return schedule[#schedule], #schedule, schedule[1], 1
end

-- compute os.time for an entry (today or tomorrow)
local function next_time(entry)
	local now = os.date("*t")
	local t = {
		year = now.year,
		month = now.month,
		day = now.day,
		hour = entry.hour,
		min = entry.min,
		sec = 0,
	}
	local target = os.time(t)
	if target <= os.time() then
		target = target + 24 * 60 * 60
	end
	return target
end

local function schedule_next(next_entry, next_idx)
	local target = next_time(next_entry)
	local delay = (target - os.time()) * 1000
	local timer = uv.new_timer()
	timer:start(delay, 0, function()
		timer:stop()
		timer:close()
		apply(next_entry)
		-- compute the following one
		local _, _, ne, ni = current_and_next()
		schedule_next(ne, ni)
	end)
end

-- === Init at startup ===
do
	local current, idx, next_entry, next_idx = current_and_next()
	apply(current)
	schedule_next(next_entry, next_idx)
end

-- === Command for testing ===
vim.api.nvim_create_user_command("ThemeNext", function()
	local _, _, next_entry, next_idx = current_and_next()
	apply(next_entry)
	schedule_next(next_entry, next_idx)
end, {})
