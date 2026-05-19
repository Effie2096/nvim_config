local indent_width = 2
local indent_icon = "▐"
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = indent_width -- Change the number of space characters inserted for indentation
vim.opt_local.textwidth = 0
vim.opt_local.wrapmargin = 0
vim.opt_local.conceallevel = 2
vim.opt_local.colorcolumn = "0"

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_gb"

vim.opt_local.formatoptions:remove("t") -- auto wrap
vim.opt_local.formatoptions:append("c") -- auto wrap comments, insert comment leader
vim.opt_local.formatoptions:append("r") -- auto insert comment on enter in insert
vim.opt_local.formatoptions:remove("w") -- trailing white indicates paragraph continues
vim.opt_local.formatoptions:remove("a") -- auto format paragraphs
vim.opt_local.formatoptions:append("n") -- recognize numbered lists
vim.opt_local.formatoptions:append("j") -- remove comment leader when joining
vim.opt_local.formatoptions:append("l") -- longlines not broken in insert

-- vim.api.nvim_exec2([[iabbrev <buffer> - –]], { output = false })
vim.api.nvim_exec2([[iabbrev <buffer> -- —]], { output = false })

vim.opt_local.linebreak = true
vim.opt_local.showbreak = indent_icon
	.. (string.rep(" ", (indent_width - 1) or 0) or "")
vim.opt_local.breakindent = true
vim.opt.breakat = " ^!@;:,./?([{<>–—"

-- join checkbox lines like joining comments with formatoptions+=j
vim.keymap.set("n", "J", function()
	local line = vim.api.nvim_get_current_line()
	local next = vim.api.nvim_buf_get_lines(
		0,
		vim.fn.line("."),
		vim.fn.line(".") + 1,
		false
	)[1]
	local pattern = "^%s*[-*+] %b[]%s+"

	local is_checklist = next:match(pattern)
	next = next:gsub(pattern, "")

	vim.cmd("normal! J")
	if is_checklist then
		vim.api.nvim_set_current_line(("%s %s"):format(line, next))
	end
end, { buffer = true })

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
				"/^|\\|\\[\\[.*\\]\\]\\|\\[.*\\](.*)\\|\\[\\^[^]]\\+\\]/normal gqq",
			},
		}, { output = false })

		vim.api.nvim_cmd(
			{ cmd = "normal", bang = true, args = { "`'" } },
			{ output = false }
		)

		vim.api.nvim_cmd(
			{ cmd = "normal", bang = true, args = { "zz" } },
			{ output = false }
		)
	end,
})

local opts = { silent = true, buffer = true, noremap = true }
-- swap wrap navigation mappings
vim.keymap.set({ "n", "v" }, "$", "g$", opts)
vim.keymap.set({ "n", "v" }, "0", "g0", opts)
vim.keymap.set({ "n" }, "<Home>", "g<Home>", opts)
vim.keymap.set({ "n" }, "<End>", "g<End>", opts)
vim.keymap.set({ "n", "v" }, "g0", "0", opts)
vim.keymap.set({ "n", "v" }, "g$", "$", opts)

vim.keymap.set({ "i" }, "<Home>", "<C-o>g<Home>", opts)
vim.keymap.set({ "i" }, "<End>", "<C-o>g<End>", opts)
vim.keymap.set({ "n", "v" }, "j", "gj", opts)
vim.keymap.set({ "n", "v" }, "k", "gk", opts)
vim.keymap.set({ "n" }, "<Up>", "gk", opts)
vim.keymap.set({ "n" }, "<Down>", "gj", opts)
vim.keymap.set({ "n", "v" }, "gj", "j", opts)
vim.keymap.set({ "n", "v" }, "gk", "k", opts)

-- undo "checkpoints" at punctuation
vim.keymap.set({ "i" }, ".", ".<c-g>u", opts)
vim.keymap.set({ "i" }, "!", "!<c-g>u", opts)
vim.keymap.set({ "i" }, "?", "?<c-g>u", opts)
vim.keymap.set({ "i" }, ",", ",<c-g>u", opts)
vim.keymap.set({ "i" }, ";", ";<c-g>u", opts)
vim.keymap.set({ "i" }, ":", ":<c-g>u", opts)
vim.keymap.set({ "i" }, "<c-u>", "<c-g>u<c-u>", opts)
vim.keymap.set({ "i" }, "<c-w>", "<c-g>u<c-w>", opts)

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

vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("markdown_image_hover", { clear = true }),
	buffer = vim.api.nvim_get_current_buf(),
	callback = function()
		Snacks.image.hover()
	end,
})
