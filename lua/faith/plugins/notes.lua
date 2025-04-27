local icons = require("faith.icons")

return {
	{
		"3rd/image.nvim",
		enabled = false,
		build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
		opts = {
			processor = "magick_cli",
			hijack_file_patterns = {
				"*.png",
				"*.jpg",
				"*.jpeg",
				"*.gif",
				"*.webp",
				"*.bmp",
			}, -- render image files as images when opened
			max_height = 15,
			window_overlap_clear_enabled = true,
			integrations = {
				markdown = {
					only_render_image_at_cursor = true,
					resolve_image_path = function(
						document_path,
						image_path,
						fallback
					)
						local cwd = vim.fn.getcwd()
						if vim.fn.filereadable(cwd .. "/" .. image_path) then
							return cwd .. "/" .. image_path
						end
						return fallback(document_path, image_path)
					end,
				},
			},
		},
	},
	{
		"jmbuhr/otter.nvim",
		ft = { "markdown" },
		opts = {
			html = {
				enabled = true,
			},
			css = {
				enabled = true,
			},
			lsp = {
				hover = {
					border = {
						icons.borders.square.top_left,
						icons.borders.square.top,
						icons.borders.square.top_right,
						icons.borders.square.right,
						icons.borders.square.bottom_right,
						icons.borders.square.bottom,
						icons.borders.square.bottom_left,
						icons.borders.square.left,
					},
				},
			},
			verbose = {
				no_code_found = false,
			},
		},
		config = function()
			vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
				group = vim.api.nvim_create_augroup(
					"attach_otter",
					{ clear = true }
				),
				pattern = { "*.md" },
				callback = function()
					require("otter").activate()
				end,
			})
		end,
	},
	{
		"bullets-vim/bullets.vim",
		init = function()
			vim.g.bullets_enabled_file_types =
				{ "markdown", "text", "gitcommit" }
			vim.g.bullets_enable_in_empty_buffers = 0 -- default = 1
		end,
	},
	"godlygeek/tabular",
	{
		"dhruvasagar/vim-table-mode",
		init = function()
			vim.g.table_mode_corner = "|"
		end,
	},
	"iamcco/markdown-preview.nvim",
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "markdown", "vim-plug" },
		opts = {
			file_types = { "markdown", "Avante" },
			render_modes = { "n", "i", "c" },
			heading = {
				-- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
				icons = { " " },
				border = true,
				-- border_virtual = true,
				-- width = "block",
				-- min_width = 80,
			},
			indent = {
				enabled = true,
				skip_heading = true,
				-- icon = " ",
			},
			bullet = {
				enabled = true,
			},
			checkbox = {
				enabled = true,
				unchecked = {
					icon = "󰄱",
					highlight = "RenderMarkdownUnchecked",
				},
				checked = {
					icon = "󰱒",
					highlight = "RenderMarkdownChecked",
				},
				custom = {
					cancelled = {
						raw = "[~]",
						rendered = "󰅘",
						highlight = "Comment",
						scope_highlight = "@markup.strikethrough",
					},
					paused = {
						raw = "[>]",
						rendered = "󰏦",
						highlight = "DiagnosticSignWarn",
					},
					urgent = {
						raw = "[^]",
						rendered = "",
						highlight = "DiagnosticSignError",
					},
					optional = {
						raw = "[?]",
						rendered = "",
						highlight = "DiagnosticSignInfo",
					},
				},
			},
			link = {
				enabled = true,
			},
			code = {
				width = "block",
				min_width = 78,
				left_pad = 2,
				language_pad = 2,
			},
			sign = {
				-- Turn on / off sign rendering.
				enabled = true,
				highlight = "RenderMarkdownSign",
			},
			-- paragraph = { left_margin = 0.5 },
			anti_conceal = {
				enabled = true,
			},
			win_options = {
				conceallevel = {
					rendered = 2,
				},
			},
			callout = {
				note = {
					raw = "[!NOTE]",
					rendered = "󰋽 Note",
					highlight = "RenderMarkdownInfo",
				},
				tip = {
					raw = "[!TIP]",
					rendered = "󰌶 Tip",
					highlight = "RenderMarkdownSuccess",
				},
				important = {
					raw = "[!IMPORTANT]",
					rendered = "󰅾 Important",
					highlight = "RenderMarkdownHint",
				},
				warning = {
					raw = "[!WARNING]",
					rendered = "󰀪 Warning",
					highlight = "RenderMarkdownWarn",
				},
				caution = {
					raw = "[!CAUTION]",
					rendered = "󰳦 Caution",
					highlight = "RenderMarkdownError",
				},
				-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
				abstract = {
					raw = "[!ABSTRACT]",
					rendered = "󰨸 Abstract",
					highlight = "RenderMarkdownInfo",
				},
				summary = {
					raw = "[!SUMMARY]",
					rendered = "󰨸 Summary",
					highlight = "RenderMarkdownInfo",
				},
				tldr = {
					raw = "[!TLDR]",
					rendered = "󰨸 Tldr",
					highlight = "RenderMarkdownInfo",
				},
				info = {
					raw = "[!INFO]",
					rendered = "󰋽 Info",
					highlight = "RenderMarkdownInfo",
				},
				todo = {
					raw = "[!TODO]",
					rendered = "󰗡 Todo",
					highlight = "RenderMarkdownInfo",
				},
				hint = {
					raw = "[!HINT]",
					rendered = "󰌶 Hint",
					highlight = "RenderMarkdownSuccess",
				},
				success = {
					raw = "[!SUCCESS]",
					rendered = "󰄬 Success",
					highlight = "RenderMarkdownSuccess",
				},
				check = {
					raw = "[!CHECK]",
					rendered = "󰄬 Check",
					highlight = "RenderMarkdownSuccess",
				},
				done = {
					raw = "[!DONE]",
					rendered = "󰄬 Done",
					highlight = "RenderMarkdownSuccess",
				},
				question = {
					raw = "[!QUESTION]",
					rendered = "󰘥 Question",
					highlight = "RenderMarkdownWarn",
				},
				help = {
					raw = "[!HELP]",
					rendered = "󰘥 Help",
					highlight = "RenderMarkdownWarn",
				},
				faq = {
					raw = "[!FAQ]",
					rendered = "󰘥 Faq",
					highlight = "RenderMarkdownWarn",
				},
				attention = {
					raw = "[!ATTENTION]",
					rendered = "󰀪 Attention",
					highlight = "RenderMarkdownWarn",
				},
				failure = {
					raw = "[!FAILURE]",
					rendered = "󰅖 Failure",
					highlight = "RenderMarkdownError",
				},
				fail = {
					raw = "[!FAIL]",
					rendered = "󰅖 Fail",
					highlight = "RenderMarkdownError",
				},
				missing = {
					raw = "[!MISSING]",
					rendered = "󰅖 Missing",
					highlight = "RenderMarkdownError",
				},
				danger = {
					raw = "[!DANGER]",
					rendered = "󱐌 Danger",
					highlight = "RenderMarkdownError",
				},
				error = {
					raw = "[!ERROR]",
					rendered = "󱐌 Error",
					highlight = "RenderMarkdownError",
				},
				bug = {
					raw = "[!BUG]",
					rendered = "󰨰 Bug",
					highlight = "RenderMarkdownError",
				},
				example = {
					raw = "[!EXAMPLE]",
					rendered = "󰉹 Example",
					highlight = "RenderMarkdownHint",
				},
				quote = {
					raw = "[!QUOTE]",
					rendered = "󱆨 Quote",
					highlight = "RenderMarkdownQuote",
				},
				cite = {
					raw = "[!CITE]",
					rendered = "󱆨 Cite",
					highlight = "RenderMarkdownQuote",
				},
			},
		},
	},
	{
		"luizribeiro/vim-cooklang",
		ft = "cook",
	},
}
