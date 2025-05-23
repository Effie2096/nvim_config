M = {}

local icons = require('faith.icons')

M.borders = {
	Square_borders = {
		icons.borders.square.top, -- top
		icons.borders.square.right, -- right
		icons.borders.square.bottom, -- bottom
		icons.borders.square.left, -- left
		icons.borders.square.top_left, -- top left
		icons.borders.square.top_right, -- top right
		icons.borders.square.bottom_right, -- bottom right
		icons.borders.square.bottom_left -- bottom left
	},
	Round_borders = {
		icons.borders.round.top, -- top
		icons.borders.round.right, -- right
		icons.borders.round.bottom, -- bottom
		icons.borders.round.left, -- left
		icons.borders.round.top_left, -- top left
		icons.borders.round.top_right, -- top right
		icons.borders.round.bottom_right, -- bottom right
		icons.borders.round.bottom_left -- bottom left

	},
	Blank_borders = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
	Hor_seperator_bot = {
		' ',
		' ',
		icons.borders.square.bottom,
		' ',
		' ',
		' ',
		icons.borders.square.bottom,
		icons.borders.square.bottom
	},
	Hor_seperator_top = {
		icons.borders.square.top,
		' ',
		' ',
		' ',
		icons.borders.square.top,
		icons.borders.square.top,
		' ',
		' '
	},
	Edge_borders = {
		icons.borders.edge_thin.top, -- top
		icons.borders.edge_thin.right, -- right
		icons.borders.edge_thin.bottom, -- bottom
		icons.borders.edge_thin.left, -- left
		icons.borders.edge_thin.top_left, -- top left
		icons.borders.edge_thin.top_right, -- top right
		icons.borders.edge_thin.bottom_right, -- bottom right
		icons.borders.edge_thin.bottom_left -- bottom left
	},
}

M.border_presets = {
	Square_borders_alt = {
		M.borders.Square_borders,
		prompt = {
			icons.borders.square.top,
			icons.borders.square.right,
			" ",
			icons.borders.square.left,
			icons.borders.square.top_left,
			icons.borders.square.top_right,
			icons.borders.square.right,
			icons.borders.square.left
		},
		results = {
			icons.borders.square.top,
			icons.borders.square.right,
			icons.borders.square.bottom,
			icons.borders.square.left,
			icons.borders.square.inter_left,
			icons.borders.square.inter_right,
			icons.borders.square.bottom_right,
			icons.borders.square.bottom_left
		},
		preview = M.borders.Square_borders,
	},
	Square_borders_vert = {
		M.borders.Square_borders,
		prompt = {
			icons.borders.square.top,
			icons.borders.square.right,
			icons.borders.square.bottom,
			icons.borders.square.left,
			icons.borders.square.top_left,
			icons.borders.square.top_right,
			icons.borders.square.inter_right,
			icons.borders.square.inter_left,
		},
		results = {
			' ',
			icons.borders.square.right,
			icons.borders.square.bottom,
			icons.borders.square.left,
			icons.borders.square.left,
			icons.borders.square.right,
			icons.borders.square.bottom_right,
			icons.borders.square.bottom_left,
		},
		preview = {
			icons.borders.square.top,
			icons.borders.square.right,
			icons.borders.square.bottom,
			icons.borders.square.left,
			icons.borders.square.top_left,
			icons.borders.square.top_right,
			icons.borders.square.bottom_right,
			icons.borders.square.bottom_left,
		}
	},
	Preview_emphasis = {
		prompt = M.borders.Blank_borders,
		results = M.borders.Blank_borders,
		preview = M.borders.Edge_borders
	}
}

