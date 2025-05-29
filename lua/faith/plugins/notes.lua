local icons = require("faith.icons")

return {
	{
		"3rd/image.nvim",
		enabled = false,
		build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
		opts = {
			processor = "magick_rock",
			hijack_file_patterns = {
				"*.png",
				"*.jpg",
				"*.jpeg",
				"*.gif",
				"*.webp",
				"*.bmp",
			}, -- render image files as images when opened
			max_height = 15,
			window_overlap_clear_enabled = true,
			integrations = {
				markdown = {
					only_render_image_at_cursor = true,
					resolve_image_path = function(
						document_path,
						image_path,
						fallback
					)
						local cwd = vim.fn.getcwd()
						if vim.fn.filereadable(cwd .. "/" .. image_path) then
							return cwd .. "/" .. image_path
						end
						return fallback(document_path, image_path)
					end,
				},
			},
		},
	},
	{
		"jmbuhr/otter.nvim",
		ft = { "markdown" },
		opts = {
			html = {
				enabled = true,
			},
			css = {
				enabled = true,
			},
			lsp = {
				hover = {
					border = {
						icons.borders.square.top_left,
						icons.borders.square.top,
						icons.borders.square.top_right,
						icons.borders.square.right,
						icons.borders.square.bottom_right,
						icons.borders.square.bottom,
						icons.borders.square.bottom_left,
						icons.borders.square.left,
					},
				},
			},
			verbose = {
				no_code_found = false,
			},
		},
		config = function()
			vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
				group = vim.api.nvim_create_augroup(
					"attach_otter",
					{ clear = true }
				),
				pattern = { "*.md" },
				callback = function()
					require("otter").activate()
				end,
			})
		end,
	},
	{
		"bullets-vim/bullets.vim",
		init = function()
			vim.g.bullets_enabled_file_types =
				{ "markdown", "text", "gitcommit" }
			vim.g.bullets_enable_in_empty_buffers = 0 -- default = 1
		end,
	},
	"godlygeek/tabular",
	{
		"Kicamon/markdown-table-mode.nvim",
		cmd = "Mtm",
		opts = {
			filetype = {
				"*.md",
			},
			options = {
				insert = true, -- when typing "|"
				insert_leave = true, -- when leaving insert
				pad_separator_line = false, -- add space in separator line
				alig_style = "default", -- default, left, center, right
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		build = vim.fn["mkdp#util#install"],
		ft = {
			"markdown",
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "markdown", "vim-plug" },
		opts = {
			file_types = { "markdown", "Avante" },
			render_modes = { "n", "i", "c" },
			heading = {
				-- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
				icons = { " " },
				border = true,
				-- border_virtual = true,
				-- width = "block",
				-- min_width = 80,
			},
			indent = {
				enabled = true,
				skip_heading = true,
				-- icon = " ",
			},
			bullet = {
				enabled = true,
			},
			checkbox = {
				enabled = true,
				unchecked = {
					icon = "󰄱",
					highlight = "RenderMarkdownUnchecked",
				},
				checked = {
					icon = "󰱒",
					highlight = "RenderMarkdownChecked",
				},
				custom = {
					cancelled = {
						raw = "[~]",
						rendered = "󰅘",
						highlight = "Comment",
						scope_highlight = "@markup.strikethrough",
					},
					paused = {
						raw = "[>]",
						rendered = "󰏦",
						highlight = "DiagnosticSignWarn",
					},
					urgent = {
						raw = "[^]",
						rendered = "",
						highlight = "DiagnosticSignError",
					},
					optional = {
						raw = "[?]",
						rendered = "",
						highlight = "DiagnosticSignInfo",
					},
				},
			},
			link = {
				enabled = true,
			},
			code = {
				width = "block",
				min_width = 78,
				left_pad = 2,
				language_pad = 2,
			},
			sign = {
				-- Turn on / off sign rendering.
				enabled = true,
				highlight = "RenderMarkdownSign",
			},
			-- paragraph = { left_margin = 0.5 },
			anti_conceal = {
				enabled = true,
			},
			win_options = {
				conceallevel = {
					rendered = 2,
				},
			},
			callout = {
				note = {
					raw = "[!NOTE]",
					rendered = "󰋽 Note",
					highlight = "RenderMarkdownInfo",
				},
				tip = {
					raw = "[!TIP]",
					rendered = "󰌶 Tip",
					highlight = "RenderMarkdownSuccess",
				},
				important = {
					raw = "[!IMPORTANT]",
					rendered = "󰅾 Important",
					highlight = "RenderMarkdownHint",
				},
				warning = {
					raw = "[!WARNING]",
					rendered = "󰀪 Warning",
					highlight = "RenderMarkdownWarn",
				},
				caution = {
					raw = "[!CAUTION]",
					rendered = "󰳦 Caution",
					highlight = "RenderMarkdownError",
				},
				-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
				abstract = {
					raw = "[!ABSTRACT]",
					rendered = "󰨸 Abstract",
					highlight = "RenderMarkdownInfo",
				},
				summary = {
					raw = "[!SUMMARY]",
					rendered = "󰨸 Summary",
					highlight = "RenderMarkdownInfo",
				},
				tldr = {
					raw = "[!TLDR]",
					rendered = "󰨸 Tldr",
					highlight = "RenderMarkdownInfo",
				},
				info = {
					raw = "[!INFO]",
					rendered = "󰋽 Info",
					highlight = "RenderMarkdownInfo",
				},
				todo = {
					raw = "[!TODO]",
					rendered = "󰗡 Todo",
					highlight = "RenderMarkdownInfo",
				},
				hint = {
					raw = "[!HINT]",
					rendered = "󰌶 Hint",
					highlight = "RenderMarkdownSuccess",
				},
				success = {
					raw = "[!SUCCESS]",
					rendered = "󰄬 Success",
					highlight = "RenderMarkdownSuccess",
				},
				check = {
					raw = "[!CHECK]",
					rendered = "󰄬 Check",
					highlight = "RenderMarkdownSuccess",
				},
				done = {
					raw = "[!DONE]",
					rendered = "󰄬 Done",
					highlight = "RenderMarkdownSuccess",
				},
				question = {
					raw = "[!QUESTION]",
					rendered = "󰘥 Question",
					highlight = "RenderMarkdownWarn",
				},
				help = {
					raw = "[!HELP]",
					rendered = "󰘥 Help",
					highlight = "RenderMarkdownWarn",
				},
				faq = {
					raw = "[!FAQ]",
					rendered = "󰘥 Faq",
					highlight = "RenderMarkdownWarn",
				},
				attention = {
					raw = "[!ATTENTION]",
					rendered = "󰀪 Attention",
					highlight = "RenderMarkdownWarn",
				},
				failure = {
					raw = "[!FAILURE]",
					rendered = "󰅖 Failure",
					highlight = "RenderMarkdownError",
				},
				fail = {
					raw = "[!FAIL]",
					rendered = "󰅖 Fail",
					highlight = "RenderMarkdownError",
				},
				missing = {
					raw = "[!MISSING]",
					rendered = "󰅖 Missing",
					highlight = "RenderMarkdownError",
				},
				danger = {
					raw = "[!DANGER]",
					rendered = "󱐌 Danger",
					highlight = "RenderMarkdownError",
				},
				error = {
					raw = "[!ERROR]",
					rendered = "󱐌 Error",
					highlight = "RenderMarkdownError",
				},
				bug = {
					raw = "[!BUG]",
					rendered = "󰨰 Bug",
					highlight = "RenderMarkdownError",
				},
				example = {
					raw = "[!EXAMPLE]",
					rendered = "󰉹 Example",
					highlight = "RenderMarkdownHint",
				},
				quote = {
					raw = "[!QUOTE]",
					rendered = "󱆨 Quote",
					highlight = "RenderMarkdownQuote",
				},
				cite = {
					raw = "[!CITE]",
					rendered = "󱆨 Cite",
					highlight = "RenderMarkdownQuote",
				},
			},
		},
	},
	{
		"luizribeiro/vim-cooklang",
		enabled = false,
		ft = "cook",
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- optional
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},

		config = function()
			vim.keymap.set("n", "<leader>on", function()
				vim.api.nvim_cmd({ cmd = "ObsidianNew" }, { output = false })
			end, { desc = "[o]bsidian [n]ew: Create new note." })
			vim.keymap.set("n", "<leader>oq", function()
				vim.api.nvim_cmd(
					{ cmd = "ObsidianQuickSwitch" },
					{ output = false }
				)
			end, { desc = "[o]bsidian [q]uickswitch: Switch to note." })
			vim.keymap.set("n", "<leader>os", function()
				vim.api.nvim_cmd({ cmd = "ObsidianSearch" }, { output = false })
			end, { desc = "[o]bsidian [s]earch: Search (or create) note." })
			vim.keymap.set("n", "<leader>ofw", function()
				vim.api.nvim_cmd(
					{ cmd = "ObsidianWorkspace" },
					{ output = false }
				)
			end, {
				desc = "[o]bsidian [w]orkspace: Open picker listing workspaces.",
			})
			vim.keymap.set({ "v" }, "<leader>ol", function()
				vim.api.nvim_cmd({ cmd = "ObsidianLink" }, { output = true })
			end, {
				desc = "[o]bsidian [l]ink: Link to note (if any) that match text under cursor or selection.",
			})
			vim.keymap.set(
				{ "v" },
				"<leader>oL",
				function()
					local viz = require("faith.func").get_selection()
					if #viz ~= 1 then
						vim.notify(
							"Selection can't span multiple lines",
							vim.log.levels.ERROR,
							{ title = "Obsidian.nvim LinkNew" }
						)
						return
					end

					local title = vim.fn.input({
						prompt = "Creating note. (Cancel to abort).",
						default = viz[1],
					})

					if title == "" then
						vim.notify(
							"Aborted making new note!",
							vim.log.levels.INFO,
							{ title = "Obsidian.nvim LinkNew" }
						)
						return
					end

					vim.api.nvim_cmd(
						{ cmd = "ObsidianLinkNew" },
						{ output = false }
					)
				end,
				{ desc = "[o]bsidian [L]ink: Link selected text to new note." }
			)
		end,
		opts = {
			workspaces = function()
				local vaults_dir = os.getenv("HOME") .. "/Documents/Obsidian"
				if vim.fn.has("win32") == 1 then
					vaults_dir = "E:\\Documents\\Obsidian"
				end

				local vaults = {}
				for dir in
					io.popen(
						vim.fn.has("win32" == 1)
								and [[dir ]] .. vaults_dir .. [[ /b]]
							or [[ls -pa ]] .. vaults_dir .. [[ | grep -v /]]
					):lines()
				do
					if dir:sub(1, 1) ~= "." then
						table.insert(
							vaults,
							{ name = dir, path = vaults_dir .. "/" .. dir }
						)
					end
				end
				return vaults
			end,
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
					suffix = spec.title
						:gsub(" ", "-")
						:gsub("[^A-Za-z0-9-]", "")
						:lower()
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
				-- Toggle check-boxes.
				["<leader>oc"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = {
						buffer = true,
						desc = "[o]bsidian [c]heckbox: Toggle checkbox.",
					},
				},
				["<leader>oo"] = {
					action = function()
						vim.api.nvim_cmd(
							{ cmd = "ObsidianOpen" },
							{ output = false }
						)
					end,
					opts = {
						buffer = true,
						desc = "[o]bsidian [o]pen: Open current note in Obsidian app.",
					},
				},
				["<leader>ofb"] = {
					action = function()
						vim.api.nvim_cmd(
							{ cmd = "ObsidianBacklinks" },
							{ output = false }
						)
					end,
					opts = {
						buffer = true,
						desc = "[o]bsidian [b]acklinks: Search references to current note.",
					},
				},
				["<leader>ofl"] = {
					action = function()
						vim.api.nvim_cmd(
							{ cmd = "ObsidianLinks" },
							{ output = false }
						)
					end,
					opts = {
						buffer = true,
						desc = "[o]bsidian [f]ind [l]inks: List all links in current note.",
					},
				},
				["<leader>ot"] = {
					action = function()
						vim.api.nvim_cmd(
							{ cmd = "ObsidianTemplate" },
							{ output = false }
						)
					end,
					opts = {
						buffer = true,
						desc = "[o]bsidian [t]emplate: Insert template from templates folder.",
					},
				},
				["<leader>oT"] = {
					action = function()
						vim.api.nvim_cmd(
							{ cmd = "ObsidianNewFromTemplate" },
							{ output = false }
						)
					end,
					opts = {
						buffer = true,
						desc = "[o]bsidian [T]emplate: Create new note from template from templates folder.",
					},
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
				date_format = "%Y%m%d",
				time_format = "%H%M",
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
				enable = false, -- set to false to disable all additional syntax features
				update_debounce = 200, -- update delay after a text change (in milliseconds)
				-- Define how various check-boxes are displayed
				checkboxes = {
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { char = "", hl_group = "ObsidianDone" },
					[">"] = { char = "", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
					-- Replace the above with this if you don't have a patched font:
					-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
					-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

					-- You can also add more custom ones...
				},
				-- Use bullet marks for non-checkbox lists.
				bullets = { char = "•", hl_group = "ObsidianBullet" },
				external_link_icon = {
					char = "",
					hl_group = "ObsidianExtLinkIcon",
				},
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
		},
	},
}
