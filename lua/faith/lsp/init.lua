M = {}
local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

M.server_capabilities = function()
	local active_clients = vim.lsp.get_active_clients()
	local active_client_map = {}

	for index, value in ipairs(active_clients) do
		active_client_map[value.name] = index
	end

	vim.ui.select(vim.tbl_keys(active_client_map), {
		prompt = "Select client:",
		format_item = function(item)
			return "capabilites for: " .. item
		end,
	}, function(choice)
		vim.pretty_print(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities)
	end)
end

require("faith.lsp.handlers").setup()
require("faith.lsp.mason")
require("faith.lsp.null-ls")

return M
