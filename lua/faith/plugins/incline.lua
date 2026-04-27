local incline = require("incline")
local helpers = require("incline.helpers")

local mini_icons = require("mini.icons")
incline.setup({
	window = {
		placement = {
			vertical = "top",
			horizontal = "right",
		},
		padding = 0,
		margin = { horizontal = 0, vertical = 0 },
		overlap = {
			borders = true,
			statusline = false,
			tabline = false,
			winbar = false,
		},
	},
	hide = {
		cursorline = "smart",
	},
	render = function(props)
		local filename =
			vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if filename == "" then
			filename = "[No Name]"
		end
		local ft_icon, ft_color = mini_icons.get("file", filename)
		local modified = vim.bo[props.buf].modified

		return {
			{
				(" %d "):format(vim.api.nvim_win_get_number(props.win)),
				group = "AccentInverse"
			},
			ft_icon and {
				" ",
				ft_icon,
				" ",
				group = ft_color,
			} or "",
			" ",
			{
				filename,
				group = modified and "DiagnosticError" or "WinBar",
				gui = modified and "bold,italic" or "bold",
			},
			" ",
			group = "WinBar",
		}
	end,
})
