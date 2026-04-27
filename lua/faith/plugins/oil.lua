local icons = require("faith.icons")

local oil = require("oil")
---@module 'oil'
---@type oil.SetupOpts
local opts = {
	win_options = {
		signcolumn = "yes:1",
	},
	delete_to_trash = true,
	columns = {
		"icon",
		"size",
		"mtime",
	},
	-- Set to false to disable all of the below keymaps
	use_default_keymaps = false,
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-x>"] = { "actions.select", opts = { horizontal = true } },
		["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-p>"] = function()
			require("oil.actions").preview.callback()
			vim.defer_fn(function()
				vim
					.iter(vim.api.nvim_tabpage_list_wins(0))
					:filter(vim.api.nvim_win_is_valid)
					:filter(function(v)
						return vim.wo[v].previewwindow
					end)
					:filter(function(v)
						return vim.w[v]["oil_preview"]
					end)
					:each(function(v)
						vim.wo[v].winfixwidth = true
					end)
			end, 50)
		end,
		["<C-c>"] = { "actions.close", mode = "n" },
		["<C-l>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
		["<leader>p"] = function()
			local filename = oil.get_cursor_entry().name
			local dir = oil.get_current_dir()
			oil.close()

			local img_clip = require("img-clip")
			img_clip.paste_image({}, dir .. filename)
		end,
	},
	-- Configuration for the floating window in oil.open_float
	float = {
		-- Padding around the floating window
		padding = 0,
		-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		max_width = 0.8,
		max_height = 0.8,
		border = {
			{ icons.borders.edge_thin.bottom, "Float" },
			{ icons.borders.edge_thin.bottom, "Float" },
			{ icons.borders.edge_thin.bottom, "Float" },
			icons.borders.edge_thin.right,
			icons.borders.edge_thin.bottom_right,
			icons.borders.edge_thin.bottom,
			icons.borders.edge_thin.bottom_left,
			icons.borders.edge_thin.left,
		},
		win_options = {
			winblend = 0,
			winhighlight = "FoldColumn:Float,SignColumn:Float,CursorLineNr:CursorLine,LineNr:Float,LineNrAbove:Float,LineNrBelow:Float,FloatTitle:Float",
		},
		-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
		get_win_title = nil,
		-- preview_split: Split direction: "auto", "left", "right", "above", "below".
		preview_split = "auto",
		-- This is the config that will be passed to nvim_open_win.
		-- Change values here to customize the layout
		override = function(conf)
			return conf
		end,
	},
}
oil.setup(opts)

vim.keymap.set(
	{ "n" },
	"<leader>O",
	require("oil").toggle_float,
	{ desc = "[O]il" }
)
