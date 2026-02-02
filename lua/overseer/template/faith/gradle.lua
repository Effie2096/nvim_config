local overseer = require("overseer")
local constants = require("overseer.constants")
local TAG = constants.TAG

local root_markers =
	{ "gradlew", "settings.gradle", "settings.gradle.kts", ".git" }
local app_markers = { "build.gradle", "build.gradle.kts" }

---@param opts overseer.SearchParams
---@return nil|string
local function get_workspace_root(opts)
	return vim.fs.dirname(
		vim.fs.find(
			root_markers,
			{ path = opts.dir, type = "file", upward = true, limit = math.huge }
		)[1]
	)
end

---@param opts overseer.SearchParams
---@return nil|string
local function get_app_root(opts)
	return vim.fs.dirname(
		vim.fs.find(
			app_markers,
			{ path = opts.dir, type = "file", upward = true, limit = math.huge }
		)[1]
	)
end

local commands = {
	{ task = "run", args = {}, tags = { TAG.RUN } },
	{ task = "build", args = {}, tags = { TAG.BUILD } },
	{ task = "test", args = {}, tags = { TAG.TEST } },
	{ task = "clean", args = {}, tags = { TAG.CLEAN } },
	{ task = "jar", args = {} },
	{ task = "javadoc", args = {} },
	{ task = "check", args = {} },
}

local global_args = { "--console=plain" }

---@type overseer.TemplateFileProvider
return {
	cache_key = function(opts)
		return get_workspace_root(opts)
	end,
	generator = function(opts, cb)
		if vim.fn.executable("gradlew") == 0 then
			return 'Command "gradlew" not found'
		end

		local workspace_root = get_workspace_root(opts)
		local app_root = get_app_root(opts)

		if not workspace_root and not app_root then
			return "No gradle project found"
		end

		local app_name = vim.fs.basename(app_root)

		local ret = {}

		local roots = {
			{
				postfix = " (workspace)",
				app = "",
				cwd = workspace_root,
			},
			{
				postfix = (" (%s)"):format(app_name),
				app = (":%s:"):format(app_name),
				cwd = workspace_root,
			},
		}

		for _, root in ipairs(roots) do
			for _, command in ipairs(commands) do
				table.insert(ret, {
					name = ("gradlew %s%s%s %s%s"):format(
						root.app,
						command.task,
						vim.iter(command.args):join(" "),
						vim.iter(global_args):join(" "),
						root.postfix
					),
					tags = command.tags,
					builder = function()
						return {
							cmd = ("gradlew %s%s %s%s"):format(
								root.app,
								command.task,
								vim.iter(command.args):join(" "),
								vim.iter(global_args):join(" ")
							),
							cwd = root.cwd,
							components = {
								{
									"on_output_quickfix",
									items_only = true,
									open_on_match = true,
								},
								{
									"on_complete_notify",
									system = "unfocused",
								},
								{ "on_exit_set_status" },
								{ "on_complete_dispose", timeout = 300 },
							},
							default_component_params = {
								errorformat = [[%E%f:%l:%c:\ %m]]
									.. [[,%E%f:%l:\ %m]]
									.. [[,%W%f:%l:%c:\ %m]]
									.. [[,%W%f:%l:\ %m]]
									.. [[,%-G^\s*at\ .*$]]
									.. [[,%-G^\s*Caused by:.*$]]
									.. [[,%-G^\s*> Task.*$]]
									.. [[,%-G^\s*FAILURE:.*$]]
									.. [[,%-G^\s*BUILD FAILED.*$]]
									.. [[,%-G^\s*Try:.*$]]
									.. [[,%-G^\s*Run with.*$]]
									.. [[,%-G^\s*\* What went wrong:.*$]]
									.. [[,%-G^\s*\* Exception is:.*$]],
							},
						}
					end,
				})
			end
		end

		cb(ret)
	end,
}
