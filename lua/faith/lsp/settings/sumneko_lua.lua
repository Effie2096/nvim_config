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
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}
