require("faith")

if pcall(require, "notify") then
	vim.notify = require("notify")
end

require("faith.catppuccin")
