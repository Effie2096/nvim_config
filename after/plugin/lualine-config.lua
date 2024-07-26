M = {}

local lualine_status_ok, lualine = pcall(require, "lualine")
if not lualine_status_ok then
	return
end

local colors = require("catppuccin.palettes").get_palette()

local icons = require("faith.icons")

local encoding = {
	"fileformat",
	padding = { left = 1, right = 2 },
	fmt = function(str)
		if str == "" then -- only show if *not* unix format
			return ""
		end
		return str
	end,
}

local fileformat = {
	"encoding",
	padding = { left = 0, right = 1 },
	fmt = function(str)
		if str == "utf-8" then -- only show if *not* utf-8
			return ""
		end
		return str
	end,
}

local trans_flag = {
	{
		'" "',
		color = {
			bg = "#5bcffa", --[[fg = '#FF1B8D',]]
		},
		padding = 0,
		separator = { left = "", right = "" },
	},
	{
		'" "',
		color = {
			bg = "#ffb5cd", --[[fg = '#FF1B8D',]]
		},
		padding = 0,
	},
	{
		'" "',
		color = {
			bg = "#ffffff", --[[fg = '#FFDA00',]]
		},
		padding = 0,
	},
	{
		'" "',
		color = {
			bg = "#ffb5cd", --[[fg = '#1BB3FF',]]
		},
		padding = 0,
	},
	{
		'" "',
		color = {
			bg = "#5bcffa", --[[fg = '#1BB3FF',]]
		},
		padding = 0,
	},
}

-- check if value in table
local function contains(t, value)
	for _, v in pairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

