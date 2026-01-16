local has_bacon = vim.fn.executable("bacon") == 1

return {
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = true,
			},
			-- enable clippy on save
			checkOnSave = {
				enable = true,
				features = "all",
				command = "clippy",
				overrideCommand = {
					"cargo",
					"clippy",
					"--workspace",
					"--message-format=json",
					"--all-targets",
					"--all-features",
				},
			},
			hover = {
				actions = {
					refereneces = true,
				},
			},
			lens = {
				enable = true,
				references = {
					adt = true,
					enumVariant = true,
					method = true,
					trait = true,
				},
			},
		},
	},
}
