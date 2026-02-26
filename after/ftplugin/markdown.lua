local icons = require("faith.icons")
local indent_width = 2
local indent_icon = "▐"
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = indent_width -- Change the number of space characters inserted for indentation
vim.opt_local.textwidth = 80
vim.opt_local.conceallevel = 2
vim.opt_local.colorcolumn = "0"

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_gb"

vim.opt_local.formatoptions = {
	t = false, -- auto wrap
	c = true, -- auto wrap comments, insert comment leader
	r = true, -- auto insert comment on enter in insert
	w = false, -- trailing white indicates paragraph continues
	a = false, -- auto format paragraphs
	n = true, -- recognize numbered lists
	j = true, -- remove comment leader when joining
	l = true, -- longlines not broken in insert
}

vim.opt_local.linebreak = true
vim.opt_local.showbreak = indent_icon
	.. (string.rep(" ", (indent_width - 1) or 0) or "")
vim.opt_local.breakat = " ^!@;:,./?([{<>"
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = { "shift:0" }

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

-- vim.api.nvim_create_augroup("markdown_format", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 	group = "markdown_format",
-- 	pattern = "*.md",
-- 	callback = function(ctx)
-- 		vim.api.nvim_cmd(
-- 			{ cmd = "normal", bang = true, args = { "m'" } },
-- 			{ output = false }
-- 		)

-- 		vim.api.nvim_cmd({
-- 			cmd = "vglobal",
-- 			args = {
-- 				"/^|\\|\\[\\[.*\\]\\]\\|\\[.*\\](.*)\\|\\[\\^[^]]\\+\\]/normal gww",
-- 			},
-- 		}, { output = false })

-- 		vim.api.nvim_cmd(
-- 			{ cmd = "normal", bang = true, args = { "`'" } },
-- 			{ output = false }
-- 		)
-- 	end,
-- })

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

require("ibl").setup_buffer(0, { indent = { char = indent_icon } })

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
			vim.wo[win.win].statuscolumn = ""
			vim.wo[win.win].signcolumn = "no"
			vim.wo[win.win].relativenumber = false
			vim.wo[win.win].number = false
			vim.wo[win.win].winbar = ""
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
