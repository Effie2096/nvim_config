local M = {}

M.__tabnames = {}

M.get_tabnames = function()
	return M.__tabnames
end

M.set_tabnames = function(tabnames)
	M.__tabnames = tabnames
end

local name_tab = function(tabnr, cb)
	-- get existing tabname if exists for placeholder in input
	local tabname = vim.fn.gettabvar(tabnr, "tabname")

	vim.ui.input({
		prompt = "Tab name: ",
		default = tabname ~= 0 and tabname or "",
		hightlight = "AccentInverse",
	}, function(input)
		if input and input ~= "" then
			cb(tabnr, input)
		end
	end)
end

local cache_tab_name = function(tabnr, name)
	table.insert(M.__tabnames, { tabnr = tabnr, name = name })
end

local change_tab_name = function(tabnr, name)
	vim.fn.settabvar(tabnr, "tabname", name)
	cache_tab_name(tabnr, name)
	M.refresh_tabnames()
end

local open_tab = function()
	vim.api.nvim_cmd({
		cmd = "tabnew",
		bang = true,
	}, {})
	M.refresh_tabnames()
end

local get_tabnames_index = function(tabnr)
	local index = 0
	for i, tab in ipairs(M.__tabnames) do
		if tab.tabnr == tabnr then
			index = i
		end
	end
	return index
end

local remove_tab = function(tabnr)
	if tabnr then
		local tabnames_index = get_tabnames_index(tabnr)
		if tabnames_index then
			table.remove(M.__tabnames, tabnames_index)
			pcall(vim.api.nvim_tabpage_del_var, tabnr, "tabname")
			M.refresh_tabnames()
		end
	end
end

M.clear_name = function()
	local current_tab = vim.fn.tabpagenr()
	remove_tab(current_tab)
end

M.rename_tab = function(name)
	local tabnr = vim.fn.tabpagenr()
	if name and name ~= "" then
		change_tab_name(tabnr, name)
	else
		name_tab(tabnr, change_tab_name)
	end
end

M.new_tab = function(name)
	-- local index = get_tabnames_index(tabnr)
	-- shift_tabs(index)
	local tabnr = vim.fn.tabpagenr() + 1
	open_tab()
	if name and name ~= "" then
		change_tab_name(tabnr, name)
	else
		name_tab(tabnr, change_tab_name)
	end
end

M.refresh_tabnames = function()
	M.__tabnames = {}
	vim.iter(ipairs(vim.api.nvim_list_tabpages())):each(function(_, v)
		if vim.fn.gettabvar(v, "tabname") ~= "" then
			cache_tab_name(v, vim.fn.gettabvar(v, "tabname"))
		end
	end)
end

return M
