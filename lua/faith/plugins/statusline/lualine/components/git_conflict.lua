local histr = require("faith.plugins.statusline.utils").histr

return {
	function()
		return histr(
			string.format(
				"Conflicts: %s",
				require("git-conflict").conflict_count()
			),
			"lualine_b_diagnostics_error_normal"
		)
	end,
	cond = function()
		return require("git-conflict").conflict_count() > 0
	end,
}
