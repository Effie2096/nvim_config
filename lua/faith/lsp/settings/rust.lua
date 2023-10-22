return {
	settings = {
		["rust-analyzer"] = {
			-- enable clippy on save
			checkOnSave = {
				features = "all",
				command = "clippy",
				--[[ overrideCommand = {
					'cargo', 'clippy', '--workspace', '--message-format=json',
					'--all-targets', '--all-features'
				} ]]
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
