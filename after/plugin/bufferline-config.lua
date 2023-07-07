local has_bufferline, bufferline = pcall(require, "bufferline")
if not has_bufferline then
	return
end

local icons = require("faith.icons")

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap

local jump_keymaps = function()
	local opts = { noremap = true, silent = true }
	for i = 1, 9, 1 do
		nnoremap("<leader>" .. i, "<cmd>lua require('bufferline').go_to(" .. i .. ", true)<CR>", opts)
	end
	nnoremap("<leader>$", "<cmd>lua require('bufferline').go_to(-1, true)<CR>", opts)
end
jump_keymaps()

bufferline.setup({
	options = {
		always_show_bufferline = false,
		mode = "buffers",
		numbers = function(opts)
			return string.format("%s", opts.ordinal)
		end,
		themable = true,
		right_mouse_command = false,
		separator_style = "thin",
		-- diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		show_close_icon = false,
		show_buffer_close_icons = false,
		show_tab_indicators = true,
		max_name_length = 30,
		--[[ name_formatter = function(buf)
			return string.format("%s %s", buf.tabnr, buf.name)
		end, ]]
		offsets = {
			{
				filetype = "NvimTree",
				text = function()
					return string.format("%s %s", icons.ui.Project, vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t"))
				end,
				highlight = "Directory",
				text_align = "left",
				separator = string.format("%s", vim.opt.fillchars:get().vert),
			},
		},
	},
	highlights = require("catppuccin.groups.integrations.bufferline").get(),
})
