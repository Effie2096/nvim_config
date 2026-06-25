local M = {}

---Get the saved data for this extension
---@param opts resession.Extension.OnSaveOpts Information about the session being saved
---@return any
M.on_save = function(opts)
	return require("bpm").to_json()
end

-- ---Restore the extension state
-- ---@param data The value returned from on_save
-- M.on_pre_load = function(data)
-- 	-- This is run before the buffers, windows, and tabs are restored
-- end

---Restore the extension state
---@param data The value returned from on_save
M.on_post_load = function(data)
	-- This is run after the buffers, windows, and tabs are restored
	require("bpm").from_json(data)
end

return M
