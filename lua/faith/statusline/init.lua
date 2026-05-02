local histr = require("faith.statusline.utils").histr
local icons = require("faith.icons")

vim.opt.statusline = "%="

vim.opt.statusline:append(
	" %{%v:lua.require('faith.statusline.components.harpoon').statusline()%}"
)

vim.opt.statusline:append("%=")

-- function Trans_Flag()
-- 	return string.format(
-- 		"%s%s%s%s%s",
-- 		histr("█", "Trans_Blue"),
-- 		histr("█", "Trans_Pink"),
-- 		histr("█", "Trans_White"),
-- 		histr("█", "Trans_Pink"),
-- 		histr("█", "Trans_Blue")
-- 	)
-- end
-- vim.opt.statusline:append("%{%v:lua.Trans_Flag()%}")

function Winbar()
	local win = vim.api.nvim_get_current_win()
	local ft = vim.o.filetype

	local result = ""
	if
		vim.list_contains({
			"dap-repl",
			"dapui_breakpoints",
			"dapui_console",
			"dapui_scopes",
			"dapui_stacks",
			"dapui_watches",
		}, ft)
	then
		result = result
			.. histr(
				(" %d "):format(vim.api.nvim_win_get_number(win)),
				"AccentInverse",
				true
			)
		if ft == "dap-repl" then
			result = result
				.. "%{%v:lua.require('faith.statusline.components.dap_bar')()%}"
		else
			result = result .. string.gsub(ft:gsub("dapui_", ""), "^%l", string.upper)
		end
	end
	return result
end

vim.api.nvim_create_augroup("winbars", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "winbars",
	desc = "Add statusline to dap ui",
	pattern = { "*" },
	callback = function()
		local win_ids = vim.api.nvim_list_wins()
		-- Iterate through each window ID and check the filetype of its associated buffer
		for _, win_id in ipairs(win_ids) do
			local buf_id = vim.api.nvim_win_get_buf(win_id)
			local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id })
			if
				vim.list_contains({
					"dap-repl",
					"dapui_breakpoints",
					"dapui_console",
					"dapui_scopes",
					"dapui_stacks",
					"dapui_watches",
				}, buf_ft)
			then
				local win_number = histr(
					(" %d "):format(vim.api.nvim_win_get_number(win_id)),
					"AccentInverse",
					true
				)
				if buf_ft == "dap-repl" then
					vim.api.nvim_set_option_value(
						"winbar",
						("%%=%s  %s %s "):format(
							"%{%v:lua.require('faith.statusline.components.dap_bar')()%}",
							win_number,
							"Repl"
						),
						{ win = win_id }
					)
				else
					vim.api.nvim_set_option_value(
						"winbar",
						("%%=%s %s "):format(
							win_number,
							string.gsub(buf_ft:gsub("dapui_", ""), "^%l", string.upper)
						),
						{ win = win_id }
					)
					-- result = result .. string.gsub(buf_ft:gsub("dapui_", ""), "^%l", string.upper)
				end
			end
		end
	end,
})
