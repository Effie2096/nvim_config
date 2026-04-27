return {
	settings = {
		kotlin = {
			inlayHints = {
				typeHints = true,
				parameterHints = true,
				chaineHints = true,
			},
			formatting = {
				-- formatter = "ktfmt",
				ktfmt = {
					style = "facebook",
					indent = 4,
					maxWidth = vim.opt.textwidth:get(),
					continuationIndent = 0,
					removeUnusedImports = true,
				},
			},
		},
	},
}
