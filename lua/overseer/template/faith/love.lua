local constants = require("overseer.constants")
local overseer = require("overseer")
local TAG = constants.TAG

local util = require("lspconfig.util")

local tmpl = {
	priority = 60,
	params = {
		args = { optional = true, type = "list", delimiter = " " },
		cwd = { optional = true },
		bin = { optional = true, type = "string" },
	},
	builder = function(params)
		return {
			cmd = { params.bin },
			args = params.args,
			cwd = params.cwd,
		}
	end,
}
local function get_boon_file(opts)
	return vim.fs.find(
		"Boon.toml",
		{ upward = true, type = "file", path = opts.dir }
	)[1]
end

local function get_love_file(opts)
	return vim.fs.find(function(name, path)
		return name:match(".*%.love") and path:match("[/\\\\]release$")
	end, { type = "file", path = opts.dir })
end

local get_root_dir = function(opts)
	local boon_file = get_boon_file(opts)
	if boon_file then
		return vim.fs.dirname(boon_file)
	end
	local git_root = vim.fn.dirname(
		vim.fn.find(".git", { path = opts.dir, upward = true })[1]
	)
	if git_root then
		return git_root
	end
	return opts.dir
end

return {
	cache_key = function(opts)
		return get_boon_file(opts)
	end,
	condition = {
		callback = function(opts)
			if vim.fn.executable("love") == 0 then
				return false, 'Command "love" not found'
			end
			if vim.fn.executable("boon") == 0 then
				return false, 'Command "boon" not found'
			end
			if not get_boon_file(opts) then
				return false, "No Boon.toml file found"
			end
			return true
		end,
	},
	generator = function(opts, cb)
		local boon_dir = vim.fs.dirname(assert(get_boon_file(opts)))
		local executable = get_love_file(opts)[1]
		local root_dir = get_root_dir(opts)

		local ret = {}

		local commands = {
			{
				cmd = "boon",
				args = { "build", boon_dir },
				tags = { TAG.BUILD },
			},
			{ cmd = "love", args = { root_dir }, tags = { TAG.RUN } },
			{ cmd = "boon", args = { "clean" }, tags = { TAG.CLEAN } },
		}
		local roots =
			{ {
				postfix = "",
				cwd = root_dir,
				priority = 55,
			} }
		for _, root in ipairs(roots) do
			for _, command in ipairs(commands) do
				table.insert(
					ret,
					overseer.wrap_template(tmpl, {
						name = string.format(
							"%s %s%s",
							command.cmd,
							table.concat(command.args, " "),
							root.postfix
						),
						tags = command.tags,
						priority = root.priority,
					}, {
						args = command.args,
						bin = command.cmd,
						cwd = root.cwd,
					})
				)
			end
		end
		cb(ret)
	end,
}
