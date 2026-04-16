local constants = require("overseer.constants")
local overseer = require("overseer")
local TAG = constants.TAG

---@type overseer.TemplateFileDefinition
local tmpl = {
	name = "dune",
	tags = { TAG.BUILD },
	params = {
		args = { optional = true, type = "list", delimiter = " " },
		cwd = { optional = true },
	},
	builder = function(params)
		return {
			cmd = { "dune" },
			args = params.args,
			cwd = params.cwd,
		}
	end,
}

local function get_dune_file(opts)
	return vim.fs.find(
		"dune-project",
		{ upward = true, type = "file", path = opts.dir }
	)[1]
end

return {
	cache_key = function(opts)
		return get_dune_file(opts)
	end,
	condition = {
		callback = function(opts)
			if vim.fn.executable("dune") == 0 then
				return false, 'Command "dune" not found'
			end
			if not get_dune_file(opts) then
				return false, "No dune-project file found"
			end
			return true
		end,
	},
	generator = function(opts, cb)
		local dune_dir = vim.fs.dirname(assert(get_dune_file(opts)))
		local dune_default_prog = vim.fn.fnamemodify(dune_dir, ":t")

		local ret = {}

		local commands = {
			{ args = { "build" }, tags = { TAG.BUILD } },
			{ args = { "exec", dune_default_prog }, tags = { TAG.RUN } },
			{
				args = { "runtest", "--stop-on-first-error" },
				tags = { TAG.TEST },
			},
			{ args = { "clean" }, tags = { TAG.CLEAN } },
		}
		local roots = { {
			postfix = "",
			cwd = dune_dir,
		} }
		for _, root in ipairs(roots) do
			for _, command in ipairs(commands) do
				table.insert(
					ret,
					overseer.wrap_template(tmpl, {
						name = string.format(
							"dune %s%s",
							table.concat(command.args, " "),
							root.postfix
						),
						tags = command.tags,
					}, { args = command.args, cwd = root.cwd })
				)
			end
			table.insert(
				ret,
				overseer.wrap_template(
					tmpl,
					{ name = "dune" .. root.postfix },
					{ cwd = root.cwd }
				)
			)
		end
		cb(ret)
		-- local ret = {overseer.wrap_template(tmpl, nil, { cwd = cwd }) }
	end,
}
-- return {
-- 	name = "dune run",
-- 	builder = function()
-- 		local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t:h")
-- 		return {
-- 			cmd = { "dune" },
-- 			args = { "exec", project },
-- 			components = { { "on_output_quickfix", open = false }, "default" },
-- 		}
-- 	end,
-- 	tags = { require("overseer").TAG.RUN },
-- 	condition = {
-- 		filetype = { "ocaml" },
-- 	},
-- }

-- return {
-- 	name = "dune build",
-- 	builder = function()
-- 		local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t:h")
-- 		return {
-- 			cmd = { "dune" },
-- 			args = { "build" },
-- 			components = { { "on_output_quickfix", open = false }, "default" },
-- 		}
-- 	end,
-- 	tags = { require("overseer").TAG.BUILD },
-- 	condition = {
-- 		filetype = { "ocaml" },
-- 	},
-- }
