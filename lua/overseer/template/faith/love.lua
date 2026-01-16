local constants = require("overseer.constants")
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return string
local get_root_dir = function(opts)
	local git_root =
		vim.fs.dirname(vim.fs.find(".git", { path = opts.dir, upward = true })[1])
	if git_root then
		return git_root
	end
	return vim.fn.getcwd()
end

---@param opts overseer.SearchParams
---@return nil|string
local find_love = function(opts)
	if vim.fn.executable("lovec") == 1 then
		return "lovec"
	elseif vim.fn.executable("love") == 1 then
		return "love"
	end
	return nil
end

---@type overseer.TemplateFileProvider
return {
	cache_key = function(opts)
		return get_root_dir(opts)
	end,
	condition = {
		callback = function(opts)
			if not find_love(opts) then
				return false, 'Command "love" not found'
			end
			return true
		end,
	},
	generator = function(opts, cb)
		local root_dir = get_root_dir(opts)
		local cmd = find_love(opts)

		local ret = {
			{
				name = string.format("%s %s", cmd, root_dir),
				tags = { TAG.RUN },
				priority = 55,
				builder = function()
					return {
						cmd = {
							cmd,
							root_dir,
						},
						cwd = root_dir,
					}
				end,
			},
			{
				name = string.format("Love with Args:\n%s %s", cmd, root_dir),
				tags = { TAG.RUN },
				priority = 60,
				builder = function()
					return {
						cmd = {
							cmd,
							root_dir,
							vim
								.iter(
									vim.split(
										vim.fn.input({ prompt = "Args:" }),
										" ",
										{ trimempty = true }
									)
								)
								:join(" "),
						},
						cwd = root_dir,
					}
				end,
			},
		}

		cb(ret)
	end,
}
