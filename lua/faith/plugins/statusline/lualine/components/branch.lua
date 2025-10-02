local icons = require("faith.icons")
local histr = require("faith.plugins.statusline.utils").histr

return {
	"branch",
	icon = { "" },
	color = "WinBar",
	padding = { left = 0, right = 0 },
	fmt = function(str)
		return string.format(
			"on %s",
			histr(icons.git.Branch .. str, "BranchIndicator", true)
		)
	end,
	cond = function()
		return require("lualine.components.branch.git_branch").find_git_dir()
			~= nil
	end,
}
