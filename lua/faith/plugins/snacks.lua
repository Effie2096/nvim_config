local sn = require("snacks")
local util = require("snacks.util")
local supported = sn.image.supports()

---@type snacks.Config
local opts = {
	image = {
		enabled = true,
		force = false,
		img_dirs = {
			"img",
			"images",
			"assets",
			"static",
			"public",
			"media",
			"Attachments",
		},
		-- resolve = function(path, src)
		-- 	local api = require("obsidian.api")
		-- 	if api.path_is_note(path) then
		-- 		return api.resolve_attachment_path(src)
		-- 	end
		-- end,
		doc = {
			-- enable image viewer for documents
			-- a treesitter parser must be available for the enabled languages.
			enabled = true,
			-- render the image inline in the buffer
			-- if your env doesn't support unicode placeholders, this will be disabled
			-- takes precedence over `opts.float` on supported terminals
			inline = true,
			-- render the image in a floating window
			-- only used if `opts.inline` is disabled
			float = supported,
			max_width = 78,
			max_height = 30,
			-- Set to `true`, to conceal the image text when rendering inline.
			-- (experimental)
			---@param lang string tree-sitter language
			---@param type snacks.image.Type image type
			conceal = function(lang, type)
				-- only conceal math expressions
				return type == "math"
			end,
		},
	},
	dim = { enabled = false },
	bigfile = { enabled = false },
	bufdelete = { enable = false },
	dashboard = { enabled = false },
	explorer = { enabled = false },
	indent = { enabled = false },
	input = { enabled = false },
	picker = { enabled = false },
	notifier = { enabled = false },
	quickfile = { enabled = false },
	scope = { enabled = false },
	scroll = { enabled = false },
	statuscolumn = { enabled = false },
	words = { enabled = false },
	toggle = { enabled = true },
	scratch = { enabled = false },
	zen = { enabled = false },
	styles = {
		snacks_image = {
			relative = "editor",
			border = true,
			focusable = false,
			backdrop = false,
			-- row = 1,
			col = -1,
			-- width/height are automatically set by the image size unless specified below
			-- bufpos = { 0, 0 },
		},
		input = {
			relative = "editor",
		},
		zoom_indicator = {
			text = " ",
			minimal = true,
			enter = false,
			focusable = false,
			height = 1,
			row = 0,
			col = function()
				return math.floor((vim.opt.columns:get() - 1) / 2)
			end,
			backdrop = false,
		},
		scratch = {
			ft = "markdown",
			position = "right",
			width = function()
				local width = math.floor((vim.opt.columns:get() * 0.35))
				return width < 50 and 50 or width
			end,
			height = function()
				local height = math.floor((vim.opt.lines:get() * 0.3))
				return height < 10 and 10 or height
			end,
		},
	},
}
sn.setup(opts)

Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle
	.option("relativenumber", { name = "Relative Number" })
	:map("<leader>ul")
Snacks.toggle
	.option("background", {
		off = "light",
		on = "dark",
		name = "Dark Background",
	})
	:map("<leader>ub")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle
	.option("conceallevel", {
		off = 0,
		on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
	})
	:map("<leader>uc")

vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions[1].type == "move" then
			Snacks.rename.on_rename_file(
				event.data.actions[1].src_url,
				event.data.actions[1].dest_url
			)
		end
	end,
})
