return {
	init_options = {
		-- Bacon export filename (default: .bacon-locations).
		locationsFile = ".bacon-locations",
		-- Try to update diagnostics every time the file is saved (default: true).
		updateOnSave = true,
		--  How many milliseconds to wait before updating diagnostics after a save (default: 1000).
		updateOnSaveWaitMillis = 1000,
		-- Try to update diagnostics every time the file changes (default: true).
		updateOnChange = true,
		-- Try to validate that bacon preferences are setup correctly to work with bacon-ls (default: true).
		validateBaconPreferences = true,
		-- f no bacon preferences file is found, create a new preferences file with the bacon-ls job definition (default: true).
		createBaconPreferencesFile = true,
		-- Run bacon in background for the bacon-ls job (default: true)
		runBaconInBackground = true,
		-- Command line arguments to pass to bacon running in background (default "--headless -j bacon-ls")
		runBaconInBackgroundCommandArguments = "--headless -j bacon-ls",
		-- How many milliseconds to wait between background diagnostics check to synchronize all open files (default: 2000).
		synchronizeAllOpenFilesWaitMillis = 2000,
		cargo = { updateOnInsert = true },
	},
	settings = {
		bacon_ls = {
			backend = "cargo",
			cargo = {
				command = "clippy", -- "check" or "clippy"
				-- features = {}, -- cargo --features list, ["feat1", "feat2"] or "all"
				-- package = null,                    -- cargo -p <package>
				allTargets = true, -- cargo --all-targets
				noDefaultFeatures = false, -- cargo --no-default-features
				-- extraArgs = {}, -- appended verbatim after the cargo command
				-- env = {}, -- extra environment variables (string -> string)
				cancelRunning = true, -- cancel an in-flight run when a new one is triggered
				refreshIntervalSeconds = 1, -- partial publish interval; null/negative = wait until done
				-- separateChildDiagnostics = null,   -- override "related information" support; null = follow client
				checkOnSave = true, -- trigger cargo on textDocument/didSave
				clearDiagnosticsOnCheck = false, -- clear existing diagnostics before each run
				-- updateOnInsert lives in init_options above; only the
				-- runtime knob lives here:
				updateOnInsertDebounceMillis = 500, -- debounce for live diagnostics; updateOnInsert itself is in init_options
			},
			bacon = {
				locationsFile = ".bacon-locations",
				runInBackground = true,
				runInBackgroundCommand = "bacon",
				runInBackgroundCommandArguments = "--headless -j bacon-ls",
				validatePreferences = true,
				createPreferencesFile = true,
				synchronizeAllOpenFilesWaitMillis = 2000,
				updateOnSave = true,
				updateOnSaveWaitMillis = 1000,
			},
		},
	},
}
