local icons = require("faith.icons")

return {
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		init = function()
			-- needs to be high for ufo
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99

			vim.opt.foldopen:remove("hor") -- don't open folds when moving on the line
			vim.opt.foldcolumn = "1"
			vim.opt.fillchars:append({
				foldopen = icons.ui.ArrowOpen,
				foldsep = " ",
				foldclose = icons.ui.ArrowClosed,
			})
			vim.opt.foldnestmax = 1
			vim.opt.foldenable = true

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"neo-tree",
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_console",
					"dapui_stacks",
					"dapui_scopes",
					"dap-repl",
				},
				callback = function()
					require("ufo").detach()
					vim.opt_local.foldenable = false
				end,
			})
		end,
		config = function()
			local ufo = require("ufo")

			local ftMap = {
				markdown = { "treesitter", "indent" },
			}

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local line_count = endLnum - lnum
				local fold_lines = ("(%d line%s)"):format(
					line_count,
					line_count > 1 and "s" or ""
				)
				local suffix = (" %s%s "):format(icons.ui.FoldSuffix, fold_lines)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						table.insert(newVirtText, chunk)
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			local function goPreviousClosedAndPeek()
				require("ufo").goPreviousClosedFold()
				require("ufo").peekFoldedLinesUnderCursor()
			end

			local function goNextClosedAndPeek()
				require("ufo").goNextClosedFold()
				require("ufo").peekFoldedLinesUnderCursor()
			end

			local opts = { noremap = true, silent = true }
			vim.keymap.set(
				{ "n" },
				"zR",
				require("ufo").openAllFolds,
				vim.tbl_extend("force", opts, { desc = "fold [R]educe all" })
			)
			vim.keymap.set(
				{ "n" },
				"zM",
				require("ufo").closeAllFolds,
				vim.tbl_extend("force", opts, { desc = "fold [M]ax" })
			)
			vim.keymap.set(
				{ "n" },
				"zr",
				require("ufo").openFoldsExceptKinds,
				vim.tbl_extend("force", opts, { desc = "fold [r]educe" })
			)
			vim.keymap.set(
				{ "n" },
				"zm",
				require("ufo").closeFoldsWith,
				vim.tbl_extend("force", opts, { desc = "fold [m]ore" })
			) -- closeAllFolds == closeFoldsWith(0)
			vim.keymap.set(
				{ "n" },
				"zj",
				goNextClosedAndPeek,
				vim.tbl_extend("force", opts, { desc = "fold next" })
			)
			vim.keymap.set(
				{ "n" },
				"zk",
				goPreviousClosedAndPeek,
				vim.tbl_extend("force", opts, { desc = "fold previous" })
			)

			ufo.setup({
				open_fold_hl_timeout = 100,
				close_fold_kinds_for_ft = {
					default = { "imports", "comment" },
					json = { "array" },
					c = { "comment", "region" },
					java = { "import_declaration", "line_comment" },
				},
				preview = {
					win_config = {
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
						winhighlight = "Normal:Folded",
						winblend = 0,
					},
					mappings = {
						scrollU = "<C-u>",
						scrollD = "<C-d>",
					},
				},
				provider_selector = function(
					_ --[[ bufnr ]],
					filetype,
					_ --[[ buftype ]]
				)
					return ftMap[filetype] or { "treesitter", "indent" }
				end,
				enable_get_fold_virt_text = true,
				fold_virt_text_handler = handler,
			})
		end,
	},
}
