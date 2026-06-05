vim.pack.add(
	{ { src = "https://github.com/mfussenegger/nvim-lint" } },
	{ load = function() end }
)

local config = function()
	local lint = require("lint")
	lint.linters_by_ft = {
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
	if not package.loaded["lint"] then
		vim.cmd.packadd("nvim-lint")
		config()
	end
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		load()
	end,
})
