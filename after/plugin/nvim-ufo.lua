local status_ok, ufo = pcall(require, 'ufo')
if not status_ok then
	return
end

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldopen:remove('hor') -- don't open folds when moving on the line
-- vim.opt.foldcolumn = '1'
-- vim.opt.fillchars = [[foldopen:,foldsep:│,foldclose:]]
vim.opt.fillchars = [[foldopen:,foldsep: ,foldclose:]]
-- vim.opt.fillchars = [[foldopen:,foldsep:│,foldclose:]]
-- vim.opt.fillchars = [[foldopen:,foldsep: ,foldclose:]]
vim.opt.foldnestmax = 1
vim.opt.foldenable = true

--[[ -- requires PR #17446
vim.opt.foldoptions = "nodigits"
local group = vim.api.nvim_create_augroup("fold_numbers", {})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = "*",
	callback = function()
		vim.wo.foldoptions = "nodigits"
	end,
	group = group
}) ]]

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}

	local suffix = ('  %d '):format(endLnum - lnum)
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
				suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, 'MoreMsg' })
	return newVirtText
end

local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'zR', require('ufo').openAllFolds, opts)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, opts)
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, opts)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, opts) -- closeAllFolds == closeFoldsWith(0)

ufo.setup({
	open_fold_hl_timeout = 0,
	preview = {
		win_config = {
			border = { '', '─', '', '', '', '─', '', '' },
			winhighlight = 'Normal:Folded',
			winblend = 0
		},
		mappings = {
			scrollU = '<C-u>',
			scrollD = '<C-d>'
		}
	},
	provider_selector = function(--[[ bufnr, filetype, buftype ]])
		return { 'treesitter', 'indent' }
	end,
	fold_virt_text_handler = handler
})
