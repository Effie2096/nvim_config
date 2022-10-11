local status_ok, comment = pcall(require, 'Comment')
if not status_ok then
	return
end

local status_ok_1, _ = pcall(require, "lsp-inlayhints")
if not status_ok_1 then
	return
end

comment.setup {
	opleader = {
		line = "gc",
		block = "gb",
	},
	mappings = {
		basic = true,
		extra = true,
	},
	ignore = "^$",
	pre_hook = function(ctx)
		-- For inlay hints
		local line_start = (ctx.srow or ctx.range.srow) - 1
		local line_end = ctx.erow or ctx.range.erow
		require("lsp-inlayhints.core").clear(0, line_start, line_end)

		require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()

		if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" then
			local U = require "Comment.utils"

			-- Determine whether to use linewise or blockwise commentstring
			local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

			-- Determine the location where to calculate commentstring from
			local location = nil
			if ctx.ctype == U.ctype.blockwise then
				location = require("ts_context_commentstring.utils").get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = require("ts_context_commentstring.utils").get_visual_start_location()
			end

			return require("ts_context_commentstring.internal").calculate_commentstring {
				key = type,
				location = location,
			}
		end
	end,
}

local api = require('Comment.api')
local map = vim.keymap.set

map('n', 'g>', api.call('comment.linewise', 'g@'), { expr = true, desc = 'Comment region linewise' })
map('n', 'g>c', api.call('comment.linewise.current', 'g@$'), { expr = true, desc = 'Comment current line' })
map('n', 'g>b', api.call('comment.blockwise.current', 'g@$'), { expr = true, desc = 'Comment current block' })

map('n', 'g<', api.call('uncomment.linewise', 'g@'), { expr = true, desc = 'Uncomment region linewise' })
map('n', 'g<c', api.call('uncomment.linewise.current', 'g@$'), { expr = true, desc = 'Uncomment current line' })
map('n', 'g<b', api.call('uncomment.blockwise.current', 'g@$'), { expr = true, desc = 'Uncomment current block' })

local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

map('x', 'g>', function()
	vim.api.nvim_feedkeys(esc, 'nx', false)
	api.locked('comment.linewise')(vim.fn.visualmode())
end, { desc = 'Comment region linewise (visual)' })

map('x', 'g<', function()
	vim.api.nvim_feedkeys(esc, 'nx', false)
	api.locked('uncomment.linewise')(vim.fn.visualmode())
end, { desc = 'Uncomment region linewise (visual)' })
