local M = {}

local function get_bufnr_from_name(name)
	local buflist = vim.fn["floaterm#buflist#gather"]()
	for _, bufnr in ipairs(buflist) do
		local bufname = vim.fn.getbufvar(bufnr, "floaterm_name")
		if bufname == name then
			return bufnr
		end
	end
	return -1
end

M.toggleFloaterm = function(args)
	local name = args:match("--name=([^%s]+)")
	local bufnr = get_bufnr_from_name(name)

	if bufnr == -1 then
		vim.cmd("FloatermNew" .. args)
	else
		vim.cmd("FloatermToggle " .. name)
	end
end

---@alias floaterm.Cwd
---| '"<root>"'
---| '"<buffer>"'
---| '"<buffer-root>"'

---@alias floaterm.Wintype
---| '"split"'
---| '"vsplit"'
---| '"float"'

---@alias floaterm.Position
---| '"leftabove"'
---| '"aboveleft"'
---| '"rightbelow"'
---| '"belowright"'
---| '"topleft"'
---| '"botright"'

---@alias floaterm.Opener
---| '"edit"'
---| '"split"'
---| '"vsplit"'
---| '"tabe"'
---| '"drop"'

---@alias floaterm.TitlePosition
---| '"left"'
---| '"center"'
---| '"right"'

---@enum floaterm.Autoclose
M.AUTOCLOSE = {
	NEVER = 0,
	STATUS = 1,
	ALWAYS = 2,
}

---@class floaterm.Opts
---@field name string --name of the floaterm
---@field cwd? string | floaterm.Cwd
---@field silent? boolean --spawn a floaterm but not open the window
---@field disposable? boolean --whether floaterm will be destroyed once it is hidden
---@field title? string
---@field width? integer | decimal -- number of columns or percentage of screen width as a decimal
---@field height? integer | decimal -- number of rows or percentage of screen height as a decimal
---@field opener? floaterm.Opener
---@field wintype? floaterm.Wintype
---@field position? floaterm.Position
---@field autoclose? floaterm.Autoclose
---@field borderchars? string
---@field titleposition? floaterm.TitlePostion

--- Format structured dictionary of Floaterm args into a single string
---@param args floaterm.Opts
---@param cmd? string --shell command
---@return string string floaterm arguments formatted for :FloatermNew
M.construct_args = function(args, cmd)
	args.title = string.format("%s\\ ($1|$2)", args.title)
	local argument_string = vim.iter(args):fold("", function(acc, k, v)
		acc = acc .. " --" .. k .. "=" .. v
		return acc
	end)

	if cmd then
		argument_string = argument_string .. " " .. cmd
	end

	return argument_string
end

M.term_opts = function()
	local direction = vim.o.columns > 180 and "vertical" or "horizontal"
	local size = 16
	if direction == "horizontal" then
		local term_win_height = math.floor(vim.o.lines * 0.2)
		size = term_win_height > 120 and term_win_height or 10
	elseif direction == "vertical" then
		local term_win_width = math.floor(vim.o.columns * 0.4)
		size = term_win_width > 81 and term_win_width or 81
	end
	return { size = size, direction = direction }
end

return M
