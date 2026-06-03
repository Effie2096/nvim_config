vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind, folder = ev.data.spec.name, ev.data.kind, ev.file
		if name == "blink.pairs" and (kind == "update" or kind == "install") then
			require("blink.pairs").download():pwait(60000)
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/saghen/blink.lib" },
	{
		src = "https://github.com/saghen/blink.pairs",
		version = vim.version.range("*"),
	},
})

local bp = require("blink.pairs")

bp.setup(
	--- @module 'blink.pairs'
	--- @type blink.pairs.Config
	{
		mappings = {
			-- you can call require("blink.pairs.mappings").enable()
			-- and require("blink.pairs.mappings").disable()
			-- to enable/disable mappings at runtime
			enabled = true,
			cmdline = false,
			-- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
			-- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
			disabled_filetypes = {},
			-- see the defaults:
			-- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
			pairs = {
				["|"] = {
					{ "|", languages = { "rust", "supercollider" } },
				},
			},
		},
		highlights = {
			enabled = true,
			-- requires require('vim._extui').enable({}), otherwise has no effect
			cmdline = true,
			groups = {
				"@punctuation.bracket",
				-- "RainbowRed",
				-- "RainbowYellow",
				-- "RainbowBlue",
				-- "RainbowOrange",
				-- "RainbowGreen",
				-- "RainbowViolet",
				-- "RainbowCyan",
			},
			unmatched_group = "@comment.error",

			-- highlights matching pairs under the cursor
			matchparen = {
				enabled = true,
				-- known issue where typing won't update matchparen highlight, disabled by default
				cmdline = false,
				-- also include pairs not on top of the cursor, but surrounding the cursor
				include_surrounding = true,
				group = "AccentInverse",
				priority = 250,
			},
		},
		debug = false,
	}
)
