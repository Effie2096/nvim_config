local files = require("overseer.files")
local constants = require("overseer.constants")
local TAG = constants.TAG

local settings = {
	port = 5500,
}

---@type overseer.TemplateFileProvider
return {
	generator = function(opts, cb)
		if vim.fn.executable("npx") == 0 then
			return "executable npx not found"
		end

		local servables = vim.fs.find(
			"index.html",
			{ type = "file", path = vim.fn.getcwd(), limit = 20 }
		)
		if not servables then
			return "no servable files found in project"
		end

		local dir_specs = vim
			.iter(servables)
			:map(function(file)
				return {
					file = vim.fs.basename(file),
					dir = vim.fs.dirname(file),
				}
			end)
			:totable()

		local ret = vim
			.iter(dir_specs)
			:map(function(spec)
				return {
					name = ("%s/%s"):format(spec.dir, spec.file),
					tags = { TAG.RUN },
					builder = function()
						return {
							cmd = "npx",
							args = {
								"http-server",
								spec.dir,
								"-o",
								"-p",
								tostring(settings.port),
							},
							cwd = spec.dir,
						}
					end,
				}
			end)
			:totable()

		cb(ret)
	end,
}
