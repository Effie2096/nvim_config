local has_conform, conform = pcall(require, "conform")
if not has_conform then
	return
end

conform.setup({
	notify_on_error = true,
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { lsp_format = "fallback", timeout_ms = 500 }
	end,
	formatters_by_ft = {
		sh = { "beautysh" },
		lua = { "stylua" },
		rust = { "rustfmt" },
		javascript = { { "prettierd" } },
		python = { "black", "isort" },
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

conform.formatters.black = {
	prepend_args = function()
		return { "--line-length", "99" }
	end,
}

conform.formatters.isort = {
	prepend_args = function()
		return { "--line-length", "99" }
	end,
}

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})
