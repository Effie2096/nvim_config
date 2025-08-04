local icons = require("faith.icons")

local winbar = require("faith.plugins.statusline.lualine.components.winbar")
local winbar_ft_icons = winbar.winbar_ft_icons
local dap_bar = winbar.dap_bar

local utils = require("faith.plugins.statusline.utils")
local format_bubble = utils.format_bubble
local qf_label = utils.qf_label
local qf_title = utils.qf_title
local trunc = utils.trunc
local histr = utils.histr

return {
	"filename",
	file_status = true, -- Displays file status (readonly status, modified status)
	newfile_status = true, -- Display new file status (new file means no write after created)
	path = 4, -- 0: Just the filename
	-- 1: Relative path
	-- 2: Absolute path
	-- 3: Absolute path, with tilde as the home directory
	-- 4: Filename and parent dir, with tilde as the home directory

	shorting_target = 40, -- Shortens path to leave 40 spaces in the window
	-- for other components. (terrible name, any suggestions?)
	symbols = {
		modified = histr(icons.ui.Dot, "BarDiagError"), -- Text to show when the file is modified.
		readonly = histr(icons.ui.Lock, "BarDiagError"), -- Text to show when the file is non-modifiable or readonly.
		unnamed = "[No Name]", -- Text to show for unnamed buffers.
		newfile = "[New]", -- Text to show for newly created file before first write
	},
	padding = { left = 0, right = 0 },
	separator = "",
	fmt = function(str)
		local name = str
		local ft = vim.bo.filetype
		local bt = vim.bo.buftype

		if winbar_ft_icons[ft] ~= nil or winbar_ft_icons[bt] ~= nil then
			local file_spec = winbar_ft_icons[ft] or winbar_ft_icons[bt]

			if ft == "dap-repl" then
				name = format_bubble(file_spec.name) .. dap_bar("", true)
				goto continue
			end

			if ft == "neo-tree" then
				name = file_spec.name
				goto continue
			end

			local spec_name = type(file_spec.name) == "function"
					and string.format(
						"%s: %s",
						file_spec.name()["name"],
						file_spec.name()["data"]
					)
				or file_spec.name

			if file_spec.name and not file_spec.icon then
				name = format_bubble(file_spec.name)
			elseif file_spec.name and file_spec.icon then
				name = string.format(
					"%s%s",
					histr(file_spec.icon .. " " or "", file_spec.hl or ""),
					format_bubble(spec_name)
				)
			else
				name = format_bubble(ft:gsub("^(%l)", string.upper)) or ""
			end
		end
		if ft == "qf" then
			name = string.format("%s %s", format_bubble(qf_label()), qf_title())
			goto continue
		end
		if string.match(ft, "dapui") ~= nil then
			name = format_bubble(
				string.gsub(ft:gsub("dapui_", ""), "^%l", string.upper)
			)
			goto continue
		end
		::continue::
		return trunc(name, 10, 0, 5, true)
	end,
}
