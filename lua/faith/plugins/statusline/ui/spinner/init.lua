local Spinner = {}
Spinner.__index = Spinner

local patterns = require("faith.plugins.statusline.ui.spinner.patterns")

local uv = vim.uv -- Use Neovim's event loop for timers

-- Constructor for creating a new spinner instance
function Spinner:new(id, spinner, interval)
	local instance = setmetatable({}, self)
	instance.id = id
	instance.spinner = patterns[spinner] or { ".", "..", "..." } -- Default spinner pattern
	instance.interval = interval or 100 -- Default interval in milliseconds
	instance.frame = 1
	instance.running = false -- Track whether the spinner is running
	instance.timer = nil -- Timer handle for automatic animation
	return instance
end

-- Method to start the spinner
function Spinner:start(callback)
	if self.running then
		return -- Prevent starting if already running
	end

	self.running = true

	-- Create a timer to animate the spinner
	self.timer = uv.new_timer()
	self.timer:start(
		0, -- Initial delay
		self.interval, -- Interval between frames
		vim.schedule_wrap(function()
			if not self.running then
				return -- Exit early if the spinner is no longer running
			end

			-- Animate the spinner and call the callback
			self:animate()
			if callback then
				callback(self:get_frame())
			end
		end)
	)
end

-- Method to stop the spinner
function Spinner:stop()
	if not self.running then
		return -- Prevent stopping if already stopped
	end

	self.running = false
	if self.timer then
		self.timer:stop()
		self.timer:close()
		self.timer = nil -- Set to nil after stopping and closing
	end
end

-- Method to animate the spinner (progress through frames)
function Spinner:animate()
	self.frame = (self.frame % #self.spinner) + 1
end

-- Method to get the current frame without advancing
function Spinner:get_frame()
	return self.spinner[self.frame]
end

return Spinner