local language_server = {
	function()
		local buf_ft = vim.bo.filetype
		local ui_filetypes = {
			"help",
			"packer",
			"vim-plug",
			"neogitstatus",
			"NvimTree",
			"Trouble",
			"lir",
			"Outline",
			"spectre_panel",
			"toggleterm",
			"DressingSelect",
			"TelescopePrompt",
			"lspinfo",
			"lsp-installer",
			"mason",
			"",
		}

		if contains(ui_filetypes, buf_ft) then
			if M.language_servers == nil then
				return ""
			else
				return M.language_servers
			end
		end

		local clients = vim.lsp.get_clients()
		local client_names = {}

		-- add client
		for _, client in pairs(clients) do
			local name = client.name
			if name ~= "null-ls" then
				if client.name.match(client.name, "otter") then
					name = client.name:gsub("%[%d+%]", "")
				end
				table.insert(client_names, name)
			end
		end

		-- add formatter
		local s = require("null-ls.sources")
		local available_sources = s.get_available(buf_ft)
		local registered = {}
		for _, source in ipairs(available_sources) do
			for method in pairs(source.methods) do
				registered[method] = registered[method] or {}
				table.insert(registered[method], source.name)
			end
		end

		local formatter = registered["NULL_LS_FORMATTING"]
		local linter = registered["NULL_LS_DIAGNOSTICS"]
		if formatter ~= nil then
			vim.list_extend(client_names, formatter)
		end
		if linter ~= nil then
			vim.list_extend(client_names, linter)
		end

		if package.loaded.conform ~= nil then
			local conform_formatters = require("conform").list_formatters()
			for _, f in pairs(conform_formatters) do
				if f.available then
					table.insert(client_names, f.name)
				end
			end
		end

		table.sort(client_names)

		--remove duplicate entries
		--only want to know which clients are active. not how many times they've attached
		local hash = {}
		local res = {}

		for _, v in ipairs(client_names) do
			if not hash[v] then
				res[#res + 1] = v
				hash[v] = true
			end
		end

		client_names = res

		-- join client names with commas
		local client_names_str = table.concat(client_names, ", ")

		-- check client_names_str if empty
		local language_servers = ""
		local client_names_str_len = #client_names_str
		if client_names_str_len ~= 0 then
			language_servers = " (" .. client_names_str .. ") "
		end

		if client_names_str_len == 0 then
			return ""
		else
			M.language_servers = language_servers
			return language_servers:gsub(", anonymous source", "")
		end
	end,
	padding = 0,
}

local asyncrun_status = {
	function()
		return table.concat(vim.tbl_values(vim.tbl_map(function(job)
			if job.status == "running" then
				return "⏳"
			end
			return (job.status == "success" and "✅" or "❌")
		end, vim.g.asyncrun_job_status or {})))
	end,
}

local git = {
	"b:gitsigns_head",
	color = "lualine_a_normal",
	icon = { icons.git.Branch, align = "left" },
}

--[[ local mode = {
	'mode',
	fmt = function(str) return str:sub(1,1) end
} ]]

local workspace_diagnostics = {
	"diagnostics",
	sources = { "nvim_workspace_diagnostic" },
	symbols = icons.diagnostic,
	update_in_insert = true,
}

local location = {
	"%11(%l/%L:%c%) ", --'%l/%L:%c'
}

---@diagnostic disable-next-line: unused-local
local filetype = {
	"filetype",
	colored = true,
	icon = { align = "left" },
}

local format_on_save = {
	function()
		return not (vim.g.disable_autoformat or vim.b.disable_autoformat) and "Format: On" or "Format: Off"
	end,
	padding = 1,
}

local obsession = {
	function()
		local record = "[Session]"
		local stop = record
		local indicator = vim.fn["ObsessionStatus"](record, stop)
		return indicator
	end,
	color = function()
		return { fg = vim.fn.exists("g:this_obsession") == 1 and colors.green or colors.red }
	end,
	cond = function()
		return vim.fn.exists("g:loaded_obsession") == 1 -- plug installed and loaded
			and vim.fn["ObsessionStatus"]() ~= "" -- session loaded
	end,
}

local root = {
	function()
		return string.format("%s %s", icons.ui.Project, vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t"))
	end,
}

local tabs = {
	"tabs",
	mode = 2,
	fmt = function(name, context)
		local tab_dir = vim.fn.fnamemodify(vim.fn.getcwd(-1, context.tabnr), ":t")
		local show_dir = not (tab_dir == vim.fn.fnamemodify(vim.fn.getcwd(-1, -1), ":t"))
		return string.format("%s%s", show_dir and tab_dir .. ": " or "", name)
	end,
	cond = function()
		return vim.fn.tabpagenr("$") > 1
	end,
}

local harpoon = {
	function()
		local harpoon = require("harpoon")
		local marks = harpoon:list().items or {}

		local prefix = " " .. require("faith.icons").ui.BookMark
		local suffix = " "

		local tabline = ""

		local next = next
		if next(marks) ~= nil then
			for i, mark in ipairs(marks) do
				local is_current = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:.") == mark.value

				local label
				if mark.value == "" or mark.value == "(empty)" then
					label = "(empty)"
					is_current = false
				else
					label = string.format("%s", vim.fn.fnamemodify(mark.value, ":t"))
				end

				local extra_marks = 0

				local keys = {
					[1] = "h",
					[2] = "j",
					[3] = "k",
					[4] = "l",
					[5] = require("faith.icons").arrows.left,
					[6] = require("faith.icons").arrows.down,
					[7] = require("faith.icons").arrows.up,
					[8] = require("faith.icons").arrows.right,
				}

				if i <= #keys then
					local key = keys[i]

					if is_current then
						tabline = tabline .. "%#HarpoonNumberActive#" .. prefix .. key .. " %*" .. "%#HarpoonActive#"
					else
						tabline = tabline
							.. "%#HarpoonNumberInactive#"
							.. prefix
							.. key
							.. " %*"
							.. "%#HarpoonInactive#"
					end

					tabline = tabline .. label .. suffix .. "%*"
				else
					extra_marks = extra_marks + 1
					tabline = tabline .. "%#HarpoonNumberActive#" .. " +" .. extra_marks .. "%*" .. "%#HarpoonActive#"
				end
			end
		end

		return tabline
	end,
	cond = function()
		return package.loaded.harpoon ~= nil and next(require("harpoon"):list().items) ~= nil
	end,
}

local show_macro_recording = {
	function()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return ""
		else
			return "Recording @" .. recording_register
		end
	end,
}

vim.api.nvim_create_augroup("MacroStatusLine", { clear = true })
vim.api.nvim_create_autocmd("RecordingEnter", {
	group = "MacroStatusLine",
	callback = function()
		lualine.refresh({
			place = { "statusline" },
		})
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	group = "MacroStatusLine",
	callback = function()
		local timer = vim.loop.new_timer()
		timer:start(
			50,
			0,
			vim.schedule_wrap(function()
				lualine.refresh({
					place = { "statusline" },
				})
			end)
		)
	end,
})

local git_conflict = {
	function()
		return "%#lualine_b_diagnostics_error_normal#" .. "Conflicts: " .. require("git-conflict").conflict_count()
	end,
	cond = function()
		return require("git-conflict").conflict_count() > 0
	end,
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "catppuccin",
		-- component_separators = { left = '', right = ''},
		-- section_separators = { left = '', right = ''},
		component_separators = { left = icons.separators.straight.left, right = icons.separators.straight.right },
		section_separators = { left = "", right = "" },
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 120,
			tabline = 240,
			winbar = 120,
		},
	},
	sections = {
		lualine_a = { git },
		lualine_b = { obsession, workspace_diagnostics, git_conflict },
		lualine_c = { language_server, asyncrun_status },
		lualine_x = { show_macro_recording, location, "SleuthIndicator", fileformat, encoding },
		lualine_y = { format_on_save },
		lualine_z = trans_flag,
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	winbar = {},
	-- inactive_winbar = winbar,
	tabline = {
		lualine_a = { root },
		lualine_b = { tabs },
		lualine_z = { harpoon },
	},
	extensions = {
		"fugitive",
		"nvim-dap-ui",
		"quickfix",
	},
})
