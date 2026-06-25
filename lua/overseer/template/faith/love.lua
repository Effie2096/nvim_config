local constants = require("overseer.constants")
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local get_root_dir = function(opts)
	local love_root = vim.fs.find({ "main.lua", "conf.lua" }, {
		path = opts.dir,
		type = "file",
		upward = true,
		limit = math.huge,
	})

	if #love_root == 2 then
		return vim.fs.dirname(love_root[1])
	end
	return nil
end

---@param opts overseer.SearchParams
---@return nil|string
local find_love = function(opts)
	if vim.fn.executable("lovec") == 1 then
		return "lovec"
	elseif vim.fn.executable("love") == 1 then
		return "love"
	elseif vim.fn.executable("love-git") == 1 then
		return "love-git"
	end
	return nil
end

---@type overseer.TemplateFileProvider
return {
	cache_key = function(opts)
		return get_root_dir(opts)
	end,
	generator = function(opts, cb)
		local root_dir = get_root_dir(opts)
		local cmd = find_love(opts)

		if not cmd then
			return 'Command "love" not found'
		end
		if not root_dir then
			return "No love project found"
		end

		local ret = {
			{
				name = string.format("%s %s", cmd, root_dir),
				tags = { TAG.RUN },
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
