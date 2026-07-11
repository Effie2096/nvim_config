vim.pack.add(
	{ { src = "https://github.com/mbbill/undotree" } },
	{ load = false }
)

local function config()
	vim.g.undotree_WindowLayout = 3
	vim.g.undotree_SplitWidth = 70
	vim.g.undotree_DiffpanelHeight = 20
	vim.g.undotree_SetFocusWhenToggle = 1
	vim.g.undotree_Helpline = 0

	vim.g.undotree_DiffCommand = "git diff"
end

local function load()
	if vim.g.loaded_undotree == 1 then
		return
	end

	vim.cmd.packadd("undotree")

	config()
end

local map_cb = function(cb)
	load()
	return function()
		cb()
	end
end

vim.keymap.set(
	{ "n" },
	"<leader>u",
	map_cb(vim.cmd.UndotreeToggle),
	{ desc = "[u]ndo tree: Open undo history for current file." }
)
