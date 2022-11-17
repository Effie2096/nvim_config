M = {}

M.borders = {
	Square_borders = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
	Round_borders = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	Blank_borders = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
	Hor_seperator_bot = { ' ', ' ', '─', ' ', ' ', ' ', '─', '─' },
	Hor_seperator_top = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' },
}

M.border_presets = {
	Square_borders_alt = {
			M.borders.Square_borders,
			prompt = { "─", "│", " ", "│", '┌', '┐', "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
			preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
	}
}

M.layout_configs = {
	defaults = {
		results_title = false,
		preview_title = false,
		prompt_prefix = '  ',
		selection_caret = ' ',
		multi_icon = ' ',
		color_devicons = true,
		winblend = 0,
		layout_config = {
			width = { padding = 0 },
			height = { padding = 0 },
			horizontal = {
				preview_width = function (_, cols, _)
					--[[ if cols > 200 then
						return math.floor(cols * 0.5)
					else
						return math.floor(cols * 0.3)
					end ]]
					return (math.floor(cols * 0.4)) < 70 and math.floor(cols * 0.4) or 100
				end
			},
			vertical = {
				width = { padding = 0 },
				height = { padding = 0 },
				preview_height = 0.5
			},
		}
	},
	centered_compact = {
		layout_strategy = 'horizontal',
		previewer = false,
		sorting_strategy = 'ascending',
		borderchars = {
			M.borders.Blank_borders,
			prompt = M.borders.Blank_borders,
			results = M.borders.Blank_borders,
			preview = M.borders.Blank_borders
		},
		layout_config = {
			horizontal = {
				prompt_position = 'top',
				width = function (_, cols, _)
					if cols > 200 then
						return 120
					elseif cols > 150 then
						return 100
					else
						return math.floor(cols * 0.8)
					end
				end,
				height = 0.4,
			}
		},
	},
	default_flex = {
		layout_strategy = 'flex',
		sorting_strategy = 'ascending',
		borderchars = M.borders.Blank_borders,
		layout_config = {
			prompt_position = 'top',
		}
	},
	default_vert = {
		layout_strategy = 'vertical',
		sorting_strategy = 'ascending',
		borderchars = M.borders.Blank_borders,
		layout_config = {
			vertical = {
				prompt_position = 'top',
				width = function (_, cols, _)
					if cols > 200 then
						return 120
					elseif cols > 150 then
						return 100
					else
						return math.floor(cols * 0.8)
					end
				end,
				height = 0.6,
			},
		}
	},
	default_bottom = {
		layout_strategy = 'horizontal',
		sorting_strategy = 'ascending',
		borderchars = M.borders.Blank_borders,
		layout_config = {
			horizontal = {
				prompt_position = 'top',
				height = function (_, _, lines)
					if lines > 60 then
						return 20
					else
						return math.floor(lines * 0.25)
					end
				end,
				width = { padding = 0 },
				preview_width = function (_, cols, _)
					if cols > 160 then
						return math.floor(cols * 0.5)
					else
						return 80
					end
				end
			}
		},
	},
	default_cursor = {
		layout_strategy = 'cursor',
		borderchars = M.border_presets.Square_borders_alt,
		layout_config = {
			width = 40,
			height = 10
		}
	}
}

local file_ignore = {
	file_ignore_patterns = {
		"^node_modules/",
		"^target/", "^bin/",  "^build/",
		"%.class", "%.jar",
		"%.swp", "%.zip", "%.exe", "%.mid", "%.jar", "%.class", "%.mm", "%.o", "%.obj",
		"%.csproj", "%.sln", "%.cache", "%.asset", "%.prefs", "%.dwlt", "%.db", "%.catalog", "%.graph", "%.meta",
		"%.bmp", "%.gif", "%.ico", "%.jpg", "%.png", "%.ico",
		"%.pdf",
		"^tmp/", "^.vs/", "^Library/", "^Logs/", "^obj/", "^Packages/", "^ProjectSettings/",
	}
}
M.layout_configs.defaults = vim.tbl_extend('force', M.layout_configs.defaults, file_ignore)

local function append_defaults()
	local defaults = M.layout_configs['defaults']
	for key, _ in pairs(M.layout_configs) do
		if key == 'defaults' then
			goto continue
		end
		M.layout_configs[key] = vim.tbl_deep_extend(
			"force",
			defaults,
			M.layout_configs[key]
		)
		::continue::
	end
end

append_defaults()

return M
