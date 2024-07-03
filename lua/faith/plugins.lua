local Plug = vim.fn["plug#"]

vim.fn["plug#begin"]()
Plug("catppuccin/nvim", {
	["as"] = "catppuccin",
})
Plug("vhyrro/luarocks.nvim", { ["do"] = ":source ./build.lua" })
Plug("tpope/vim-sleuth")
Plug("stevearc/oil.nvim")

--[[]]
Plug("nvim-lualine/lualine.nvim")
Plug("akinsho/toggleterm.nvim", { ["tag"] = "*" })
Plug("SmiteshP/nvim-navic")
Plug("utilyre/barbecue.nvim", { ["as"] = "barbecue" })
Plug("kyazdani42/nvim-web-devicons")
Plug("tmux-plugins/vim-tmux") -- tmux.conf syntax hl n stuff
Plug("preservim/vimux")
Plug("christoomey/vim-tmux-navigator")
Plug("davidgranstrom/scnvim")
Plug("davidgranstrom/telescope-scdoc.nvim")
Plug("bfredl/nvim-luadev")
--[[]]

--[[LSP ]]
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("jose-elias-alvarez/null-ls.nvim")
Plug("stevearc/conform.nvim")
Plug("folke/lazydev.nvim")
Plug("mfussenegger/nvim-jdtls")
Plug("b0o/schemastore.nvim")
Plug("pedro757/emmet")
Plug("DasGandlaf/nvim-autohotkey")
Plug("nvim-treesitter/nvim-treesitter-textobjects")
Plug("cdelledonne/vim-cmake")
Plug("nvimdev/lspsaga.nvim", { ["branch"] = "main" })

Plug("ray-x/lsp_signature.nvim")
-- Plug("https://git.sr.ht/~whynothugo/lsp_lines.nvim")
Plug("ThePrimeagen/refactoring.nvim")
Plug("skywind3000/asyncrun.vim")
Plug("vim-test/vim-test")
Plug("nvim-neotest/neotest-vim-test")
Plug("nvim-neotest/neotest")
Plug("andythigpen/nvim-coverage")
Plug("mrcjkb/rustaceanvim", { ["tag"] = "4.*" })
--[[]]

--[[ Debugging ]]
Plug("mfussenegger/nvim-dap")
Plug("LiadOz/nvim-dap-repl-highlights")
Plug("nvim-neotest/nvim-nio")
Plug("rcarriga/nvim-dap-ui")
Plug("theHamsta/nvim-dap-virtual-text")
Plug("mfussenegger/nvim-dap-python", { ["commit"] = "d777c2b32ed39f61209c09bede28d7491621a631" })
--[[]]

--[[ Completion ]]
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
-- Plug ('hrsh7th/cmp-nvim-lsp-signature-help', { ['commit'] = '' })
Plug("hrsh7th/cmp-calc")
Plug("rcarriga/cmp-dap")
Plug("hrsh7th/cmp-nvim-lua")
Plug("hrsh7th/cmp-cmdline")
Plug("saadparwaiz1/cmp_luasnip")
Plug("petertriho/cmp-git")
Plug("quangnguyen30192/cmp-nvim-tags")
Plug("davidsierradz/cmp-conventionalcommits")
Plug("justinsgithub/wezterm-types")

Plug("rafamadriz/friendly-snippets")

Plug("L3MON4D3/LuaSnip")
Plug("onsails/lspkind.nvim")

-- Plug("Exafunction/codeium.vim")
Plug("jcdickinson/codeium.nvim")
--[[]]

Plug("nvim-treesitter/nvim-treesitter")
Plug("nvim-treesitter/playground")

Plug("numToStr/Comment.nvim")
Plug("folke/todo-comments.nvim")
Plug("JoosepAlviste/nvim-ts-context-commentstring")
Plug("kylechui/nvim-surround")
Plug("windwp/nvim-autopairs")
Plug("ggandor/lightspeed.nvim")
Plug("nat-418/boole.nvim")
Plug("tpope/vim-abolish")
Plug("tpope/vim-repeat")
Plug("godlygeek/tabular")
Plug("szw/vim-maximizer")

--[[ Git ]]
Plug("tpope/vim-fugitive")
Plug("lewis6991/gitsigns.nvim")
Plug("ThePrimeagen/git-worktree.nvim")
--[[]]

--[[ Telescope ]]
Plug("nvim-lua/popup.nvim")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-ui-select.nvim")
Plug("nvim-telescope/telescope-file-browser.nvim")
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })
--[[]]

--[[ Projects ]]
Plug("tpope/vim-obsession")
--[[]]

--[[ Visual/UI ]]
Plug("lukas-reineke/indent-blankline.nvim", { ["as"] = "ibl" })
Plug("norcalli/nvim-colorizer.lua")
Plug("HiPhish/rainbow-delimiters.nvim")
Plug("ziontee113/color-picker.nvim")
Plug("folke/zen-mode.nvim")
Plug("folke/twilight.nvim")
Plug("xiyaowong/nvim-transparent")
Plug("karb94/neoscroll.nvim")
Plug("romgrk/nvim-treesitter-context")
Plug("tversteeg/registers.nvim")
Plug("kevinhwang91/nvim-ufo")
Plug("kevinhwang91/promise-async")
Plug("nvim-tree/nvim-tree.lua")
Plug("antosha417/nvim-lsp-file-operations")
Plug("mbbill/undotree")
Plug("kevinhwang91/nvim-bqf")
Plug("tpope/vim-dadbod")
Plug("kristijanhusak/vim-dadbod-ui")
Plug("mechatroner/rainbow_csv")
Plug("chrisbra/csv.vim")
Plug("folke/noice.nvim")
Plug("MunifTanjim/nui.nvim")

Plug("rcarriga/nvim-notify")

Plug("j-hui/fidget.nvim", { ["tag"] = "legacy" })
Plug("luukvbaal/statuscol.nvim")
Plug("j-hui/fidget.nvim", { ["commit"] = "ef99df04a1c53a453602421bc0f756997edc8289" })
Plug("ThePrimeagen/harpoon", { ["branch"] = "harpoon2" })
-- Plug("akinsho/bufferline.nvim", { ["tag"] = "v4.0.0" })
--[[]]

--{{{ Notes
Plug("epwalsh/obsidian.nvim")
Plug("lukas-reineke/headlines.nvim")
Plug("3rd/image.nvim")
Plug("jmbuhr/otter.nvim")
--}}}
vim.fn["plug#end"]()
