local has_conform, conform = pcall(require, "conform")
if not has_conform then
	return
end

conform.setup({
	notify_on_error = true,
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	formatters_by_ft = {
		sh = { "beautysh" },
		lua = { "stylua" },
		rust = { "rustfmt" },
		javascript = { { "prettierd", "prettier" } },
		python = { "black" },
		--[[ formatting.prettierd.with({
			-- extra_filetypes = { "toml", "solidity" },
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote", "--use-tabs" },
		}), ]]
		charp = { "charpier" },
	},
})

conform.formatters.prettierd = {
	prepend_args = function()
		return { "--no-semi", "--single-quote", "--jsx-single-quote", "--use-tabs" }
	end,
}
