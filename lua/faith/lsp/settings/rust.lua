return {
	settings = {
		["rust-analyzer"] = {
			-- enable clippy on save
			checkOnSave = {
				features = "all",
				command = 'clippy'
				--[[ overrideCommand = {
					'cargo', 'clippy', '--workspace', '--message-format=json',
					'--all-targets', '--all-features'
				} ]]
			},
		},
	}
}
