return {
	{
		"folke/snacks.nvim",
		ft = "markdown",
		priority = 900,
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
					-- scope = {
						-- 	min_size = 5,
						-- 	max_size = 40,
						-- 	siblings = true,
						-- },
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
					bigfile = { enabled = false },
					bufdelete = { enable = false },
					dashboard = { enabled = false },
					explorer = { enabled = false },
					indent = { enabled = false },
					input = { enabled = false },
					picker = { enabled = false, },
					notifier = { enabled = false },
					quickfile = { enabled = false },
					scope = { enabled = false },
					scroll = { enabled = false },
					statuscolumn = { enabled = false },
					words = { enabled = false },
					toggle = { enabled = false },
					scratch = { enabled = false },
					zen = {
						enabled = false,
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
								winhighlight = "NormalFloat:Normal,Normal:Normal,WinBar:Comment",
							},
							on_open = function(win)
								vim.cmd.ScrollViewDisable()
							end,
							on_close = function(win)
								vim.cmd.ScrollViewEnable()
							end,
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
		},
	}
