if vim.fn.has("win32") ~= 0 then
	require("faith.shell")
end

--require("faith.langmap")
require("faith.filetypes")
require("faith.globals")
require("faith.mappings")
require("faith.settings")
require("faith.plugins")
require("faith.tabnames")

require("faith.neovide")
