-- local overseer = require("overseer")
local constants = require("overseer.constants")
local TAG = constants.TAG

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
	name = "Generate and Build",
	tags = { TAG.BUILD },
	cache_key = function(opts)
		return get_cmake_file(opts)
	end,
	condition = {
		filetype = { "c", "cpp" },
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
	builder = function(params)
		local source_dir = vim.fs.dirname(assert(get_cmake_file(params)))
		local build_dir = source_dir .. "/build"

		return {
			name = "Cmake Generate + Ninja Build",
			strategy = {
				"orchestrator",
				tasks = {
					{
						name = "Cmake Generate",
						cmd = "cmake",
						args = {
							"-G",
							"Ninja",
							"-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
							"-S",
							source_dir,
							"-B",
							build_dir,
						},
					},
					{
						name = "Ninja: Build",
						cmd = "ninja",
						args = {
							"-C",
							build_dir,
							string.format(
								"-j%s",
								vim.fn.systemlist("nproc")[1]
							),
						},
					},
				},
			},
			components = { { "on_output_quickfix", open = false }, "default" },
		}
	end,
}
