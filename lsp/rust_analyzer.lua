local has_bacon = (vim.fn.executable("bacon") == 1)
	and (vim.fn.executable("bacon-ls") == 1)

return {
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = not has_bacon,
			},
			-- enable clippy on save
			checkOnSave = {
				enable = not has_bacon,
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