M.layout_configs = {
	defaults = {
		results_title = false,
		preview_title = false,
		prompt_prefix = icons.ui.Search .. ' ',
		selection_caret = icons.ui.Caret_Arrow,
		multi_icon = icons.ui.Multi_Select,
		color_devicons = true,
		winblend = 0,
		layout_config = {
			width = { padding = 0 },
			height = { padding = 0 },
			horizontal = {
				preview_cutoff = 0,
				preview_width = function (_, cols, _)
					return (math.floor(cols * 0.4)) < 70 and math.floor(cols * 0.4) or 100
				end
			},
			vertical = {
				width = { padding = 0 },
				height = { padding = 0 },
				preview_cutoff = 0,
				preview_height = 0.5,
				mirror = true,
			},
		},
		mappings = {
			i = {
				["<M-p>"] = require("telescope.actions.layout").toggle_preview,
			},
			n = {
				["<M-p>"] = require("telescope.actions.layout").toggle_preview,
			},
		},
	},
	centered_compact = {
		layout_strategy = 'horizontal',
		previewer = false,
		sorting_strategy = 'ascending',
		borderchars = {
			prompt = M.borders.Blank_borders,
			results = M.borders.Edge_borders,
			preview = M.borders.Edge_borders
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
		borderchars = M.border_presets.Preview_emphasis,
		layout_config = {
			prompt_position = 'top',
			horizontal = {
				preview_width = function (_, cols, _)
					if cols > 250 then
						return math.floor(cols * 0.4)
					elseif cols > 200 then
						return 100
					elseif cols > 150 then
						return 81
					else
						return math.floor(cols * 0.4)
					end
				end,
			},
			vertical = {
				preview_height = function (_, _, lines)
					if lines > 200 then
						return 20
					elseif lines > 150 then
						return math.floor(lines * 0.5)
					else
						return math.floor(lines * 0.4)
					end
				end,
			},
		}
	},
	default_vert = {
		layout_strategy = 'vertical',
		sorting_strategy = 'ascending',
		borderchars = {
			prompt = M.borders.Blank_borders,
			results = M.borders.Edge_borders,
			preview = M.borders.Edge_borders
		},
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
	default_bottom = require("telescope.themes").get_ivy( {
		-- layout_strategy = 'horizontal',
		-- sorting_strategy = 'ascending',
		borderchars = {
			prompt = {
				icons.borders.edge_thin.top,
				" ",
				" ",
				" ",
				icons.borders.edge_thin.top,
				icons.borders.edge_thin.top,
				" ",
				" ",
			},
			results = M.borders.Blank_borders,
			preview = {
				icons.borders.edge_thin.top,
				" ",
				icons.borders.edge_thin.bottom,
				icons.borders.edge_thin.left,
				icons.borders.edge_thin.top_left,
				icons.borders.edge_thin.top,
				" ",
				icons.borders.edge_thin.bottom_left,
			},
		},
		layout_config = {
			height = function (_, _, lines)
				if lines > 60 then
					return 10
				else
					return math.floor(lines * 0.25)
				end
			end,
			preview_width = function (_, cols, _)
				if cols > 160 then
					return math.floor(cols * 0.5)
				else
					return 80
				end
			end
		},
	}),
	default_cursor = {
		layout_strategy = 'cursor',
		borderchars = M.border_presets.Square_borders_alt,
		layout_config = {
			width = 80,
			height = 10
		}
	}
}

M.file_ignore = {
	file_ignore_patterns = {
		"^node_modules[\\/]",
		"package%.json", "package%-lock%.json",
		"^target[\\/]", "^bin[\\/]", "^build[\\/]", "^Build[\\/]", "^Debug[\\/]", "^debug[\\/]", "^Release[\\/]", "^release[\\/]", "^_opam[\\/]", "^_build[\\/]", "^_System[\\/]",
		"%.class", "%.jar",
		"%.swp", "%.zip", "%.exe", "%.mid", "%.jar", "%.class", "%.mm", "%.o", "%.obj",
		"%.csproj", "%.sln", "%.cache", "%.asset", "%.prefs", "%.dwlt", "%.db", "%.catalog", "%.graph", "%.meta",
		"%.bmp", "%.gif", "%.ico", "%.jpg", "%.png", "%.ico", "%.webp",
		"%.pdf",
		"^tmp[\\/]", "^.vs[\\/]", "^Library[\\/]", "^Logs[\\/]", "^obj[\\/]", "^Packages[\\/]", "^ProjectSettings[\\/]",
		"^%.venv[\\/]"
	}
}
M.layout_configs.defaults = vim.tbl_extend('force', M.layout_configs.defaults, M.file_ignore)

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
