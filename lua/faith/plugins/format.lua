return { -- Autoformat
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
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
			javascript = { "biome" },
			jsx = { "biome" },
			typescript = { "biome" },
			tsx = { "biome" },
			html = { "prettierd" },
			json = { "biome" },
			jsonc = { "biome" },
			css = { "biome" },
			python = { "black", "isort" },
			ocaml = { "ocamlformat" },
			charp = { "charpier" },
		},
		formatters = {
			prettierd = {
				prepend_args = function()
					return { "--no-semi", "--use-tabs" }
				end,
			},
			black = {
				prepend_args = function()
					return { "--line-length", "80" }
				end,
			},
			isort = {
				prepend_args = function()
					return { "--line-length", "80", "--multi-line", "3" }
				end,
			},
			stylua = {
				prepend_args = function()
					return { "--column-width", "80" }
				end,
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		vim.keymap.set({ "n", "v" }, "<M-f>", function()
			require("conform").format({
				async = true,
				lsp_format = "fallback",
				timeout_ms = 500,
			})
		end, {
			desc = "[F]ormat buffer",
		})

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
			vim.notify(
				"Auto-format on save disabled.",
				vim.log.levels.INFO,
				opts
			)
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
			vim.notify(
				"Auto-format on save enabled.",
				vim.log.levels.INFO,
				opts
			)
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
