vim.pack.add({
	{ src = "https://github.com/aurora0x27/bpm.nvim" },
}, { load = function() end })

local wk = require("which-key")

local name_tab = function(tabnr, cb)
	local tabname = require("bpm").resolve_tabname(tabnr)

	vim.ui.input({
		prompt = "Tab name: ",
		default = tabname ~= 0 and tabname or "",
		hightlight = "AccentInverse",
	}, function(input)
		if input and input ~= "" then
			cb(tabnr, input)
		end
	end)
end

local function config()
	local bpm = require("bpm")
	bpm.setup()

	local maps = {
		{
			lhs = "<leader>tta",
			rhs = function()
				vim.api.nvim_cmd({
					cmd = "tabnew",
					bang = true,
				}, {})
				local tabnr = vim.api.nvim_tabpage_get_number(0)
				name_tab(tabnr, bpm.rename_tab)
			end,
			desc = "[t]ab [a]add: create new tab.",
		},
		{
			lhs = "<leader>ttr",
			rhs = function()
				local tabnr = vim.api.nvim_tabpage_get_number(0)
				name_tab(tabnr, bpm.rename_tab)
			end,
			desc = "[t]ab [r]ename: rename current tab.",
		},
		{
			lhs = "<leader>ttc",
			rhs = function()
				vim.cmd.tabclose()
			end,
			desc = "[t]ab [c]lose: close current tab.",
		},
	}

	wk.add(vim.list_extend(
		vim
			.iter(maps)
			:map(function(map)
				return {
					map.lhs,
					map.rhs,
					desc = map.desc,
					icon = "󰓩 ",
					map.opts or {},
				}
			end)
			:totable(),
		{
			{ "<leader>tt", group = "Tabs" },
		}
	))
end

local function load()
	if not package.loaded["bpm"] then
		vim.cmd.packadd("bpm.nvim")
	end
	config()
end

load()
