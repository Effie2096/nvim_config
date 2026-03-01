local components =
	require("faith.plugins.statusline.lualine.components").components()

local sections = {
	lualine_a = { "trans_flag" },
	lualine_b = {
		components.resession,
		components.root,
		components.branch,
	},
	lualine_c = {
		components.diagnostics_ws,
		components.git_conflict,

		components.language_server,

		components.lint_progress,
		components.asyncrun,
		components.overseer,

		{ "%=" },
		components.obsidian,
	},
	lualine_x = {
		-- buffers,
		components.format_on_save,
		components.show_macro_recording,
		components.search_count,
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
		components.filepath,
		components.filetype,
		components.filename,
	},
	lualine_c = {
		components.breadcrumbs,
	},
	lualine_x = {
		components.location,
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
		dependencies = { "dev_icons" },
		event = "VeryLazy",
		priority = 900, -- Load right after colorschemes/highlights set
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
