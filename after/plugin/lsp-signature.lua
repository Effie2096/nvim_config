local status_ok, signature = pcall(require, "lsp_signature")
if not status_ok then
	return
end

local cfg = {
	debug = false,
	log_path = vim.fn.glob(vim.fn.stdpath("cache") .. "/lsp_signature.log"),
	verbose = false,

	bind = true,
	doc_lines = 1,

	floating_window = true,

	floating_window_above_cur_line = true,
	fix_pos = true,
	hint_enable = false,
	hint_prefix = "🐼 ",
	hint_scheme = "Conceal",
	hi_parameter = "Search",
	max_height = 12,
	max_width = 120,
	handler_opts = {
		border = "single",
	},

	always_trigger = true,

	auto_close_after = nil,
	extra_trigger_chars = { "(", "," },
	zindex = 200,

	padding = "",

	transparency = nil,
	shadow_blend = 36,
	shadow_guibg = "Black",
	timer_interval = 200,
	toggle_key = nil,
	select_signature_key = "<M-n>",
}

--recommanded:
signature.setup(cfg) --no need to specify bufnr if you don't use toggle_key

-- You can also do this inside lsp on_attach
-- note: on_attach deprecated
-- require("lsp_signature").on_attach(cfg, bufnr) -- no need to specify bufnr if you don't use toggle_key
-- signature.on_attach(cfg) -- no need to specify bufnr if you don't use toggle_key
