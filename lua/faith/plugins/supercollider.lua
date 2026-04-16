return {
	"davidgranstrom/scnvim",
	ft = "supercollider",
	config = function()
		local scnvim = require("scnvim")
		local map = scnvim.map
		local map_expr = scnvim.map_expr
		scnvim.setup({
			sclang = {
				cmd = vim.fn.glob("C:/SuperCollider-*/sclang.exe"),
			},
			documentation = {
				cmd = "pandoc.exe",
				args = { "$1", "--from", "html", "--to", "plain", "-o", "$2" },
			},
			keymaps = {
				["<M-e>"] = map("editor.send_line", { "i", "n" }),
				["<C-e>"] = {
					map("editor.send_block", { "i", "n" }),
					map("editor.send_selection", "x"),
				},
				["<CR>"] = map("postwin.toggle"),
				["<M-CR>"] = map("postwin.toggle", "i"),
				["<M-L>"] = map("postwin.clear", { "n", "i" }),
				["<C-k>"] = map("signature.show", { "n", "i" }),
				["<F12>"] = map("sclang.hard_stop", { "n", "x", "i" }),
				["<leader>st"] = map("sclang.start"),
				["<leader>sk"] = map("sclang.recompile"),
				["<F1>"] = map_expr("s.boot"),
				["<F2>"] = map_expr("s.meter"),
			},
			editor = {
				highlight = {
					color = "IncSearch",
				},
			},
			postwin = {
				horizontal = true,
				float = {
					enabled = false,
				},
			},
		})

		require("luasnip").add_snippets(
			"supercollider",
			require("scnvim/utils").get_snippets()
		)
	end,
}
