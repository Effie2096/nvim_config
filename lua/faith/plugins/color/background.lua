local uv = vim.loop

local function read_json(path)
	local ok, content = pcall(function()
		return table.concat(vim.fn.readfile(path), "\n")
	end)
	if not ok then
		error("Failed to read file: " .. content)
	end
	local ok2, data = pcall(vim.json.decode, content)
	if not ok2 then
		error("Invalid JSON: " .. data)
	end
	return data
end

local path = os.getenv("XDG_STATE_HOME")
local astronomy =
	read_json(vim.fs.find("astronomy.json", { path = path, type = "file" })[1])

local themes = {
	dark = {
		colorscheme = "Midnight",
	},
	light = {
		colorscheme = "Nightfox Day",
	},
}

-- Helper: Convert hour/min to seconds since midnight
local function time_to_seconds(hour, min)
	return hour * 3600 + min * 60
end

-- Helper: Get current time in seconds since midnight
local function now_in_seconds()
	local now = os.date("*t")
	return now.hour * 3600 + now.min * 60 + now.sec
end

-- Helper: Compute delay (in ms) until a given hour/min
local function delay_until(hour, min)
	local now = os.date("*t")
	local target = os.time({
		year = now.year,
		month = now.month,
		day = now.day,
		hour = hour,
		min = min,
		sec = 0,
	})

	local delay = os.difftime(target, os.time())
	if delay < 0 then
		delay = delay + 24 * 3600 -- if target already passed, schedule for next day
	end
	return delay * 1000 -- ms
end

-- Set theme
local function set_theme(mode)
	local theme = themes[mode]
	if theme then
		require("themery").setThemeByName(theme.colorscheme)
		-- vim.notify(string.format("Theme set to: %s", theme.colorscheme))
	end
end

-- Determine current and next theme
local function determine_current_theme()
	local now = now_in_seconds()
	local sunrise = time_to_seconds(
		astronomy.today.sunrise.hour,
		astronomy.today.sunrise.minute
	)
	local sunset = time_to_seconds(
		astronomy.today.sunset.hour,
		astronomy.today.sunset.minute
	)

	if now >= sunrise and now < sunset then
		return "light",
			"dark",
			delay_until(
				astronomy.today.sunset.hour,
				astronomy.today.sunset.minute
			)
	else
		local next_sunrise = astronomy.tomorrow.sunrise
		return "dark",
			"light",
			delay_until(next_sunrise.hour, next_sunrise.minute)
	end
end

-- Timer setup
local timer = uv.new_timer()

local function schedule_next()
	local current, next_mode, delay = determine_current_theme()
	set_theme(current)

	timer:stop()
	timer:start(delay, 0, function()
		vim.schedule(function()
			set_theme(next_mode)
			schedule_next() -- recursively reschedule
		end)
	end)
end

-- Run on startup
schedule_next()

local function fmt_time(hour, min)
	return string.format("%02d:%02d", hour, min)
end

local function notify_debug(current_theme, next_theme, delay)
	local now = os.date("*t")
	local sunrise = astronomy.today.sunrise
	local sunset = astronomy.today.sunset
	local tomorrow_sunrise = astronomy.tomorrow.sunrise

	local msg = table.concat({
		"🕒 Current time: " .. fmt_time(now.hour, now.min),
		"🌅 Today's sunrise: " .. fmt_time(sunrise.hour, sunrise.minute),
		"🌇 Today's sunset: " .. fmt_time(sunset.hour, sunset.minute),
		"🌄 Tomorrow's sunrise: "
			.. fmt_time(tomorrow_sunrise.hour, tomorrow_sunrise.minute),
		"",
		"🎨 Current theme: " .. current_theme,
		"🔜 Next theme: " .. next_theme,
		string.format("⏱ Next switch in %.2f hours", delay / 1000 / 3600),
	}, "\n")

	vim.notify(msg, vim.log.levels.INFO, { title = "Theme Debug" })
end

vim.api.nvim_create_user_command("ThemeNow", function()
	local current, next_mode, delay = determine_current_theme()
	set_theme(current)
	notify_debug(current, next_mode, delay)
end, {})

vim.api.nvim_create_user_command("ThemeNext", function()
	local current, next_mode, delay = determine_current_theme()
	set_theme(next_mode)
	notify_debug(next_mode, current, delay)
end, {})
