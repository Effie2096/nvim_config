return {
	{
		"uga-rosa/ccc.nvim",
		lazy = false,
		config = function()
			local ccc = require("ccc")
			local opts = {
				lsp = true,
				highlight_mode = "bg",
				highlighter = {
					auto_enable = true,
					lsp = true,
					excludes = {
						"fugitive",
					},
					update_insert = true,
				},
				virtual_pos = "inline-left",
				virtual_symbol = require("faith.icons").ui.Circle,
				inputs = {
					ccc.input.rgb,
					ccc.input.hsl,
					ccc.input.hwb,
					ccc.input.lab,
					ccc.input.lch,
					ccc.input.oklab,
					ccc.input.oklch,
					ccc.input.cmyk,
					ccc.input.hsluv,
					ccc.input.okhsl,
					ccc.input.hsv,
					ccc.input.okhsv,
					ccc.input.xyz,
				},
				outputs = {
					ccc.output.hex,
					ccc.output.hex_short,
					ccc.output.css_rgb,
					ccc.output.css_rgba,
					ccc.output.css_hsl,
					ccc.output.css_hwb,
					ccc.output.css_lab,
					ccc.output.css_lch,
					ccc.output.css_oklab,
					ccc.output.css_oklch,
					ccc.output.float,
				},
				pickers = {
					ccc.picker.hex,
					ccc.picker.hex_long,
					ccc.picker.hex_short,
					ccc.picker.css_rgb,
					ccc.picker.css_hsl,
					ccc.picker.css_hwb,
					ccc.picker.css_lab,
					ccc.picker.css_lch,
					ccc.picker.css_oklab,
					ccc.picker.css_oklch,
					ccc.picker.css_name,
					ccc.picker.defaults,
				},
			}

			ccc.setup(opts)
		end,
		keys = {
			{
				"<Leader>cp",
				"<cmd>CccPick<cr>",
				desc = "[c]olor [p]icker: Open color picker.",
			},
			{
				"<M-c>",
				"<cmd>CccPick<cr>",
				desc = "[c]olor picker: Open color picker.",
				mode = "i",
			},
		},
	},
}
