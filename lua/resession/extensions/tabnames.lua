local M = {}

M.on_save = function()
	return require("faith.tabnames.tabnames").get_tabnames()
end

M.on_pre_load = function(data)
	-- This is run before the buffers, windows, and tabs are restored
	require("faith.tabnames.tabnames").set_tabnames(data)
end

M.on_post_load = function(_)
	-- This is run after the buffers, windows, and tabs are restored
	vim.iter(ipairs(require("faith.tabnames.tabnames").get_tabnames()))
		:each(function(_, v)
			P(v)
			vim.fn.settabvar(v.tabnr, "tabname", v.name)
		end)
end

return M
