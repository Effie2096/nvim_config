if vim.fn.executable("xmake") == 0 then
	return
end

vim.pack.add({
	{
		src = "https://github.com/Mythos-404/xmake.nvim",
		version = vim.version.range("^3"),
	},
}, { load = function() end })

local function is_xmake_project()
	return vim.fs.find(
		"xmake.lua",
		{ limit = math.huge, upward = true, stop = vim.fn.getcwd() }
	)
end

local function config()
	if package.loaded.xmake then
		return
	end

	vim.cmd.packadd("xmake.nvim")

	vim.notify("Xmake project found.", vim.log.levels.INFO, { title = "Xmake" })

	local xmake = require("xmake")
	xmake.setup()
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "cpp", "lua" },
	once = true,
	callback = function(ctx)
		if
			ctx.match == "lua" and vim.fn.fnamemodify(ctx.file, ":t") == "xmake.lua"
		then
			config()
		elseif ctx.match == "cpp" then
			if is_xmake_project() then
				config()
			end
		end
	end,
})
