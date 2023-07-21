local has_nvimtree, nvim_tree = pcall(require, "nvim-tree")
if not has_nvimtree then
	return
end

local icons = require("faith.icons")

local fk = require("faith.keymap")
local nnoremap = fk.nnoremap
local desc = fk.desc

local opts = { noremap = true, silent = true }
nnoremap(
	"<leader>ef",
	"<cmd>lua require('nvim-tree.api').tree.toggle({find_file=true})<cr>",
	desc(opts, "[e]dit [f]iles: toggle file tree viewer.")
)

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local api = require("nvim-tree.api")

local function edit_or_open()
	local node = api.tree.get_node_under_cursor()

	if node.nodes ~= nil then
		-- expand or collapse folder
		api.node.open.edit()
	else
		-- open file
		api.node.open.edit()
		-- Close the tree if file was opened
		api.tree.close()
	end
end

-- open as vsplit on current node
local function split_preview(direction)
	local node = api.tree.get_node_under_cursor()

	if node.nodes ~= nil then
		-- expand or collapse folder
		api.node.open.edit()
	else
		if direction == "h" then
			-- open file in split
			api.node.open.horizontal()
		elseif direction == "v" then
			-- open file as vsplit
			api.node.open.vertical()
		end
	end

	-- Finally refocus on tree if it was lost
	api.tree.focus()
end

local function tree_on_attach(bufnr)
	local function tree_options(description)
		return { desc = "nvim-tree: " .. description, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set("n", "<CR>", api.node.open.tab_drop, tree_options("Tab drop"))

	vim.keymap.set("n", "l", edit_or_open, tree_options("Edit Or Open"))
	vim.keymap.set("n", "J", function()
		split_preview("h")
	end, tree_options("Split Preview"))
	vim.keymap.set("n", "L", function()
		split_preview("v")
	end, tree_options("Vsplit Preview"))
	vim.keymap.set("n", "h", api.node.navigate.parent_close, tree_options("Close"))
	vim.keymap.set("n", "H", api.tree.collapse_all, tree_options("Collapse All"))
end

nvim_tree.setup({
	on_attach = tree_on_attach,
	renderer = {
		group_empty = true,
		indent_markers = {
			enable = true,
		},
		root_folder_label = false,
	},
	view = {
		width = 40,
	},
	filters = {
		custom = { "^.git$" },
		dotfiles = false,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = false,
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
	modified = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = false,
	},
})

local has_lsp_file_operations, lsp_file_operations = pcall(require, "lsp-file-operations")
if has_lsp_file_operations then
	lsp_file_operations.setup()
end
--[[ local function open_nvim_tree()
	require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree }) ]]
