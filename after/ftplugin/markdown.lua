local indentWidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = indentWidth -- Change the number of space characters inserted for indentation
vim.opt_local.textwidth = 80
vim.opt_local.conceallevel = 2
vim.opt_local.colorcolumn = "0"

vim.opt_local.formatoptions = {
	t = true, -- auto wrap
	c = true, -- auto wrap comments, insert comment leader
	r = true, -- auto insert comment on enter in insert
	w = false, -- trailing white indicates paragraph continues
	a = false, -- auto format paragraphs
	n = true, -- recognize numbered lists
	j = true, -- remove comment leader when joining
	l = true, -- longlines not broken in insert
}

vim.api.nvim_create_augroup("markdown_format", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = "markdown_format",
	pattern = "*.md",
	callback = function(ctx)
		vim.api.nvim_cmd(
			{ cmd = "normal", bang = true, args = { "m'" } },
			{ output = false }
		)

		vim.api.nvim_cmd({
			cmd = "vglobal",
			args = {
				"/^|\\|\\[\\[.*\\]\\]\\|\\[.*\\](.*)\\|\\[\\^[^]]\\+\\]/normal gww",
			},
		}, { output = false })

		vim.api.nvim_cmd(
			{ cmd = "normal", bang = true, args = { "`'" } },
			{ output = false }
		)
	end,
})

vim.cmd(
	'let g:mkdp_images_path = "'
		.. string.gsub(vim.fn.getcwd(), "\\", "/")
		.. '/"'
)

vim.keymap.set({ "n", "v" }, "<localleader>ls", function()
	if vim.fn.mode() == "v" then
		vim.api.nvim_cmd({ cmd = "normal", args = { "2S]" } }, { output = false })
	else
		vim.api.nvim_cmd(
			{ cmd = "normal", args = { "2ysiw]" } },
			{ output = false }
		)
	end
end, {
	buffer = true,
	desc = "[l]ink [s]urround: Create link to text under cursor or selection.",
})
vim.keymap.set("n", "<localleader>ld", function()
	vim.api.nvim_cmd({ cmd = "normal", args = { "2ds]" } }, { output = false })
end, { buffer = true, desc = "[l]ink [d]elete: Unlink text under cursor." })

require("ibl").setup_buffer(0, { indent = { char = "▕" } })

vim.keymap.set({ "n" }, "<leader>z", function()
	Snacks.zen.zen({
		toggles = {
			dim = false,
			gitsigns = false,
		},
		show = {
			statusline = false,
			tabline = false,
		},
		on_open = function(win)
			vim.wo[win.win].foldcolumn = "0"
			vim.wo[win.win].signcolumn = "no"
		end,
	})
end)

vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("markdown_image_hover", { clear = true }),
	buffer = vim.api.nvim_get_current_buf(),
	callback = function()
		Snacks.image.hover()
	end,
})
