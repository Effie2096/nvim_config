require("vim.treesitter.query").add_predicate(
	"is-mise?",
	function(_, _, bufnr, _)
		local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
		local filename = vim.fn.fnamemodify(filepath, ":t")
		return string.match(filename, ".*mise.*%.toml$") ~= nil
	end,
	{ force = true, all = false }
)
vim.treesitter.language.register("scheme", "kanata")

local ts = require("nvim-treesitter")
ts.install({
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"regex",
	"vim",
	"vimdoc",
})
ts.setup()

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
	-- Check if a parser exists and load it
	if not vim.treesitter.language.add(language) then
		return
	end
	-- Enable syntax highlighting and other treesitter features
	vim.treesitter.start(buf, language)

	-- Enable treesitter based folds
	-- For more info on folds see `:help folds`
	-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- vim.wo.foldmethod = "expr"

	-- Check if treesitter indentation is available for this language, and if so enable it
	-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
	local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

	-- Enable treesitter based indentation
	if has_indent_query then
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end
local available_parsers = require("nvim-treesitter").get_available()
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then
			return
		end

		local installed_parsers =
			require("nvim-treesitter").get_installed("parsers")

		if vim.tbl_contains(installed_parsers, language) then
			-- Enable the parser if it is already installed
			treesitter_try_attach(buf, language)
		elseif vim.tbl_contains(available_parsers, language) then
			-- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
			require("nvim-treesitter").install(language):await(function()
				treesitter_try_attach(buf, language)
			end)
		else
			-- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
			treesitter_try_attach(buf, language)
		end
	end,
})

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

-- Or, disable per filetype (add as you like)
-- vim.g.no_python_maps = true
-- vim.g.no_ruby_maps = true
-- vim.g.no_rust_maps = true
-- vim.g.no_go_maps = true
local methods = {
	select = function(capture)
		require("nvim-treesitter-textobjects.select").select_textobject(
			capture,
			"textobjects"
		)
	end,
	swap_next = function(capture)
		require("nvim-treesitter-textobjects.swap").swap_next(capture)
	end,
	swap_prev = function(capture)
		require("nvim-treesitter-textobjects.swap").swap_previous(capture)
	end,
	next_start = function(capture)
		require("nvim-treesitter-textobjects.move").goto_next_start(
			capture,
			"textobjects"
		)
	end,
	next_end = function(capture)
		require("nvim-treesitter-textobjects.move").goto_next_end(
			capture,
			"textobjects"
		)
	end,
	prev_start = function(capture)
		require("nvim-treesitter-textobjects.move").goto_previous_start(
			capture,
			"textobjects"
		)
	end,
	prev_end = function(capture)
		require("nvim-treesitter-textobjects.move").goto_previous_end(
			capture,
			"textobjects"
		)
	end,
}
local function objmap(keys, capture, method, mode)
	mode = mode or "n"
	vim.keymap.set(mode, keys, function()
		methods[method](capture)
	end)
end

-- stylua: ignore start
objmap("af", "@function.outer", "select", { "x", "o" })
objmap("if", "@function.inner", "select", { "x", "o" })
objmap("aF", "@class.outer", "select", { "x", "o" })
objmap("iF", "@class.inner", "select", { "x", "o" })
objmap("av", "@parameter.outer", "select", { "x", "o" })
objmap("iv", "@parameter.inner", "select", { "x", "o" })
objmap("al", "@loop.outer", "select", { "x", "o" })
objmap("il", "@loop.inner", "select", { "x", "o" })
objmap("ac", "@conditional.outer", "select", { "x", "o" })
objmap("ic", "@conditional.inner", "select", { "x", "o" })
objmap("ab", "@block.outer", "select", { "x", "o" })
objmap("ib", "@block.inner", "select", { "x", "o" })
objmap("ad", "@comment.outer", "select", { "x", "o" })
objmap("id", "@comment.inner", "select", { "x", "o" })
objmap("he", "@assignment.lhs", "select", { "x", "o" })
objmap("le", "@assignment.rhs", "select", { "x", "o" })
objmap("as", "@statement.outer", "select", { "x", "o" })

objmap("<leader>sfn", "@function.outer", "swap_next")
objmap("<leader>san", "@parameter.inner", "swap_next")
objmap("<leader>sfp", "@function.outer", "swap_prev")
objmap("<leader>sap", "@parameter.inner", "swap_prev")

objmap("]f", "@function.outer", "next_start", { "n", "x", "o" })
objmap("][", "@class.outer","next_start" , { "n", "x", "o" })
objmap("]b", "@block.outer","next_start" , { "n", "x", "o" })
objmap("]v", "@parameter.inner", "next_start", { "n", "x", "o" })
objmap("]F", "@function.outer", "next_end", { "n", "x", "o" })
objmap("]]", "@class.outer", "next_end", { "n", "x", "o" })
objmap("]B", "@block.outer", "next_end", { "n", "x", "o" })
objmap("]V", "@parameter.inner", "next_end", { "n", "x", "o" })
objmap("[f", "@function.outer", "prev_start", { "n", "x", "o" })
objmap("[[", "@class.outer", "prev_start", { "n", "x", "o" })
objmap("[b", "@block.outer", "prev_start", { "n", "x", "o" })
objmap("[v", "@parameter.inner", "prev_start", { "n", "x", "o" })
objmap("[F", "@function.outer", "prev_end", { "n", "x", "o" })
objmap("[]", "@class.outer", "prev_end", { "n", "x", "o" })
objmap("]B", "@block.outer", "prev_end", { "n", "x", "o" })
objmap("[V", "@parameter.inner", "prev_end", { "n", "x", "o" })
-- stylua: ignore end

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "V",
			["@loop.inner"] = "V",
		},
		include_surrounding_whitespace = true,
	},
	move = {
		set_jumps = true, -- whether to set jumps in the jumplist
	},
})
