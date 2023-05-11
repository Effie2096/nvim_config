local has_nvimtree, nvim_tree = pcall(require, "nvim-tree")
if not has_nvimtree then
	return
end

local icons = require("faith.icons")

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local desc = fk.desc

local opts = { noremap = true, silent = true }
nnoremap("<leader>ef", "<cmd>NvimTreeToggle<CR>", desc(opts, "[e]dit [f]iles: toggle file tree viewer."))

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
	renderer = {
		group_empty = true,
		indent_markers = {
			enable = true,
		},
	},
	view = {
		hide_root_folder = true,
		width = 49,
	},
	float = {
		enable = true,
	},
	filters = {
		dotfiles = false,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
		debounce_delay = 50,
		severity = {
			min = vim.diagnostic.severity.HINT,
			max = vim.diagnostic.severity.ERROR,
		},
		icons = {
			hint = icons.diagnostic.hint,
			info = icons.diagnostic.info,
			warning = icons.diagnostic.warn,
			error = icons.diagnostic.error,
		},
	},
})

--[[ local function open_nvim_tree()
	require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree }) ]]
