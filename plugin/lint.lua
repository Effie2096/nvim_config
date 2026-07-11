vim.pack.add(
	{ { src = "https://github.com/mfussenegger/nvim-lint" } },
	{ load = false }
)
local linters_by_ft = {
	css = { "biomejs" },
	dotenv = { "dotenv_linter" },
	html = { "htmlhint" },
	js = { "biomejs" },
	json = { "biomejs" },
	jsonc = { "biomejs" },
	jsx = { "biomejs" },
	-- kotlin = { "ktlint" },
	lua = { "selene" },
	python = { "ruff" },
	sh = { "shellcheck" },
	-- toml = { "tombi" },
	ts = { "biomejs" },
	tsx = { "biomejs" },
	vim = { "vint" },
	yaml = { "yamllint" },
}

local config = function()
	local lint = require("lint")

	lint.linters_by_ft = linters_by_ft

	local yamllint = require("lint").linters.yamllint
	yamllint.args = {
		"-d",
		"{extends: default, rules: {comments-indentation: disable}}",
		"--format",
		"parsable",
		"-",
	}

	-- Create autocommand which carries out the actual linting
	-- on the specified events.
	local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = lint_augroup,
		callback = function()
			-- Only run the linter in buffers that you can modify in order to
			-- avoid superfluous noise, notably within the handy LSP pop-ups that
			-- describe the hovered symbol using Markdown.

			if vim.bo.modifiable then
				local linter = require("lint").linters_by_ft[vim.bo.filetype]
				if linter and vim.fn.executable(linter[1]) == 1 then
					lint.try_lint()
				end
			end
		end,
	})
end

local load = function()
	if package.loaded.lint then
		return
	end

	vim.cmd.packadd("nvim-lint")

	config()
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	pattern = vim
		.iter(linters_by_ft)
		:map(function(ft, _)
			return ("*.%s"):format(ft)
		end)
		:totable(),
	callback = function()
		load()
	end,
})
