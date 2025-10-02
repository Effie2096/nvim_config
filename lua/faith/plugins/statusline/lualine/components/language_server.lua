local icons = require("faith.icons")

local M = {}

local ui_filetypes = {
	"help",
	"packer",
	"vim-plug",
	"neogitstatus",
	"NvimTree",
	"trouble",
	"lir",
	"Outline",
	"spectre_panel",
	"toggleterm",
	"DressingSelect",
	"TelescopePrompt",
	"lspinfo",
	"lsp-installer",
	"mason",
	"neo-tree",
	"lazy",
	"",
}

local get_clients = function()
	local clients = vim.lsp.get_clients()
	local client_names = {}

	-- should just be lsps
	local names = vim.iter(pairs(clients))
		:filter(function(_, client)
			return not client.name:find("anonymous source")
		end)
		:map(function(_, client)
			return client.name
		end)
		:totable()

	client_names["lsp"] = vim.iter(names)
		:filter(function(name)
			return not name:match("otter")
		end)
		:totable()
	client_names["otter"] = vim.iter(names)
		:filter(function(name)
			return name:match("otter")
		end)
		:totable()
	if require("lint").linters_by_ft[vim.bo.filetype] ~= nil then
		client_names["lint"] = require("lint").linters_by_ft[vim.bo.filetype]
	end

	return client_names
end

local flatten_clients = function(client_map)
	local folded = {}
	if client_map then
		for client_type, clients in pairs(client_map) do
			if clients then
				for _, client in ipairs(clients) do
					table.insert(folded, client)
				end
			end
		end
	end
	return folded
end

return {
	function()
		local buf_ft = vim.bo.filetype

		if vim.tbl_contains(ui_filetypes, buf_ft) then
			if M.language_servers == nil then
				return ""
			else
				return string.format(
					"%s%s",
					icons.ui.Server,
					#flatten_clients(M.language_servers)
				)
			end
		end

		local clients = get_clients()
		local client_names = flatten_clients(clients)

		--remove duplicate entries
		--only want to know which clients are active. not how many times they've attached
		-- local hash = {}
		-- local res = {}
		-- for _, v in ipairs(client_names) do
		-- 	if not hash[v] then
		-- 		res[#res + 1] = v
		-- 		hash[v] = true
		-- 	end
		-- end
		--
		-- client_names = res

		if #client_names ~= 0 then
			M.language_servers = clients
		end

		if #client_names == 0 then
			return ""
		else
			return string.format(
				"%s%s",
				icons.ui.Server,
				#flatten_clients(M.language_servers)
			)
		end
	end,
	padding = { left = 1, right = 0 },
	color = "@lsp.type.type",
	-- cond = function()
	-- 	return #flatten_clients(M.language_servers) ~= 0
	-- end,
	on_click = function(_, _, _)
		local clients = flatten_clients(M.language_servers)
		table.sort(clients)
		local msg = vim.iter(clients):join(", ")
		if msg ~= "" then
			vim.notify(msg, vim.log.levels.INFO, {
				title = "Active Clients",
			})
		end
	end,
}
