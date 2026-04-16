local constants = require("overseer.constants")
local overseer = require("overseer")
local TAG = constants.TAG

---@type overseer.TemplateFileDefinition
local tmpl = {
	name = "CMake",
	tags = { TAG.BUILD },
	params = {
		cmd = { optional = true, type = "string" },
		args = { optional = true, type = "list", delimiter = " " },
		cwd = { optional = true },
	},
	builder = function(params)
		return {
			cmd = { params.cmd or "cmake" },
			args = params.args,
			cwd = params.cwd,
		}
	end,
}

local function get_cmake_file(opts)
	return vim.fs.find("CMakeLists.txt", {
		upward = true,
		type = "file",
		path = opts.dir,
		stop = vim.fn.getcwd() .. "/..",
		limit = math.huge,
	})[1]
end

return {
	cache_key = function(opts)
		return get_cmake_file(opts)
	end,
	condition = {
		callback = function(opts)
			if vim.fn.executable("cmake") == 0 then
				return false, 'Command "cmake" not found'
			end
			if vim.fn.executable("ninja") == 0 then
				return false, 'Command "ninja" not found'
			end
			if not get_cmake_file(opts) then
				return false, 'No "CMakeLists.txt" file found'
			end
			return true
		end,
	},
	generator = function(opts, cb)
		local source_dir = vim.fs.dirname(assert(get_cmake_file(opts)))
		local build_dir = source_dir .. "/build"
		local run_default_prog = vim.fn.fnamemodify(source_dir, ":t")

		local ret = {}

		local commands = {
			{
				args = {
					"-G",
					"Ninja",
					"-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
					"-S",
					source_dir,
					"-B",
					build_dir,
				},
				tags = { TAG.BUILD },
			},
		}
		local roots = {
			{
				postfix = "",
				cwd = source_dir,
			},
		}
		for _, root in ipairs(roots) do
			for _, command in ipairs(commands) do
				table.insert(
					ret,
					overseer.wrap_template(tmpl, {
						name = string.format(
							"cmake %s%s",
							table.concat(command.args, " "),
							root.postfix
						),
						tags = command.tags,
					}, {
						args = command.args,
						cwd = root.cwd,
					})
				)
			end
		end

		table.insert(
			ret,
			overseer.wrap_template(tmpl, {
				name = string.format("Run: %s", run_default_prog),
				tags = { TAG.RUN },
			}, {
				cmd = string.format("%s/bin/%s", build_dir, run_default_prog),
				cwd = source_dir,
			})
		)

		cb(ret)
		-- local ret = {overseer.wrap_template(tmpl, nil, { cwd = cwd }) }
	end,
}
-- return {
--   name = "CMake build",
--   builder = function()
--     -- Full path to current file (see :help expand())
--     local file = vim.fn.expand("%:p")
-- 		local dir = vim.fn.cwd()
--     return {
--       cmd = { "cmake", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1", "-S", ".", "-B", "build" },
--       args = { "-G", "Ninja", "-B", "build",  },
--       components = { { "on_output_quickfix", open = true }, "default" },
--     }
--   end,
--   condition = {
--     filetype = { "cpp" },
--   },
-- }
