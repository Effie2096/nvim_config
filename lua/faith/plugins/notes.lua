local icons = require("faith.icons")

local checkboxes = {
	unchecked = {
		raw = " ",
		rendered = "󰄱",
		highlight = "RenderMarkdownUnchecked",
	},
	checked = {
		raw = "x",
		rendered = "󰱒",
		highlight = "RenderMarkdownChecked",
		scope_highlight = "RenderMarkdownCancelledMainContent",
	},
	cancelled = {
		raw = "~",
		rendered = "󰅘",
		highlight = "RenderMarkdownCancelled",
		scope_highlight = "RenderMarkdownCancelledMainContent",
	},
	paused = {
		raw = ">",
		rendered = "󰏦",
		highlight = "RenderMarkdownPaused",
	},
	urgent = {
		raw = "^",
		rendered = "",
		highlight = "RenderMarkdownUrgent",
	},
	optional = {
		raw = "?",
		rendered = "",
		highlight = "RenderMarkdownOptional",
	},
	in_progress = {
		raw = ".",
		rendered = "",
		highlight = "RenderMarkdownInProgress",
	},
}

local obsidian_maps = {
	{
		lhs = "<leader>on",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "new" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = { desc = "[o]bsidian [n]ew: Create new note." },
	},
	{
		lhs = "<leader>oq",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "quick_switch" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = { desc = "[o]bsidian [q]uickswitch: Switch to note." },
	},
	{
		lhs = "<leader>os",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "search" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = { desc = "[o]bsidian [s]earch: Search (or create) note." },
	},
	{
		lhs = "<leader>ofw",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "workspace" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = { desc = "[o]bsidian [w]orkspace: Open picker listing workspaces." },
	},
	{
		lhs = "<leader>ol",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "link" } },
				{ output = true }
			)
		end,
		mode = "v",
		opts = {
			desc = "[o]bsidian [l]ink: Link to note (if any) that match text under cursor or selection.",
		},
	},
	{
		mode = "v",
		lhs = "<leader>oL",
		rhs = function()
			local viz = require("faith.func").get_selection()
			if #viz ~= 1 then
				vim.notify(
					"Selection can't span multiple lines",
					vim.log.levels.ERROR,
					{ title = "Obsidian.nvim Link New" }
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
					{ title = "Obsidian.nvim Link New" }
				)
				return
			end

			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "link_new", title } },
				{ output = false }
			)
		end,
		opts = { desc = "[o]bsidian [L]ink: Link selected text to new note." },
	},
	{
		lhs = "<leader>oo",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "open" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = {
			desc = "[o]bsidian [o]pen: Open current note in Obsidian app.",
		},
	},
	{
		lhs = "<leader>ofb",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "backlinks" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = {
			desc = "[o]bsidian [b]acklinks: Search references to current note.",
		},
	},
	{
		lhs = "<leader>ofl",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "links" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = {
			desc = "[o]bsidian [f]ind [l]inks: List all links in current note.",
		},
	},
	{
		lhs = "<leader>oft",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "tags" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = {
			desc = "[o]bsidian [f]ind [t]ags: List all tags in vault.",
		},
	},
	{
		lhs = "<leader>ot",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "template" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = {
			desc = "[o]bsidian [t]emplate: Insert template from templates folder.",
		},
	},
	{
		lhs = "<leader>oT",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "new_from_template" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = {
			desc = "[o]bsidian [T]emplate: Create new note from template from templates folder.",
		},
	},
	{
		lhs = "<leader>op",
		rhs = function()
			local title = vim.fn.input({
				prompt = "Creating note. (Cancel to abort).",
			})
			if title == "" then
				vim.notify(
					"Aborted pasting image!",
					vim.log.levels.INFO,
					{ title = "Obsidian.nvim Paste Image" }
				)
				return
			end

			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "paste_img", title } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = {
			desc = "[o]bsidian [p]aste: Paste image from clipboard and save it to vault.",
		},
	},
	{
		lhs = "gf",
		rhs = function()
			vim.api.nvim_cmd(
				{ cmd = "Obsidian", args = { "follow_link", "vsplit_force" } },
				{ output = false }
			)
		end,
		mode = "n",
		opts = {
			desc = "[g]o [f]ile: Open linked note in split",
		},
	},
}

local function md(raw)
	return ("[%s]"):format(raw)
end

