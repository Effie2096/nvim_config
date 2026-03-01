local Path = require("plenary.path")
local function path_parts(path)
	local normalized = vim.fs.normalize(vim.fn.expand(path))
	return vim.split(normalized, "/", { plain = true, trimempty = true })
end

local icons = require("faith.icons")
local winbar_ignore = require(
	"faith.plugins.statusline.lualine.components.winbar"
).ignore.winbar_ignore
local utils = require("faith.plugins.statusline.utils")
local histr = utils.histr

local sep = histr(icons.ui.ChevronRight, "Comment")

return {
	function()
		local pathI = vim
			.iter(
				path_parts(
					Path:new(vim.api.nvim_buf_get_name(0)):make_relative(vim.uv.cwd())
				)
			)
			:rskip(1)

		if pathI:peek() == nil then
			return ""
		end

		local path_crumbs = pathI
			:map(function(folder)
				return ("%s%s"):format(
					histr(icons.kind.Folder, "LspKindFolder"),
					histr(folder, "Comment")
				)
			end)
			:join(sep .. " ")

		return path_crumbs .. sep
	end,
	padding = { left = 0, right = 0 },
	separator = "",
	cond = winbar_ignore,
}
