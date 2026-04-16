local constants = require("overseer.constants")
local overseer = require("overseer")
local TAG = constants.TAG
local files = require("overseer.files")

local function get_root(opts)
	return vim.fs.dirname(
		vim.fs.find(
			".cooklang",
			{ path = opts.dir, type = "directory", upwards = true }
		)[1]
	) or vim.fn.getcwd()
end

local function get_cook_cmd(opts)
	local cmd = {}
	if vim.fn.executable("chef") == 1 then
		table.insert(cmd, "chef")
	end
	if vim.fn.executable("cook") == 1 then
		table.insert(cmd, "cook")
	end

	if #cmd > 0 then
		return cmd
	end

	return nil, "No cook command found"
end

---@type overseer.TemplateFileProvider
return {
	generator = function(opts, cb)
		local file = vim.api.nvim_buf_get_name(0)
		if
			(opts.filetype ~= "cook") or vim.fn.fnamemodify(file, ":e") ~= "cook"
		then
			return "Filetype is not cook"
		end

		local root = get_root(opts)
		local cli, err = get_cook_cmd(opts)

		if not cli then
			return err
		end

		local ret = {}

		for _, cmd in pairs(cli) do
			table.insert(ret, {
				name = string.format("%s %s", cmd, vim.fn.fnamemodify(file, ":p:.")),
				tags = { TAG.RUN },
				builder = function()
					return {
						cmd = cmd,
						args = { "recipe", vim.fn.fnamemodify(file, ":p:.") },
						cwd = root,
					}
				end,
			})
		end
		cb(ret)
	end,
	cache_key = function(opts)
		return get_root(opts)
	end,
}
