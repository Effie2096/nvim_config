return {
	tools = {
		executor = require("rust-tools.executors").termopen,
		inlay_hints = {
			auto = false
		},
		runnables = {
			use_telescope = true,
		},
		hover_actions = {
			auto_focus = true,
		},
	}
}
