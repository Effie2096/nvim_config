local M = {}

M.__index = M

local spinner_frames =
	{ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
function M:new(interval)
	local instance = setmetatable({}, M)
	instance.frames = spinner_frames
	instance.interval = interval
	instance.spinner = 1
	instance.update = vim.defer_fn(function()
		instance:update_spinner()
	end, interval)
	return instance
end

function M:update_spinner()
	local frame = self.frames[self.spinner]
	self.spinner = (self.spinner % #self.frames) + 1
	self.update = vim.defer_fn(function()
		self:update_spinner()
	end, self.interval)
	return frame
end

return M
