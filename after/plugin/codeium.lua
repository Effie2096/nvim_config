-- if not vim.fn.exists("g:codeium_filetypes") == 1 then
--	return
-- end

-- vim.g.codeium_no_map_tab = 1
-- vim.keymap.set("i", "<C-CR>", function()
--	return vim.fn["codeium#Accept"]()
-- end, { expr = true })

-- vim.api.nvim_exec(
--	[[
--	let g:codeium_filetypes = {
--			\ 'TelescopePrompt': v:false,
--			\ }
--	]],
--	false
-- )
local has_codeium, codeium = pcall(require, "codeium")
if not has_codeium then
	return
end

codeium.setup()
