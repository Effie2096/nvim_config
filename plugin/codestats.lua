vim.pack.add(
	{ { src = "https://github.com/liljaylj/codestats.nvim" } },
	{ load = false }
)

if not vim.env.CODESTATS_KEY then
	return
end

local function config()
	local codestats = require("codestats")
	codestats.setup({
		username = "effie", -- needed to fetch profile data
		base_url = "https://codestats.net", -- codestats.net base url
		api_key = vim.env.CODESTATS_KEY,
		send_on_exit = true, -- send xp on nvim exit
		send_on_timer = true, -- send xp on timer
		timer_interval = 60000, -- timer interval in milliseconds (minimum 1000ms to prevent DDoSing codestat.net servers)
		curl_timeout = 5, -- curl request timeout in seconds
	})
end

local function load()
	if not package.loaded.codestats then
		vim.cmd.packadd("codestats.nvim")
		config()
	end
end

vim.api.nvim_create_user_command("CodeStats", function(_)
	load()
	local bt = vim.api.nvim_get_option_value("filetype", { buf = 0 })
	local total_xp =
		require("faith.statusline.components.codestats").total_xp(true)
	local buf_xp = require("faith.statusline.components.codestats").buf_xp(true)
	local display = ([[Total: %s
				%s: %s]]):format(total_xp, bt, buf_xp)
	vim.notify(display, vim.log.levels.INFO)
end, {})

vim.api.nvim_create_autocmd({ "TextChanged", "InsertEnter" }, {
	once = true,
	callback = load,
})
