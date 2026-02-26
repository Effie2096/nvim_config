return {
	{
		"folke/snacks.nvim",
		priority = 900,
		lazy = false,
		---@type snacks.Config
		config = function()
			local sn = require("snacks")
			local util = require("snacks.util")
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
					resolve = function(path, src)
						local api = require("obsidian.api")
						if api.path_is_note(path) then
							return api.resolve_attachment_path(src)
						end
					end,
					doc = {
						-- enable image viewer for documents
						-- a treesitter parser must be available for the enabled languages.
						enabled = true,
						-- render the image inline in the buffer
						-- if your env doesn't support unicode placeholders, this will be disabled
						-- takes precedence over `opts.float` on supported terminals
						inline = false,
						-- render the image in a floating window
						-- only used if `opts.inline` is disabled
						float = true,
						max_width = 80,
						max_height = 40,
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
				dim = {
					enabled = false,
					---@type snacks.scope.Config
					scope = {
						min_size = 5,
						max_size = 40,
						siblings = true,
					},
					-- animate scopes. Enabled by default for Neovim >= 0.10
					-- Works on older versions but has to trigger redraws during animation.
					---@type snacks.animate.Config|{enabled?: boolean}
					animate = {
						enabled = true,
						easing = "outQuad",
						duration = {
							step = 20, -- ms per step
							total = 100, -- maximum duration
						},
					},
					-- what buffers to dim
					filter = function(buf)
						return vim.g.snacks_dim ~= false
							and vim.b[buf].snacks_dim ~= false
							and vim.bo[buf].buftype == ""
					end,
				},
				bigfile = { enabled = true },
				bufdelete = { enable = true },
				dashboard = { enabled = false },
				explorer = { enabled = false },
				indent = { enabled = false },
				input = { enabled = true },
				picker = {
					enabled = true,
					show_delay = 1000,
					---@class snacks.picker.matcher.Config
					matcher = {
						fuzzy = true, -- use fuzzy matching
						smartcase = true, -- use smartcase
						ignorecase = true, -- use ignorecase
						sort_empty = false, -- sort results when the search string is empty
						filename_bonus = true, -- give bonus for matching file names (last part of the path)
						file_pos = true, -- support patterns like `file:line:col` and `file:line`
						-- the bonusses below, possibly require string concatenation and path normalization,
						-- so this can have a performance impact for large lists and increase memory usage
						cwd_bonus = false, -- give bonus for matching files in the cwd
						frecency = false, -- frecency bonus
						history_bonus = false, -- give more weight to chronological order
					},
				},
				notifier = { enabled = false },
				quickfile = { enabled = true },
				scope = { enabled = false },
				scroll = { enabled = false },
				statuscolumn = { enabled = false },
				words = { enabled = false },
				toggle = { enabled = true },
				scratch = {
					filekey = {
						cwd = true, -- use current working directory
						branch = false, -- use current branch name
						count = true, -- use vim.v.count1
					},
				},
				zen = {
					enabled = true,
					center = true,
					toggles = { dim = false },
					show = {
						statusline = false,
						tabline = false,
					},
					zoom = {
						show = {
							statusline = true,
							tabline = true,
						},
					},
				},
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
					zen = {
						enter = true,
						fixbuf = false,
						minimal = false,
						width = 79,
						height = 0,
						backdrop = {
							transparent = false,
							blend = 0,
							bg = util.color("Normal", "bg"),
						},
						wo = {
							winhighlight = "NormalFloat:Normal,Normal:Normal",
						},
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
		end,
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
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
				end,
			})

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
		end,
		keys = {
			{
				"<leader>s.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>sn",
				function()
					vim.ui.input({
						prompt = "Filetype: ",
						default = (vim.bo.buftype == "" and vim.bo.filetype ~= "")
								and vim.bo.filetype
							or "markdown",
					}, function(input)
						if input then
							Snacks.scratch({ ft = input })
						else
							Snacks.scratch()
						end
					end)
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>z",
				function()
					Snacks.zen.zen()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<leader>bc",
				function()
					Snacks.bufdelete.delete()
				end,
				desc = "[b]uffer [c]lose: Delete current buffer without closing window.",
			},
		},
	},
}
