local ns = require("neoscroll")
local	opts = {
	easing = "quadratic",
	mappings = {},
	hide_cursor = true, -- Hide cursor while scrolling
	stop_eof = true, -- Stop at <EOF> when scrolling downwards
	use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
	respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	easing_function = nil, -- Default easing function
	pre_hook = nil, -- Function to run before the scrolling animation starts
	post_hook = nil, -- Function to run after the scrolling animation ends
}
ns.setup(opts)

vim.keymap.set({"n"},
	"<C-u>",
	function()
		require("neoscroll").ctrl_u({
			duration = 80,
			easing = "sine",
		})
	end
)
vim.keymap.set({"n"},
	"<C-d>",
	function()
		require("neoscroll").ctrl_d({
			duration = 80,
			easing = "sine",
		})
	end
)
vim.keymap.set({"n"},
	"<C-b>",
	function()
		require("neoscroll").ctrl_b({
			duration = 120,
			easing = "circular",
		})
	end
)
vim.keymap.set({"n"},
	"<C-f>",
	function()
		require("neoscroll").ctrl_f({
			duration = 120,
			easing = "circular",
		})
	end
)
vim.keymap.set({"n"},
	"<C-y>",
	function()
		require("neoscroll").scroll(-0.1, { move_cursor = false, duration = 50 })
	end
)
vim.keymap.set({"n"},
	"<C-e>",
	function()
		require("neoscroll").scroll(0.1, { move_cursor = false, duration = 50 })
	end
)
vim.keymap.set({"n"},
	"zt",
	function()
		require("neoscroll").zt({
			half_win_duration = 180,
			easing = "circular",
		})
	end
)
vim.keymap.set({"n"},
	"zz",
	function()
		require("neoscroll").zz({
			half_win_duration = 180,
			easing = "circular",
		})
	end
)
vim.keymap.set({"n"},
	"zb",
	function()
		require("neoscroll").zb({
			half_win_duration = 180,
			easing = "circular",
		})
	end
)
