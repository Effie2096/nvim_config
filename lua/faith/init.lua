require("faith.plugins")
pcall(require, "impatient")

if vim.fn.has("win32") ~= 0 then
	require("faith.shell")
end

require("faith.globals")

require("faith.keymap")
require("faith.mappings")
require("faith.settings")
require("faith.session")

require("faith.telescope.setup")
require("faith.telescope.mappings")

require("faith.lsp")
require("faith.snippets.comment_nvim")

require("faith.listchars")
