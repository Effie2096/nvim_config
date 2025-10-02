local components =
	require("faith.plugins.statusline.lualine.components").components()
local icons = require("faith.icons")

local winbar_ignore = require(
	"faith.plugins.statusline.lualine.components.winbar"
).ignore.winbar_ignore
local trunc = require("faith.plugins.statusline.utils").trunc

local sections = {
	lualine_a = { components.vanity.trans_flag },
	lualine_b = {
		components.resession,
		components.root,
		components.branch,
	},
	lualine_c = {
		components.diagnostics_ws,
		components.git_conflict,

		components.language_server,
		components.windsurf,
		components.copilot,

		components.lint_progress,
		components.asyncrun,
		components.overseer,
	},
	lualine_x = {
		-- buffers,
		components.format_on_save,
		components.show_macro_recording,
	},
	lualine_y = {
		components.codestats.total_xp,
	},
	lualine_z = {},
}

local winbar = {
	lualine_a = {
		components.winnumber,
	},
	lualine_b = {
		{ -- fill space to center filename
			"%=",
			padding = { left = 0, right = 0 },
			color = "Winbar",
			separator = "",
			fmt = function(str)
				if not winbar_ignore() then
					return " "
				end
				return str
			end,
		},
	},
	lualine_c = {
		components.filetype,
		components.filename,
	},
	lualine_x = {
		components.guessindent,
		components.fileformat,
		components.encoding,
	},
	lualine_y = {
		components.codestats.buf_xp,
	},
	lualine_z = {
		components.diagnostics_buf,
	},
}

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
		init = function()
			local buf_next = function(next, count)
				if count ~= 0 then
					vim.cmd([[LualineBuffersJump! ]] .. count)
				else
					vim.cmd(next and "bnext" or "bprevious")
				end
			end

			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<leader>.", function()
				buf_next(true, vim.v.count)
			end, opts)
			vim.keymap.set("n", "<leader>,", function()
				buf_next(false, vim.v.count)
			end, opts)
		end,
		opts = function()
			local opts = {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = {
						left = "",
						right = "",
					},
					section_separators = { left = "", right = "" },
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
						-- refresh_time = 16,
					},
					disabled_filetypes = {
						winbar = {
							"Avante",
							"AvanteInput",
							"AvanteSelectedFiles",
						},
					},
				},
				sections = sections,
				inactive_sections = sections,
				winbar = winbar,
				inactive_winbar = winbar,
				tabline = {
					lualine_a = { components.tab_count, components.tabs },
					lualine_b = {
						components.buffer_count,
						components.alt_buffer,
					},
					lualine_c = {},
					lualine_x = { components.harpoon },
				},
				extensions = {
					-- "fugitive",
					"lazy",
					"mason",
					-- "neo-tree",
					-- "nvim-dap-ui",
					"oil",
					-- "overseer",
					-- "quickfix",
					-- "symbols-outline",
					-- "toggleterm",
					-- "trouble",
					-- require("faith.plugins.statusline.extensions.nvim-dap-ui").setup({
					-- 	active_separator = ">",
					-- 	inactive_separator = "|",
					-- }),
				},
			}

			return opts
		end,
	},
}
