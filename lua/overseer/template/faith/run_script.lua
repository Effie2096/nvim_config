local constants = require("overseer.constants")
local overseer = require("overseer")
local TAG = constants.TAG
local files = require("overseer.files")

local script_ext = {
	sh = {
		cmd = "bash",
		args = {},
	},
	bat = {
		cmd = "cmd",
		args = { "/c" },
	},
	ps1 = {
		cmd = "powershell",
		args = { "-File" },
	},
	nu = {
		cmd = "nu",
		args = {},
	},
}

local function get_root(opts)
	return vim.fs.dirname(
		vim.fs.find(".git", { path = opts.dir, upwards = true })[1]
	) or vim.fn.getcwd()
end

return {
	cache_key = function(opts)
		return get_root(opts)
	end,
	generator = function(opts, cb)
		local root = get_root(opts)

		local scripts = vim
			.iter(files.list_files(root))
			:filter(function(filename)
				return vim.iter(pairs(script_ext)):find(function(k, _)
					return filename:match(string.format("%%.%s$", k))
				end)
			end)
			:totable()

		if not scripts then
			return "no scripts found"
		end

		local ret = vim
			.iter(vim.deepcopy(scripts))
			:map(function(filename)
				return {
					filename = filename,
					script_spec = script_ext[filename:match("%.([^\\/%.]-)%.?$")],
				}
			end)
			:filter(function(spec)
				return vim.fn.executable(spec.script_spec.cmd) == 1
			end)
			:map(function(spec)
				return {
					name = spec.filename,
					tags = { TAG.RUN },
					builder = function()
						return {
							cmd = spec.script_spec.cmd,
							args = vim.list_extend(
								vim.deepcopy(spec.script_spec.args) or {},
								{ spec.filename }
							),
							cwd = root,
						}
					end,
				}
			end)
			:totable()

		cb(ret)
	end,
}
