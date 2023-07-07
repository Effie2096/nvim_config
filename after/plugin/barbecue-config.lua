local has_barbecue, barbecue = pcall(require, "barbecue")
if not has_barbecue then
	return
end

local icons = require("faith.icons")

barbecue.setup({
	theme = "catppuccin", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
	attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
	create_autocmd = false,
	show_dirname = false,
	show_modified = true,
	-- context_follow_icon_color = true,
	symbols = {
		modified = icons.ui.Dot,
		ellipsis = icons.ui.Ellipses,
		separator = icons.ui.ChevronRight,
	},
	lead_custom_section = function(_, winnr)
		return {
			{ icons.separators.rounded.right, "CatAccentInverse" },
			{ string.format("%s", vim.api.nvim_win_get_number(winnr)), "CatAccent" },
			{ icons.separators.rounded.left, "CatAccentInverse" },
			{ " " },
		}
	end,
	custom_section = function(bufnr, _)
		local diagnostics = { error = "", warn = "", info = "", hint = "" }
		local total = 0
		for level, _ in pairs(diagnostics) do
			local count = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity[string.upper(level)] })
			if count == 0 then
				goto continue
			end

			total = total + 1
			local part = string.format("%s%s ", icons.diagnostic[level], count)
			diagnostics[level] = part

			::continue::
		end

		return total == 0 and { { icons.ui.Check, "healthSuccess" } } or {
			{ diagnostics["error"], "DiagnosticError" },
			{ diagnostics["warn"], "DiagnosticWarn" },
			{ diagnostics["info"], "DiagnosticInfo" },
			{ diagnostics["hint"], "DiagnosticHint" },
		}
	end,
	kinds = {
		File = icons.kind.File,
		Module = icons.kind.Module,
		Namespace = icons.kind.Namespace,
		Package = icons.kind.Package,
		Class = icons.kind.Class,
		Method = icons.kind.Method,
		Property = icons.kind.Property,
		Field = icons.kind.Field,
		Constructor = icons.kind.Constructor,
		Enum = icons.kind.Enum,
		Interface = icons.kind.Interface,
		Function = icons.kind.Function,
		Variable = icons.kind.Variable,
		Constant = icons.kind.Constant,
		String = icons.kind.String,
		Number = icons.kind.Number,
		Boolean = icons.kind.Boolean,
		Array = icons.kind.Array,
		Object = icons.kind.Object,
		Key = icons.kind.Key,
		Null = icons.kind.Null,
		EnumMember = icons.kind.EnumMember,
		Struct = icons.kind.Struct,
		Event = icons.kind.Event,
		Operator = icons.kind.Operator,
		TypeParameter = icons.kind.TypeParameter,
	},
})

vim.api.nvim_create_autocmd({
  "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
  "BufWinEnter",
  "CursorHold",
  "CursorMoved",
  "InsertLeave",

  -- include this if you have set `show_modified` to `true`
  "BufModifiedSet",
}, {
  group = vim.api.nvim_create_augroup("barbecue.updater", {}),
  callback = function()
	require("barbecue.ui").update()
  end,
})
