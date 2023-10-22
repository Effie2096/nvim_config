local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
	return
end

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap

local icons = require("faith.icons")

-- needs to be high for ufo
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.foldopen:remove("hor") -- don't open folds when moving on the line
vim.opt.foldcolumn = "1"
vim.opt.fillchars:append({ foldopen = icons.ui.ArrowOpen, foldsep = " ", foldclose = icons.ui.ArrowClosed })
vim.opt.foldnestmax = 1
vim.opt.foldenable = true

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}

	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
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

			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
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
nnoremap("zR", require("ufo").openAllFolds, opts)
nnoremap("zM", require("ufo").closeAllFolds, opts)
nnoremap("zr", require("ufo").openFoldsExceptKinds, opts)
nnoremap("zm", require("ufo").closeFoldsWith, opts) -- closeAllFolds == closeFoldsWith(0)
nnoremap("zj", goNextClosedAndPeek, opts)
nnoremap("zk", goPreviousClosedAndPeek, opts)

ufo.setup({
	open_fold_hl_timeout = 100,
	preview = {
		win_config = {
			border = { "", icons.borders.square.top, "", "", "", icons.borders.square.bottom, "", "" },
			winhighlight = "Normal:Folded",
			winblend = 0,
		},
		mappings = {
			scrollU = "<C-u>",
			scrollD = "<C-d>",
		},
	},
	provider_selector = function(--[[ bufnr, filetype, buftype ]])
		return { "treesitter", "indent" }
	end,
	enable_get_fold_virt_text = true,
	fold_virt_text_handler = handler,
})