return {
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
				group = vim.api.nvim_create_augroup("attach_otter", { clear = true }),
				pattern = { "*.md" },
				callback = function()
					require("otter").activate()
				end,
			})
			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = { "toml" },
				group = vim.api.nvim_create_augroup("EmbedToml", {}),
				callback = function()
					require("otter").activate()
				end,
			})
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
		ft = { "markdown", "vim-plug", "Avante" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			file_types = { "markdown", "Avante" },
			completions = { lsp = { enabled = true } },
			render_modes = { "n", "i", "c" },
			restart_highlighter = true,
			heading = {
				-- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
				icons = { " " },
				position = "inline",
				border = true,
				-- border_virtual = true,
				width = { "block" },
				min_width = vim.o.textwidth - 1,
			},
			indent = {
				enabled = false,
				skip_heading = true,
				per_level = vim.o.shiftwidth,
				icon = " ",
			},
			bullet = {
				enabled = true,
				icons = { "", "", "◆", "◇" },
			},
			pipe_table = {
				padding = 1,
				border_enabled = true,
				border_virtual = true,
			},
			checkbox = {
				enabled = true,
				bullet = false,
				left_pad = 1,
				unchecked = {
					icon = checkboxes.unchecked.rendered,
					highlight = checkboxes.unchecked.highlight,
				},
				checked = {
					icon = checkboxes.checked.rendered,
					highlight = checkboxes.checked.highlight,
					scope_highlight = checkboxes.checked.scope_highlight,
				},
				custom = {
					cancelled = {
						raw = md(checkboxes.cancelled.raw),
						rendered = checkboxes.cancelled.rendered,
						highlight = checkboxes.cancelled.highlight,
						scope_highlight = checkboxes.cancelled.scope_highlight,
					},
					paused = {
						raw = md(checkboxes.paused.raw),
						rendered = checkboxes.paused.rendered,
						highlight = checkboxes.paused.highlight,
					},
					urgent = {
						raw = md(checkboxes.urgent.raw),
						rendered = checkboxes.urgent.rendered,
						highlight = checkboxes.urgent.highlight,
					},
					optional = {
						raw = md(checkboxes.optional.raw),
						rendered = checkboxes.optional.rendered,
						highlight = checkboxes.optional.highlight,
					},
					in_progress = {
						raw = md(checkboxes.in_progress.raw),
						rendered = checkboxes.in_progress.rendered,
						highlight = checkboxes.in_progress.highlight,
					},
				},
			},
			link = {
				enabled = true,
			},
			code = {
				width = "block",
				border = "thin",
				language_border = " ",
				language_left = ("%s%s"):format(
					icons.separators.slant.right,
					icons.ui.Block
				),
				language_right = ("%s%s"):format(
					icons.ui.Block,
					icons.separators.slant.left
				),
				min_width = vim.o.textwidth - 3,
				left_margin = 1,
				left_pad = 1,
				language_pad = 0,
				-- Used above code blocks for thin border.
				above = "▄",
				-- Used below code blocks for thin border.
				below = "▀",
				inline = true,
				-- Icon to add to the left of inline code.
				inline_left = "",
				-- Icon to add to the right of inline code.
				inline_right = "",
				-- Padding to add to the left & right of inline code.
				inline_pad = 1,
				-- highlight_inline = "",
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
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		ft = "markdown",
		keys = function()
			return vim
				.iter(obsidian_maps)
				:map(function(map)
					return { map.lhs }
				end)
				:totable()
		end,
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- optional
			"saghen/blink.cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},

		config = function()
			local function get_workspaces()
				local vaults_dir = os.getenv("HOME") .. "/Documents/Obsidian"
				if vim.fn.has("win32") == 1 then
					vaults_dir = "E:\\Documents\\Obsidian"
				end

				local vaults = {
					{
						path = vim.fn.glob(
							("%s/BrainFart"):format(vaults_dir),
							true,
							false
						),
						name = "BrainFart",
						overrides = {
							templates = {
								subdir = "_System/Templates/",
							},
						},
					},
				}
				-- for dir in
				-- 	io.popen(
				-- 		vim.fn.has("win32") == 1 and [[dir ]] .. vaults_dir .. [[ /b]]
				-- 			or [[ls -pa ]] .. vaults_dir .. [[ | grep -v /]]
				-- 	):lines()
				-- do
				-- 	if dir:sub(1, 1) ~= "." then
				-- 		table.insert(
				-- 			vaults,
				-- 			{ name = dir, path = vaults_dir .. "/" .. dir }
				-- 		)
				-- 	end
				-- end
				return vaults
			end
			local workspaces = get_workspaces()

			local opts = {
				legacy_commands = false,
				workspaces = workspaces,
				templates = {
					subdir = "_System/Templates/",
					date_format = "%Y%m%d",
					time_format = "%H%M%S",
					-- A map for custom variables, the key should be the variable and the value a function
					substitutions = {
						["date:YYYY-MM-DD"] = function()
							return tostring(os.date("%Y-%m-%d", os.time()))
						end,
					},
				},

				-- Where to put new notes. Valid options are
				--  * "current_dir" - put new notes in same directory as the current buffer.
				--  * "notes_subdir" - put new notes in the default notes subdirectory.
				new_notes_location = "current_dir",
				note_id_func = function(title)
					local suffix = ""
					local id = tostring(os.date("%Y%m%d%H%M%S", os.time()))

					if title ~= nil then
						suffix = title
					else
						-- If title is nil, just add 4 random uppercase letters to the suffix.
						for _ = 1, 4 do
							suffix = suffix .. string.char(math.random(65, 90))
						end
					end
					return ("%s %s"):format(id, suffix)
				end,

				-- Optional, customize how note file names are generated given the ID, target directory, and title.
				---@param spec { id: string, dir: obsidian.Path, title: string|? }
				---@return string|obsidian.Path The full path to the new note.
				note_path_func = function(spec)
					local path = spec.dir / tostring(spec.id)
					return path
				end,

				note = {
					template = "Unique Note.md",
				},
				-- Optional, customize how wiki links are formatted. You can set this to one of:
				--	* "use_alias_only", e.g. '[[Foo Bar]]'
				--	* "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
				--	* "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
				--	* "use_path_only", e.g. '[[foo-bar.md]]'
				wiki_link_func = require("obsidian.builtin").wiki_link_path_prefix,
				-- Optional, for templates (see below).
				attachments = {
					folder = "Attachments",
					-- A function that determines the text to insert in the note when pasting an image.
					-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
					-- This is the default implementation.
					img_text_func = function(client, path)
						path = client:vault_relative_path(path) or path
						return string.format("![%s](%s)", path.name, path)
					end,
				},
				checkbox = {
					order = {
						checkboxes.unchecked.raw,
						checkboxes.checked.raw,
						checkboxes.cancelled.raw,
						checkboxes.in_progress.raw,
						checkboxes.paused.raw,
						checkboxes.urgent.raw,
						checkboxes.optional.raw,
					},
				},
				ui = {
					enable = false,
				},
			}
			require("obsidian").setup(opts)

			vim.iter(obsidian_maps):each(function(map)
				vim.keymap.set(map.mode, map.lhs, map.rhs, map.opts)
			end)
		end,
	},
	{
		"bngarren/checkmate.nvim",
		ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
		version = "~0.12.0",
		config = function()
			---@type checkmate.Config
			local opts = {
				files = { "*.md" }, -- any .md file (instead of defaults)
				list_continuation = {
					enabled = false,
				},
				todo_states = {
					unchecked = {
						marker = md(checkboxes.unchecked.raw),
						-- marker = checkboxes.unchecked.rendered,
					},
					checked = {
						marker = "[x]",
						-- marker = checkboxes.checked.rendered,
					},

					in_progress = {
						marker = md(checkboxes.in_progress.raw),
						-- marker = checkboxes.in_progress.rendered,
						markdown = checkboxes.in_progress.raw,
						type = "incomplete", -- Counts as "not done"
						order = 50,
					},
					cancelled = {
						marker = md(checkboxes.cancelled.raw),
						-- marker = checkboxes.cancelled.rendered,
						markdown = checkboxes.cancelled.raw,
						type = "complete",
						order = 2,
					},
					paused = {
						marker = md(checkboxes.paused.raw),
						-- marker = checkboxes.paused.rendered,
						markdown = checkboxes.paused.raw,
						type = "incomplete",
						order = 100,
					},
					urgent = {
						marker = md(checkboxes.urgent.raw),
						-- marker = checkboxes.urgent.rendered,
						markdown = checkboxes.urgent.raw,
						type = "incomplete",
						order = 1,
					},
					optional = {
						marker = md(checkboxes.optional.raw),
						-- marker = checkboxes.optional.rendered,
						markdown = checkboxes.optional.raw,
						type = "inactive",
						order = 101,
					},
				},
				todo_count_formatter = function(completed, total)
					return string.format("(%d/%d)", completed, total)
				end,

				style = {
					CheckmateTodoCountIndicator = { link = "AccentInverse" },
				},
				-- {
				-- 	CheckmateCheckedMarker = { link = checkboxes.checked.highlight },
				-- 	CheckmateUncheckedMarker = { link = checkboxes.unchecked.highlight },
				-- 	CheckmateInProgressMarker = { link = checkboxes.inProgress.highlight },
				-- 	CheckmateCancelledMarker = { link = checkboxes.cancelled.highlight },
				-- 	CheckmateCancelledMainContent = {
				-- 		link = checkboxes.cancelled.scope_highlight,
				-- 	},
				-- 	CheckmatePausedMarker = { link = checkboxes.paused.highlight },
				-- 	CheckmateUrgentMarker = { link = checkboxes.urgent.highlight },
				-- 	CheckmateUrgentMainContent = { link = checkboxes.urgent.scope_highlight },
				-- 	CheckmateOptionalMarker = { link = checkboxes.optional.highlight },
				-- },
			}
			require("checkmate").setup(opts)

			vim.api.nvim_create_augroup("show_todo_list", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
				group = "show_todo_list",
				pattern = "*.md",
				callback = function(ctx)
					local todos = require("checkmate").get_todos({
						filter = { state_types = { "incomplete" } },
					})
					if not todos then
						return
					end

					local list = vim
						.iter(todos)
						:map(function(todo)
							return {
								bufnr = todo.bufnr,
								filename = vim.fn.glob(ctx.file, true, false),
								lnum = todo.row,
								col = todo.indent,
								text = ("%s%s"):format(
									todo.indent == 0 and "" or string.rep(" ", todo.indent / 2),
									string.gsub(todo.text, todo.list_marker .. " ", "")
								),
							}
						end)
						:totable()

					if list then
						vim.fn.setloclist(0, {}, "r", { title = "Todos", items = list })
						vim.api.nvim_command("doautocmd QuickFixCmdPost")
					end
				end,
			})
		end,
	},
	{
		"luizribeiro/vim-cooklang",
		ft = "cook",
	},
}
