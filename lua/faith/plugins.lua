local Plug = vim.fn["plug#"]

vim.cmd([[
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
]])

vim.fn["plug#begin"]()
Plug("catppuccin/nvim", {
	["as"] = "catppuccin",
})
Plug("lewis6991/impatient.nvim")
Plug("antoinemadec/FixCursorHold.nvim")

--[[]]
Plug("nvim-lualine/lualine.nvim")
Plug("akinsho/toggleterm.nvim", { ["tag"] = "v2.*" })
Plug("SmiteshP/nvim-navic")
Plug("utilyre/barbecue.nvim", { ["as"] = "barbecue" })
Plug("kyazdani42/nvim-web-devicons")
Plug("tmux-plugins/vim-tmux") -- tmux.conf syntax hl n stuff
Plug("preservim/vimux")
Plug("christoomey/vim-tmux-navigator")
--[[]]

--[[LSP ]]
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("jose-elias-alvarez/null-ls.nvim")
Plug("folke/neodev.nvim")
Plug("mfussenegger/nvim-jdtls")
Plug("lvimuser/lsp-inlayhints.nvim", { ["branch"] = "anticonceal" })
Plug("b0o/schemastore.nvim")
Plug("pedro757/emmet")
Plug("DasGandlaf/nvim-autohotkey")
Plug("nvim-treesitter/nvim-treesitter-textobjects")
Plug("simrat39/rust-tools.nvim")
Plug("cdelledonne/vim-cmake")
Plug("nvimdev/lspsaga.nvim", { ["branch"] = "main" })

Plug("ray-x/lsp_signature.nvim")
Plug("ThePrimeagen/refactoring.nvim")
Plug("skywind3000/asyncrun.vim")
Plug("vim-test/vim-test")
--[[]]

--[[ Debugging ]]
Plug("mfussenegger/nvim-dap")
Plug("rcarriga/nvim-dap-ui")
Plug("theHamsta/nvim-dap-virtual-text")
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
Plug("davidsierradz/cmp-conventionalcommits")

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
Plug("lukas-reineke/indent-blankline.nvim")
Plug("norcalli/nvim-colorizer.lua")
Plug("HiPhish/rainbow-delimiters.nvim")
Plug("ziontee113/color-picker.nvim")
Plug("folke/zen-mode.nvim")
Plug("xiyaowong/nvim-transparent")
Plug("karb94/neoscroll.nvim")
Plug("romgrk/nvim-treesitter-context")
Plug("tversteeg/registers.nvim")
Plug("kevinhwang91/nvim-ufo")
Plug("kevinhwang91/promise-async")
Plug("nvim-tree/nvim-tree.lua")
Plug("antosha417/nvim-lsp-file-operations")
Plug("mbbill/undotree")

Plug("rcarriga/nvim-notify")

Plug("j-hui/fidget.nvim", { ["tag"] = "legacy" })
Plug("luukvbaal/statuscol.nvim")
Plug("ThePrimeagen/harpoon")
-- Plug("akinsho/bufferline.nvim", { ["tag"] = "v4.0.0" })
--[[]]

vim.fn["plug#end"]()
