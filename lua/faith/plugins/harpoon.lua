local map = function(lhs, action, desc, mode)
	return {
		lhs,
		function()
			action()
			vim.cmd.redrawstatus()
		end,
		desc = desc,
		mode or { "n" }
	}

end
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		map("<leader>Ha", function() require("harpoon"):list():add() end,  "[H]arpoon [a]dd: Add harpoon."),
		map("<leader>He", function() require("harpoon").ui:toggle_quick_menu( require("harpoon"):list()) end,  "[H]arpoon [e]dit: Edit harpoons."),
		map("<M-m>", function() require("harpoon"):list():select(1) end),
		map("<M-n>", function() require("harpoon"):list():select(2) end),
		map("<M-e>", function() require("harpoon"):list():select(3) end),
		map("<M-i>", function() require("harpoon"):list():select(4) end),
		map("<M-a>", function() require("harpoon"):list():select(5) end),
		map("<M-;>", function() require("harpoon"):list():select(6) end),
	},
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		local harpoon_extensions = require("harpoon.extensions")
		harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
		harpoon:extend({
			UI_CREATE = function(cx)
				vim.keymap.set("n", "<C-v>", function()
					harpoon.ui:select_menu_item({ vsplit = true })
				end, { buffer = cx.bufnr })

				vim.keymap.set("n", "<C-x>", function()
					harpoon.ui:select_menu_item({ split = true })
				end, { buffer = cx.bufnr })

				vim.keymap.set("n", "<C-t>", function()
					harpoon.ui:select_menu_item({ tabedit = true })
				end, { buffer = cx.bufnr })
			end,
		})
	end
}
