local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
	return
end

local icons = require("faith.icons")

saga.init_lsp_saga({
	diagnostic_header = {
		icons.diagnostic.error,
		icons.diagnostic.warn,
		icons.diagnostic.info,
		icons.diagnostic.hint,
	},
	symbol_in_winbar = {
		enable = false,
	},
	code_action_lightbulb = {
		enable = false,
		enable_in_insert = false,
		sign = true,
		sign_priority = 20,
		virtual_text = false,
		update_time = 50,
	},
	show_outline = {
		win_position = "right",
		win_width = 40,
		auto_enter = false,
		auto_refresh = true,
	},
	-- custom_kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
})
