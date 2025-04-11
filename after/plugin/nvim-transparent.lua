local status_ok, transparent = pcall(require, "transparent")
if not status_ok then
	return
end

local function list_fileicons()
	local barbecue_fileicons = {}
	local fileicons = require("nvim-web-devicons").get_icons_by_extension()
	for _, value in pairs(fileicons) do
		table.insert(barbecue_fileicons, "barbecue_fileicon_" .. value.name)
	end

	return barbecue_fileicons
end

transparent.setup({
	extra_groups = vim.tbl_extend("force", list_fileicons(), {
		"NormalFloat",
		"NvimTreeNormal",
		"NvimTreeWinSeparator",

		"CatAccentInverse",

		"FidgetTitle",
		"FidgetTask",

		"BufferCurrent",
		"BufferCurrentIndex",
		"BufferCurrentMod",
		"BufferCurrentSign",
		"BufferCurrentTarget",
		"BufferVisible",
		"BufferVisibleIndex",
		"BufferVisibleMod",
		"BufferVisibleSign",
		"BufferVisibleTarget",
		"BufferInactive",
		"BufferInactiveIndex",
		"BufferInactiveMod",
		"BufferInactiveSign",
		"BufferInactiveTarget",
		"BufferTabpages",
		"BufferTabpage",

		"BarDiagError",
		"BarDiagWarn",
		"BarDiagInfo",
		"BarDiagHint",
		"DiagnosticCheck",

		"TreesitterContextBottom",
		"TreesitterContextLineNumber",

		"lualine_c_normal",

		"barbecue_normal",
		"barbecue_modified",
		"barbecue_ellipsis",
		"barbecue_separator",
		"barbecue_dirname",
		"barbecue_basename",
		"barbecue_context",
		"barbecue_context_file",
		"barbecue_context_module",
		"barbecue_context_namespace",
		"barbecue_context_package",
		"barbecue_context_class",
		"barbecue_context_method",
		"barbecue_context_property",
		"barbecue_context_field",
		"barbecue_context_constructor",
		"barbecue_context_enum",
		"barbecue_context_interface",
		"barbecue_context_function",
		"barbecue_context_variable",
		"barbecue_context_constant",
		"barbecue_context_string",
		"barbecue_context_number",
		"barbecue_context_boolean",
		"barbecue_context_array",
		"barbecue_context_object",
		"barbecue_context_key",
		"barbecue_context_null",
		"barbecue_context_enum_member",
		"barbecue_context_struct",
		"barbecue_context_event",
		"barbecue_context_operator",
		"barbecue_context_type_parameter",

		"GitSignsAdd",
		"GitSignsChange",
		"GitSignsDelete",
		"GitSignsStagedAdd",
		"GitSignsStagedAddLn",
		"GitSignsStagedAddNr",
		"GitSignsStagedChange",
		"GitSignsStagedChangeDelete",
		"GitSignsStagedChangeDeleteLn",
		"GitSignsStagedChangeDeleteNr",
		"GitSignsStagedChangeLn",
		"GitSignsStagedChangeNr",
		"GitSignsStagedDelete",
		"GitSignsStagedDeleteNr",
		"GitSignsStagedTogdeleteNr",
		"GitSignsStagedTopdelete",
	}),
})
