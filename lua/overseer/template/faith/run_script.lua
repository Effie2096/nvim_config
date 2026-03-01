local constants = require("overseer.constants")
local overseer = require("overseer")
local TAG = constants.TAG
local files = require("overseer.files")

local script_ext = {
	sh = {
		cmd = "bash",
		args = {},
	},
	nu = {
		cmd = "nu",
		args = {},
	},
	bat = {
		cmd = "cmd",
		args = "/c",
	},
	ps1 = {
		cmd = "powershell",
		args = { "-File" },
	},
}

local function get_root(opts)
	return vim.fs.dirname(
		vim.fs.find(".git", { path = opts.dir, upwards = true })[1]
	) or vim.fn.getcwd()
end

return {
	generator = function(opts, cb)
		local root = get_root(opts)

		local scripts = vim.tbl_filter(function(filename)
			return vim.iter(pairs(script_ext)):find(function(k, _)
				return filename:match(string.format("%%.%s$", k))
			end)
		end, files.list_files(root))

		if not scripts then
			return "no scripts found"
		end

		local ret = {}
		for _, filename in ipairs(scripts) do
			local script_spec = script_ext[filename:match("%.([^\\/%.]-)%.?$")]

			local args = {}
			if script_spec.args ~= nil then
				vim.list_extend(args, script_spec.args)
			end
			-- table.insert(args, vim.fn.glob(("%s/%s"):format(root, filename), true))
			table.insert(args, filename)

			table.insert(ret, {
				name = filename,
				tags = { TAG.RUN },
				priority = 55,
				builder = function()
					return {
						cmd = script_spec.cmd,
						args = args or "",
						cwd = root,
					}
				end,
			})
		end

		cb(ret)
	end,
}
