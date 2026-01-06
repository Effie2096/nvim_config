return {
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = false,
			},
			-- enable clippy on save
			checkOnSave = {
				enable = false,
				features = "all",
				-- command = "clippy",
				-- overrideCommand = {
				-- 	"cargo",
				-- 	"clippy",
				-- 	"--workspace",
				-- 	"--message-format=json",
				-- 	"--all-targets",
				-- 	"--all-features",
				-- },
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
