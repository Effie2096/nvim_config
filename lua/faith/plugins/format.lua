-- stylua: ignore start
local formatters_by_ft = {
	cs = { "csharpier" },
	css = { "biome", "biome-check" },
	go = { "gofumpt" },
	html = { "superhtml" },
	java = { "google-java-format" },
	javascript = { "biome", "biome-check" },
	json = { "biome" },
	jsonc = { "biome" },
	jsx = { "biome", "biome-check" },
	-- kotlin = { "ktlint" },
	lua = { "stylua" },
	ocaml = { "ocamlformat" },
	python = { "ruff_format", "ruff_organize_imprts" },
	rust = { "rustfmt" },
	sh = { "beautysh" },
	toml = { "taplo" },
	tsx = { "biome", "biome-check" },
	typescript = { "biome", "biome-check" },
}
-- stylua: ignore end

local formatters = {
	-- "codespell",
}

formatters_by_ft = vim
	.iter(formatters_by_ft)
	:map(function(k, v)
		vim.iter(formatters):each(function(f)
			table.insert(v, f)
		end)
		return { k, v }
	end)
	:fold({}, function(acc, k)
		acc[k[1]] = k[2]
		return acc
	end)

return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<M-f>",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { lsp_format = "fallback", timeout_ms = 500 }
			end,
			formatters_by_ft = formatters_by_ft,
			formatters = {
				prettierd = {
					prepend_args = function()
						return { "--no-semi", "--use-tabs" }
					end,
				},
				black = {
					prepend_args = function()
						return { "--line-length", vim.o.textwidth }
					end,
				},
				isort = {
					prepend_args = function()
						return { "--line-length", vim.o.textwidth, "--multi-line", "3" }
					end,
				},
				stylua = {
					prepend_args = function()
						return { "--column-width", vim.o.textwidth }
					end,
				},
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

			local opts = {
				title = "Formatting",
			}

			vim.api.nvim_create_user_command("Format", function()
				require("conform").format({ async = true })
			end, {
				desc = "Format current buffer",
			})
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
				vim.notify("Auto-format on save disabled.", vim.log.levels.INFO, opts)
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
				vim.notify("Auto-format on save enabled.", vim.log.levels.INFO, opts)
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},
}
