local modules = require("lualine_require").lazy_require({
	highlight = "lualine.highlight",
	utils = "lualine.utils.utils",
})

local icons = require("faith.icons")
local histr = require("faith.statusline.utils").histr
local harpoon_d = require("faith.statusline.components.harpoon")

local M = require("lualine.component"):extend()

local default_options = {
	symbols = {
		separator = "|",
	},
}

function M:init(options)
	M.super.init(self, options)
	self.options.component_name = "harpoon"
	self.options =
		vim.tbl_deep_extend("keep", self.options or {}, default_options)
	-- self.highlight_groups = {
	-- 	active = {
	-- 		key = self:create_hl({
	-- 			fg = modules.utils.extract_highlight_colors(
	-- 				harpoon_d.highlights.active.number,
	-- 				"fg"
	-- 			),
	-- 		}),
	-- 		lable = self:create_hl({
	-- 			fg = modules.utils.extract_highlight_colors(
	-- 				harpoon_d.highlights.active.lable,
	-- 				"fg"
	-- 			),
	-- 		}),
	-- 	},
	-- 	inactive = {
	-- 		key = self:create_hl({
	-- 			fg = modules.utils.extract_highlight_colors(
	-- 				harpoon_d.highlights.inactive.number,
	-- 				"fg"
	-- 			),
	-- 		}),
	-- 		lable = self:create_hl({
	-- 			fg = modules.utils.extract_highlight_colors(
	-- 				harpoon_d.highlights.inactive.lable,
	-- 				"fg"
	-- 			),
	-- 		}),
	-- 	},
	-- }
end

function M:update_status()
	local data = harpoon_d.get_data()
	local prefix = {}
	local marks = {}
	local postfix = {}

	if data.marks then
		marks = vim
			.iter(data.marks)
			:map(function(mark)
				return ("%s %s %s%s%s"):format(
					histr(mark.key.text, mark.key.group, true),
					histr(mark.icon.text, mark.icon.group, true),
					mark.prefix and histr(mark.prefix.text, mark.prefix.group, true) or "",
					histr(mark.lable.text, mark.lable.group, true),
					mark.postfix
							and histr(
								vim
									.iter(harpoon_d.splitIntoLetters(mark.postfix.text))
									:map(function(letter)
										return icons.letters.superscript[letter:lower()] or letter
									end)
									:join(""),
								mark.postfix.group,
								true
							)
						or ""
				)
			end)
			:totable()
	end
	if data.prefix then
		prefix = vim
			.iter(data.prefix)
			:map(function(part)
				return histr(part.text, part.group, true)
			end)
			:totable()
	end
	if data.postfix then
		postfix = vim
			.iter(data.postfix)
			:map(function(part)
				return histr(part.text, part.group, true)
			end)
			:totable()
	end

	return vim.iter({ prefix, marks, postfix }):flatten():join(
		" "
			.. histr(self.options.symbols.separator, harpoon_d.highlights.separator)
			.. " "
	)
end

return M
