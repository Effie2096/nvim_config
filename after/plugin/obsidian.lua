local has_obsidian, obsidian = pcall(require, "obsidian")
if not has_obsidian then
	return
end

local vaults_dir = os.getenv("HOME") .. "/Documents/Obsidian"

obsidian.setup({
	workspaces = {
		{
			name = "BrainFart",
			path = vaults_dir .. "/BrainFart",
		},
		{
			name = "DnD",
			path = vaults_dir .. "/DnD",
		},
	},
	notes_subdir = "Notes",
	new_notes_location = "notes_subdir",
	note_id_func = function(title)
		return title
	end,
	disable_frontmatter = true,
	mappings = {
		-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
		["gf"] = {
			action = function()
				return require("obsidian").util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
		-- Toggle check-boxes.
		["<leader>oc"] = {
			action = function()
				return require("obsidian").util.toggle_checkbox()
			end,
			opts = { buffer = true, desc = "[o]bsidian [c]heckbox: Toggle checkbox." },
		},
		["<leader>oo"] = {
			action = function()
				vim.api.nvim_cmd({ cmd = "ObsidianOpen" }, { output = false })
			end,
			opts = { buffer = true, desc = "[o]bsidian [o]pen: Open current note in Obsidian app." },
		},
		["<leader>on"] = {
			action = function()
				vim.api.nvim_cmd({ cmd = "ObsidianNew" }, { output = false })
			end,
			opts = { buffer = true, desc = "[o]bsidian [n]ew: Create new note." },
		},
		["<leader>oq"] = {
			action = function()
				vim.api.nvim_cmd({ cmd = "ObsidianQuickSwitch" }, { output = false })
			end,
			opts = { buffer = true, desc = "[o]bsidian [q]uickswitch: Switch to note." },
		},
		["<leader>ob"] = {
			action = function()
				vim.api.nvim_cmd({ cmd = "ObsidianBacklinks" }, { output = false })
			end,
			opts = { buffer = true, desc = "[o]bsidian [b]acklinks: Search references to current note." },
		},
		["<leader>ol"] = {
			action = function()
				vim.api.nvim_cmd({ cmd = "ObsidianLinks" }, { output = false })
			end,
			opts = { buffer = true, desc = "[o]bsidian [l]inks: List all links in current note." },
		},
		["<leader>os"] = {
			action = function()
				vim.api.nvim_cmd({ cmd = "ObsidianSearch" }, { output = false })
			end,
			opts = { buffer = true, desc = "[o]bsidian [s]earch: Swearch (or create) note." },
		},
		["<leader>ot"] = {
			action = function()
				vim.api.nvim_cmd({ cmd = "ObsidianTemplate" }, { output = false })
			end,
			opts = { buffer = true, desc = "[o]bsidian [t]emplate: Insert template from templates folder." },
		},
	},
	-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
	completion = {
		-- Set to false to disable completion.
		nvim_cmp = true,
		-- Trigger completion at 2 chars.
		min_chars = 2,
	},
	-- Optional, customize how wiki links are formatted. You can set this to one of:
	--	* "use_alias_only", e.g. '[[Foo Bar]]'
	--	* "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
	--	* "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
	--	* "use_path_only", e.g. '[[foo-bar.md]]'
	wiki_link_func = "prepend_note_path",
	-- Optional, for templates (see below).
	templates = {
		subdir = "_System/Templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
		-- A map for custom variables, the key should be the variable and the value a function
		substitutions = {},
	},
	attachments = {
		img_folder = "Attachments",
		-- A function that determines the text to insert in the note when pasting an image.
		-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
		-- This is the default implementation.
		img_text_func = function(client, path)
			path = client:vault_relative_path(path) or path
			return string.format("![%s](%s)", path.name, path)
		end,
	},
	ui = {
		enable = true, -- set to false to disable all additional syntax features
		update_debounce = 200, -- update delay after a text change (in milliseconds)
		-- Define how various check-boxes are displayed
		checkboxes = {
			[" "] = { char = "󰄱 ", hl_group = "ObsidianTodo" },
			["x"] = { char = " ", hl_group = "ObsidianDone" },
			[">"] = { char = " ", hl_group = "ObsidianRightArrow" },
			["~"] = { char = "󰰱 ", hl_group = "ObsidianTilde" },
			-- Replace the above with this if you don't have a patched font:
			-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
			-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

			-- You can also add more custom ones...
		},
		-- Use bullet marks for non-checkbox lists.
		bullets = { char = "•", hl_group = "ObsidianBullet" },
		external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
		-- Replace the above with this if you don't have a patched font:
		-- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
		reference_text = { hl_group = "ObsidianRefText" },
		highlight_text = { hl_group = "ObsidianHighlightText" },
		tags = { hl_group = "ObsidianTag" },
		block_ids = { hl_group = "ObsidianBlockID" },
		hl_groups = {
			-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
			ObsidianTodo = { bold = true, fg = "#f78c6c" },
			ObsidianDone = { bold = true, fg = "#89ddff" },
			ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
			ObsidianTilde = { bold = true, fg = "#ff5370" },
			ObsidianBullet = { bold = true, fg = "#89ddff" },
			ObsidianRefText = { underline = true, fg = "#c792ea" },
			ObsidianExtLinkIcon = { fg = "#c792ea" },
			ObsidianTag = { italic = true, fg = "#89ddff" },
			ObsidianBlockID = { italic = true, fg = "#89ddff" },
			ObsidianHighlightText = { bg = "#75662e" },
		},
	},
})
