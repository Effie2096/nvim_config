local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

return {
	"buffers",
	show_filename_only = true, -- Shows shortened relative path when set to false.
	hide_filename_extension = true, -- Hide filename extension when set to true.
	show_modified_status = true, -- Shows indicator when the buffer is modified.
	icons_enabled = true,
	padding = { left = 1, right = 0 },
	separator = { left = "", right = "" },
	mode = 0,
	-- 0: Shows buffer name
	-- 1: Shows buffer index
	-- 2: Shows buffer name + buffer index
	-- 3: Shows buffer number
	-- 4: Shows buffer name + buffer number

	max_length = function()
		return vim.o.columns * 6 / 3
	end, -- Maximum width of buffers component,
	-- it can also be a function that returns
	-- the value of `max_length` dynamically.
	filetype_names = {
		TelescopePrompt = "Telescope",
		dashboard = "Dashboard",
		packer = "Packer",
		fzf = "FZF",
		alpha = "Alpha",
	}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

	-- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
	use_mode_colors = false,

	buffers_color = {
		-- Same values as the general color option can be used here.
		active = "TabLineSel", -- Color for active buffer.
		inactive = "TabLine", -- Color for inactive buffer.
	},
	symbols = {
		modified = icons.ui.Dot, -- Text to show when the buffer is modified
		alternate_file = "#", -- Text to show to identify the alternate file
		directory = icons.kind.Folder, -- Text to show when the buffer is a directory
	},
	fmt = function(str, ctx)
		local is_current = ctx.bufnr == vim.fn.bufnr()

		if str:find("Scratch") then
			str = "Scratch"
		elseif str:len() > 20 then
			-- split filename and extension
			local name = vim.fn.fnamemodify(str, ":t:r")
			-- local ext = vim.fn.fnamemodify(str, ":e:e")
			-- truncate name so that name + "..." + ext equals 20 chars
			-- str = string.format("%s...%s", name:sub(1, 20 - ext:len() - 3), ext)
			str = string.format("%s...", name:sub(1, 20 - 3))
		end

		return histr(
			str:format(" %s "),
			(is_current and "TabLineSel" or "TabLine")
		) .. histr(
			ctx.buf_index:format("%d "),
			(is_current and "TabIndexSel" or "TabIndex"),
			true
		)
	end,
}
