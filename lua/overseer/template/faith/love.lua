local constants = require("overseer.constants")
local overseer = require("overseer")
local TAG = constants.TAG

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
	return vim.fs.find("Boon.toml", { upward = true, type = "file", path = opts.dir })[1]
end

local function get_love_file(opts)
	return vim.fs.find(function(name, path)
		return name:match(".*%.love") and path:match("[/\\\\]release$")
	end, { type = "file", path = opts.dir })
end

return {
	cache_key = function(opts)
		return get_boon_file(opts)
	end,
	condition = {
		callback = function(opts)
			if vim.fn.executable("boon") == 0 then
				return false, 'Command "boon" not found'
			end
			if vim.fn.executable("lovec") == 0 then
				return false, 'Command "lovec" not found'
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

		local ret = {}

		local commands = {
			{ cmd = "boon", args = { "build", boon_dir }, tags = { TAG.BUILD } },
			{ cmd = "lovec", args = { executable }, tags = { TAG.RUN } },
			{ cmd = "boon", args = { "clean" }, tags = { TAG.CLEAN } },
		}
		local roots = { {
			postfix = "",
			cwd = boon_dir,
			priority = 55,
		} }
		for _, root in ipairs(roots) do
			for _, command in ipairs(commands) do
				table.insert(
					ret,
					overseer.wrap_template(tmpl, {
						name = string.format("%s %s%s", command.cmd, table.concat(command.args, " "), root.postfix),
						tags = command.tags,
						priority = root.priority,
					}, { args = command.args, bin = command.cmd, cwd = root.cwd })
				)
			end
		end
		cb(ret)
	end,
}
