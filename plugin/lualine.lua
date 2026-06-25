vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
}, { load = function() end })

local function config()
	local lualine = require("lualine")

	local statusline = {
		lualine_a = {},
		lualine_b = {
			{
				"overseer",
				label = "",
				colored = true,
				unique = true,
			},
		},
		lualine_c = { "%=", "harpoon" },
		lualine_x = { "macro_recording" },
		lualine_y = {},
		lualine_z = { "trans_flag" },
	}
	local tabline = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				"tabs",
				tab_max_length = 40, -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
				max_length = vim.o.columns / 3, -- Maximum width of tabs component.
				-- Note:
				-- It can also be a function that returns
				-- the value of `max_length` dynamically.
				mode = 2, -- 0: Shows tab_nr
				-- 1: Shows tab_name
				-- 2: Shows tab_nr + tab_name

				path = 0, -- 0: just shows the filename
				-- 1: shows the relative path and shorten $HOME to ~
				-- 2: shows the full path
				-- 3: shows the full path and shorten $HOME to ~

				-- Automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
				use_mode_colors = false,

				-- tabs_color = {
				-- 	-- Same values as the general color option can be used here.
				-- 	active = "lualine_{section}_normal", -- Color for active tab.
				-- 	inactive = "lualine_{section}_inactive", -- Color for inactive tab.
				-- },

				show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
				},

				fmt = function(name, context)
					local lable = name
					-- Show + if buffer is modified in tab
					local buflist = vim.fn.tabpagebuflist(context.tabnr)
					local winnr = vim.fn.tabpagewinnr(context.tabnr)
					local bufnr = buflist[winnr]
					local mod = vim.fn.getbufvar(bufnr, "&mod")

					local bpm = pcall(require, "bpm")
					if bpm then
						local tabname = require("bpm").resolve_tabname(context.tabnr)
						if tonumber(tabname) == nil then
							lable = tabname
						end
					end

					return lable .. (mod == 1 and " +" or "")
				end,
			},
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	}

	lualine.setup({
		options = {
			globalstatus = true,
			section_separators = "",
			component_separators = "",
			always_divide_middle = false,
		},
		sections = statusline,
		inactive_sections = statusline,
		tabline = tabline,
	})
end

local function load()
	if not package.loaded["lualine"] then
		vim.cmd.packadd("lualine.nvim")
	end
	config()
end

vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		load()
	end,
})
