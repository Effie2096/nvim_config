local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 16
		elseif term.direction == "vertical" then
			local term_win_width = math.floor(vim.o.columns * 0.4)
			return term_win_width > 81 and term_win_width or 81
		end
	end,
	open_mapping = [[<c-\>]],
	insert_mappings = true,
	terminal_mappings = true,
})
