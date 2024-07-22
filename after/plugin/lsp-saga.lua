local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
	return
end

local icons = require("faith.icons")

saga.setup({
	diagnostic_header = {
		icons.diagnostic.error,
		icons.diagnostic.warn,
		icons.diagnostic.info,
		icons.diagnostic.hint,
	},
	diagnostic = {
		show_code_action = false,
	},
	symbol_in_winbar = {
		enable = false,
	},
	lightbulb = {
		enable = true,
		enable_in_insert = false,
		sign = false,
		sign_priority = 20,
		virtual_text = true,
		update_time = 50,
	},
	show_outline = {
		win_position = "right",
		win_width = 60,
		auto_enter = false,
		auto_refresh = true,
	},
	implement = {
		enable = true,
	},
	-- custom_kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
})
