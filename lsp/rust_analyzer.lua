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
				debug = { enable = true },
				enable = true,
				implementations = { enable = true },
				references = {
					adt = { enable = true },
					enumVariant = { enable = true },
					method = { enable = true },
					trait = { enable = true },
				},
				run = { enable = true },
				updateTest = { enable = true },
			},
		},
	},
}
