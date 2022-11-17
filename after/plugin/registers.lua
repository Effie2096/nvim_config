local status_ok, registers = pcall(require, 'registers')
if not status_ok then
	return
end

registers.setup({
	symbols = {
		-- Show a special character for line breaks
		newline = "﬋",
		-- Show space characters without changes
		space = "•",
		-- Show a special character for tabs
		tab = "▸▸",
		-- The character to show when a register will be applied in a char-wise fashion
		register_type_charwise = "ᶜ",
		-- The character to show when a register will be applied in a line-wise fashion
		register_type_linewise = "ˡ",
		-- The character to show when a register will be applied in a block-wise fashion
		register_type_blockwise = "ᵇ",
	},
	window = {
		transparency = 0
	},
	 -- Highlight the sign registers as regular Neovim highlights
	sign_highlights = {
		cursorline = "Visual",
		selection = "Constant",
		default = "Function",
		unnamed = "Statement",
		read_only = "Type",
		expression = "Exception",
		black_hole = "Error",
		alternate_buffer = "Operator",
		last_search = "Tag",
		delete = "Special",
		yank = "Delimiter",
		history = "Number",
		named = "String",
	}
})
