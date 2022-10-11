local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug ('catppuccin/nvim', {['as'] = 'catppuccin', ['do'] = 'CatppucinCompile'})

Plug 'nvim-lualine/lualine.nvim'
Plug ('akinsho/toggleterm.nvim', {['tag'] = 'v2.*'})
Plug 'gcmt/taboo.vim'
Plug "SmiteshP/nvim-navic"
Plug 'kyazdani42/nvim-web-devicons'

-- LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'folke/lua-dev.nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'lvimuser/lsp-inlayhints.nvim'
Plug 'b0o/schemastore.nvim'
Plug 'pedro757/emmet'

Plug 'ray-x/lsp_signature.nvim'
-- Plug 'ThePrimeagen/refactoring.nvim'

-- Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'

-- Snippets
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
-- Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-calc'
Plug 'rcarriga/cmp-dap'
Plug 'hrsh7th/cmp-nvim-lua'

Plug 'rafamadriz/friendly-snippets'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind.nvim'

Plug ('nvim-treesitter/nvim-treesitter', { ['do'] = 'TSUpdate'})
Plug 'nvim-treesitter/playground'

Plug 'numToStr/Comment.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'kylechui/nvim-surround'
Plug 'windwp/nvim-autopairs'
-- Plug 'jiangmiao/auto-pairs'
Plug 'ggandor/lightspeed.nvim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'godlygeek/tabular'
Plug 'szw/vim-maximizer'

-- Git
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

-- Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug ('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

-- Projects
Plug 'natecraddock/sessions.nvim'
Plug 'natecraddock/workspaces.nvim'

-- Visual/UI
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'folke/twilight.nvim'
Plug 'folke/zen-mode.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'romgrk/nvim-treesitter-context'
Plug 'kevinhwang91/nvim-ufo' Plug 'kevinhwang91/promise-async'
-- Plug 'folke/noice.nvim' Plug 'MunifTanjim/nui.nvim'

vim.call('plug#end')
