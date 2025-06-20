local function find_love()
	local path_to_love_library =
		vim.fn.globpath(vim.o.runtimepath, "love2d/library")
	local library_path =
		vim.fn.split(vim.fn.expand(path_to_love_library), "\n")[1]
	if vim.fn.isdirectory(library_path) == 0 then
		return ""
	end

	return library_path
end

return {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				special = {
					reload = "require",
				},
			},
			diagnostics = {
				globals = {
					"awesome",
					"love",
				},
				disable = { "missing-fields" },
			},
			workspace = {
				library = {
					"/usr/share/awesome/lib",
					find_love(),
				},
			},
			type = {
				weakUnionCheck = true,
				weakNilCheck = true,
				castNumberToInteger = true,
			},
			format = {
				enable = false,
			},
			hint = {
				enable = true,
				arrayIndex = "Enable", -- "Enable", "Auto", "Disable"
				await = true,
				paramName = "All", -- "All", "Literal", "Disable"
				paramType = true,
				semicolon = "Disable", -- "All", "SameLine", "Disable"
				setType = true,
			},
			completion = {
				callSnippet = "Replace",
				keywordSnippet = "Both",
				workspaceWord = true,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}
