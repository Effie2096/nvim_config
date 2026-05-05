require("vim._core.ui2").enable({
	enable = true, -- Whether to enable or disable the UI.
	msg = { -- Options related to the message module.
		---@type 'cmd'|'msg' Default message target, either in the
		---cmdline or in a separate ephemeral message window.
		---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
		---or table mapping |ui-messages| kinds and triggers to a target.
		targets = "msg",
		cmd = { -- Options related to messages in the cmdline window.
			height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
		},
		dialog = { -- Options related to dialog window.
			height = 0.5, -- Maximum height.
		},
		msg = { -- Options related to msg window.
			height = 0.5, -- Maximum height.
			timeout = 4000, -- Time a message is visible in the message window.
		},
		pager = { -- Options related to message window.
			height = 1, -- Maximum height.
		},
	},
})

require("faith")

local function build(command)
	if type(command) == "table" then
		vim.fn.system(vim.iter(command):join(" "))
	elseif type(command) == "string" then
		vim.fn.system(command)
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind, folder = ev.data.spec.name, ev.data.kind, ev.file
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd.TSUpdate()
		end
		if name == "LuaSnip" and (kind == "update" or kind == "install") then
			if vim.fn.executable("make") then
				build({
					"cd",
					vim.fn.glob(folder),
					"&&",
					"make",
					"install_jsregexp",
				})
			end
		end
		if
			name == "telescope-fzf-native.nvim"
			and (kind == "update" or kind == "install")
		then
			if vim.fn.executable("cmake") then
				build({
					"cd",
					vim.fn.glob(folder),
					"&&",
					"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release",
					"&&",
					"cmake --build build --config Release",
					"&&",
					"cmake --install build --prefix build",
				})
			elseif vim.fn.executable("make") then
				build({ "cd", vim.fn.glob(folder), "&&", "make" })
			end
		end
	end,
})

local gh = function(str)
	return ("https://github.com/%s"):format(str)
end
vim.pack.add({
	{ src = gh("rebelot/kanagawa.nvim") },

	-- Libraries
	{ src = gh("nvim-lua/plenary.nvim") },
	{ src = gh("rcarriga/nvim-notify") },
	{ src = gh("nvim-treesitter/nvim-treesitter") },
	{ src = gh("nvim-treesitter/nvim-treesitter-textobjects") },
	{ src = gh("nvim-mini/mini.icons") },
	{ src = gh("folke/which-key.nvim") },

	{ src = gh("folke/snacks.nvim") },
	{ src = gh("liljaylj/codestats.nvim") },
	{ src = gh("b0o/incline.nvim") },
	{ src = gh("lukas-reineke/indent-blankline.nvim") },

	{ src = gh("nmac427/guess-indent.nvim") },
	{ src = gh("stevearc/resession.nvim") },

	-- LSP
	{ src = gh("b0o/SchemaStore.nvim") },
	{ src = gh("folke/lazydev.nvim") },
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("mason-org/mason-lspconfig.nvim") },
	{ src = gh("S1M0N38/love2d.nvim") },
	{
		src = "https://github.com/Mythos-404/xmake.nvim",
		version = vim.version.range("^3"),
	},

	-- completion
	{ src = gh("Saghen/blink.cmp"), version = vim.version.range("1.x") },
	{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.x") },
	{ src = gh("rafamadriz/friendly-snippets") },
	{ src = gh("JoosepAlviste/nvim-ts-context-commentstring") },
	{ src = gh("numToStr/Comment.nvim") },
	{ src = gh("onsails/lspkind.nvim") },
	{ src = gh("xzbdmw/colorful-menu.nvim") },
	{ src = gh("yus-works/csc.nvim") },
	{ src = gh("nvim-svelte/nvim-svelte-snippets") },

	-- Telescope
	{ src = gh("nvim-telescope/telescope-ui-select.nvim") },
	{ src = gh("nvim-telescope/telescope-fzf-native.nvim") },
	{ src = gh("nvim-telescope/telescope.nvim") },

	{ src = gh("stevearc/overseer.nvim") },

	-- Navigation
	{ src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
	{ src = gh("stevearc/oil.nvim") },
	{
		src = "https://github.com/mrjones2014/smart-splits.nvim",
		version = vim.version.range("2.x"),
	},

	-- Versioning
	{ src = gh("tpope/vim-fugitive") },
	{ src = gh("mbbill/undotree") },

	-- Edit
	{ src = gh("tpope/vim-abolish") },
	{ src = gh("monaqa/dial.nvim") },
	{ src = gh("kylechui/nvim-surround"), version = vim.version.range("4.x") },

	{ src = gh("karb94/neoscroll.nvim") },
	{ src = gh("folke/zen-mode.nvim") },

	{ src = gh("folke/todo-comments.nvim") },
})

require("faith.plugins")
