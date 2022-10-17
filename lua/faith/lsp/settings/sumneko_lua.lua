return {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				special = {
					reload = "require",
				}
			},
			--[[ diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			}, ]]
			type = {
				-- weakUnionCheck = true,
				-- weakNilCheck = true,
				-- castNumberToInteger = true,
			},
			format = {
				enable = false,
			},
			hint = {
				enable = true,
				arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
				await = true,
				paramName = "Disable", -- "All", "Literal", "Disable"
				paramType = true,
				semicolon = "Disable", -- "All", "SameLine", "Disable"
				setType = true,
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				-- library = vim.api.nvim_get_runtime_file("", true),
				--[[ library = {
					---@diagnostic disable-next-line: missing-parameter
					[vim.fn.expand "$VIMRUNTIME/lua"] = true,
					[vim.fn.stdpath "config" .. "/lua"] = true,
				} ]]
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}
