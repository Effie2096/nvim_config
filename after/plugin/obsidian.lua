local has_obsidian, obsidian = pcall(require, "obsidian")
if not has_obsidian then
	return
end

local vaults_dir = os.getenv("HOME") .. "/Documents/Obsidian"
if vim.fn.has("win32") == 1 then
	vaults_dir = "E:\\Documents\\Obsidian"
end

local get_vaults = function()
	local vaults = {}
	for dir in
		io.popen(
			vim.fn.has("win32" == 1) and [[dir ]] .. vaults_dir .. [[ /b]]
				or [[ls -pa ]] .. vaults_dir .. [[ | grep -v /]]
		):lines()
	do
		if dir:sub(1, 1) ~= "." then
			table.insert(vaults, { name = dir, path = vaults_dir .. "/" .. dir })
		end
	end
	return vaults
end

local workspaces = vim.tbl_extend(
	"keep",
	get_vaults(),
	-- support markdown files outside of actual vaults
	{
		{
			name = "no-vault",
			path = function()
				-- alternatively use the CWD:
				-- return assert(vim.fn.getcwd())
				return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
			end,
			overrides = {
				notes_subdir = vim.NIL, --
				--have to use 'vim.NIL' instead of 'nil'
				new_notes_location = "current_dir",
				templates = {
					folder = vim.NIL,
				},
				disable_frontmatter = true,
			},
		},
	}
)

vim.keymap.set("n", "<leader>on", function()
	vim.api.nvim_cmd({ cmd = "ObsidianNew" }, { output = false })
end, { desc = "[o]bsidian [n]ew: Create new note." })
vim.keymap.set("n", "<leader>oq", function()
	vim.api.nvim_cmd({ cmd = "ObsidianQuickSwitch" }, { output = false })
end, { desc = "[o]bsidian [q]uickswitch: Switch to note." })
vim.keymap.set("n", "<leader>os", function()
	vim.api.nvim_cmd({ cmd = "ObsidianSearch" }, { output = false })
end, { desc = "[o]bsidian [s]earch: Swearch (or create) note." })

obsidian.setup({
	workspaces = workspaces,
	notes_subdir = "Notes/inbox",
	-- Where to put new notes. Valid options are
	--  * "current_dir" - put new notes in same directory as the current buffer.
	--  * "notes_subdir" - put new notes in the default notes subdirectory.
	new_notes_location = "notes_subdir",
	note_id_func = function(title)
		-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
		-- In this case a note with the title 'My new note' will be given an ID that looks
		-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
		--[[ local suffix = ""
		if title ~= nil then
			-- If title is given, transform it into valid file name.
			suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			-- If title is nil, just add 4 random uppercase letters to the suffix.
			for _ = 1, 4 do
				suffix = suffix .. string.char(math.random(65, 90))
			end
		end ]]
		return tostring(os.date("%Y%m%d%H%M", os.time())) -- .. "-" .. suffix
	end,

	-- Optional, customize how note file names are generated given the ID, target directory, and title.
	---@diagnostic disable-next-line: undefined-doc-name
	---@param spec { id: string, dir: obsidian.Path, title: string|? }
	---@diagnostic disable-next-line: undefined-doc-name
	---@return string|obsidian.Path The full path to the new note.
	note_path_func = function(spec)
		local suffix = ""
		if spec.title ~= nil then
			-- If title is given, transform it into valid file name.
			suffix = spec.title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			-- If title is nil, just add 4 random uppercase letters to the suffix.
			for _ = 1, 4 do
				suffix = suffix .. string.char(math.random(65, 90))
			end
		end
		local path = spec.dir / suffix
		return path:with_suffix(".md")
	end,
	disable_frontmatter = false,
	daily_notes = {
		-- Optional, if you keep daily notes in a separate directory.
		folder = "Notes/Daily",
		-- Optional, if you want to change the date format for the ID of daily notes.
		-- date_format = "%Y-%m-%d",
		-- Optional, if you want to change the date format of the default alias of daily notes.
		-- alias_format = "%B %-d, %Y",
		-- Optional, default tags to add to each new daily note created.
		default_tags = { "daily-notes" },
		-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
		template = "daily.md",
	},
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
		tags = { hl_group = "ObsidianTagCustom" },
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
