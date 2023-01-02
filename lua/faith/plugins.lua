local Plug = vim.fn['plug#']

vim.cmd([[
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
]])

vim.fn['plug#begin']()
Plug ('catppuccin/nvim', {['as'] = 'catppuccin', ['do'] = 'CatppucinCompile', ['commit'] = '0392739cfcc03d8ef9c8e667dd46ec7b89b4667f'})
Plug ('lewis6991/impatient.nvim', { ['commit'] = 'b842e16ecc1a700f62adb9802f8355b99b52a5a6' })

Plug ('nvim-lualine/lualine.nvim', { ['commit'] = 'edca2b03c724f22bdc310eee1587b1523f31ec7c' })
Plug ('akinsho/toggleterm.nvim', {['tag'] = 'v2.*'})
Plug ('gcmt/taboo.vim', { ['commit'] = 'caf948187694d3f1374913d36f947b3f9fa1c22f' })
Plug ("SmiteshP/nvim-navic", { ['commit'] = '132b273773768b36e9ecab2138b82234a9faf5ed' })
Plug ('kyazdani42/nvim-web-devicons', { ['commit'] = '9061e2d355ecaa2b588b71a35e7a11358a7e51e1' })

-- LSP
Plug ('neovim/nvim-lspconfig', { ['commit'] = 'af43c300d4134db3550089cd4df6c257e3734689' })
Plug ('williamboman/mason.nvim')
Plug ('williamboman/mason-lspconfig.nvim', { ['commit'] = 'ef41cd4ebccbf0981089bb06f5ed59e0dad549ca' })
Plug ('jose-elias-alvarez/null-ls.nvim', { ['commit'] = 'c8624325198513411cf9dcacde76f14d2260220f' })
Plug 'folke/neodev.nvim'
Plug ('mfussenegger/nvim-jdtls', { ['commit'] = '75d27daa061458dd5735b5eb5bbc48d3baad1186' })
Plug ('lvimuser/lsp-inlayhints.nvim', { ['commit'] = 'a28c51a6362e3faa17f67749436cb5c8b55dcc6d' })
Plug 'b0o/schemastore.nvim'
Plug ('pedro757/emmet', { ['commit'] = 'bff967b1d91948a88104987b427842deb78bacf5' })
Plug ('nvim-treesitter/nvim-treesitter-textobjects', { ['commit'] = '13739a5705d9592cbe7da372576363dc8ea5f723' })
Plug 'simrat39/rust-tools.nvim'
Plug ('glepnir/lspsaga.nvim', { ['branch'] = 'main' , ['commit'] = 'b7b4777369b441341b2dcd45c738ea4167c11c9e' })

Plug ('ray-x/lsp_signature.nvim', { ['commit'] = 'e65a63858771db3f086c8d904ff5f80705fd962b' })
Plug ('ThePrimeagen/refactoring.nvim')

-- Debugging
Plug ('mfussenegger/nvim-dap', { ['commit'] = '5d57c401cab25997a6d8202b2498ad5ac895f143' })
Plug ('rcarriga/nvim-dap-ui', { ['commit'] = '8d0768a83f7b89bd8cb8811800bc121b9353f0b2' })
Plug ('theHamsta/nvim-dap-virtual-text', { ['commit'] = '2971ce3e89b1711cc26e27f73d3f854b559a77d4' })

-- Snippets
Plug ('hrsh7th/nvim-cmp', { ['commit'] = '2427d06b6508489547cd30b6e86b1c75df363411' })
Plug ('hrsh7th/cmp-nvim-lsp', { ['commit'] = 'affe808a5c56b71630f17aa7c38e15c59fd648a8' })
Plug ('hrsh7th/cmp-buffer', { ['commit'] = '3022dbc9166796b644a841a02de8dd1cc1d311fa' })
Plug ('hrsh7th/cmp-path', { ['commit'] = '447c87cdd6e6d6a1d2488b1d43108bfa217f56e1' })
-- Plug ('hrsh7th/cmp-nvim-lsp-signature-help', { ['commit'] = '' })
Plug ('hrsh7th/cmp-calc', { ['commit'] = 'f7efc20768603bd9f9ae0ed073b1c129f63eb312' })
Plug ('rcarriga/cmp-dap', { ['commit'] = 'a67883cfe574923d3414035ba16159c0ed6d8dcf' })
Plug ('hrsh7th/cmp-nvim-lua', { ['commit'] = '44acf47b28ff77b4b18d69d5b51b03184c87ccdf' })
Plug ('saadparwaiz1/cmp_luasnip', { ['commit'] = 'a9de941bcbda508d0a45d28ae366bb3f08db2e36' })

Plug 'rafamadriz/friendly-snippets'

Plug ('L3MON4D3/LuaSnip', { ['commit'] = '8f8d493e7836f2697df878ef9c128337cbf2bb84' })
Plug ('onsails/lspkind.nvim', { ['commit'] = 'c68b3a003483cf382428a43035079f78474cd11e' })

Plug ('nvim-treesitter/nvim-treesitter', { ['do'] = 'TSUpdate', ['commit'] = 'aebc6cf6bd4675ac86629f516d612ad5288f7868' })
Plug ('nvim-treesitter/playground', { ['commit'] = 'e6a0bfaf9b5e36e3a327a1ae9a44a989eae472cf' })

Plug ('numToStr/Comment.nvim', { ['commit'] = 'd9cfae1059b62f7eacc09dba181efe4894e3b086' })
Plug ('folke/todo-comments.nvim', { ['commit'] = '02eb3019786d9083b93ab9457761899680c6f3ec' })
Plug ('JoosepAlviste/nvim-ts-context-commentstring', { ['commit'] = '4d3a68c41a53add8804f471fcc49bb398fe8de08' })
Plug ('kylechui/nvim-surround', { ['commit'] = '17191679202978b1de8c1bd5d975400897b1b92d' })
Plug ('windwp/nvim-autopairs', { ['commit'] = '14cc2a4fc6243152ba085cc2059834113496c60a' })
Plug ('ggandor/lightspeed.nvim', { ['commit'] = 'a5b79ddbd755ac8d21a8704c370b5f643dda94aa' })
Plug 'nat-418/boole.nvim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'godlygeek/tabular'
Plug 'szw/vim-maximizer'

-- Git
Plug ('tpope/vim-fugitive', { ['commit'] = 'dd8107cabf5fe85df94d5eedcae52415e543f208' })
Plug ('lewis6991/gitsigns.nvim', { ['commit'] = 'f98c85e7c3d65a51f45863a34feb4849c82f240f' })

-- Telescope
Plug ('nvim-lua/popup.nvim', { ['commit'] = 'b7404d35d5d3548a82149238289fa71f7f6de4ac' })
Plug ('nvim-lua/plenary.nvim', { ['commit'] = '9e7c62856e47053ec7b17f82c5da0f1e678d92c8' })
Plug ('nvim-telescope/telescope.nvim', { ['commit'] = '76ea9a898d3307244dce3573392dcf2cc38f340f' })
Plug ('nvim-telescope/telescope-ui-select.nvim', { ['commit'] = '62ea5e58c7bbe191297b983a9e7e89420f581369' })
Plug ('nvim-telescope/telescope-file-browser.nvim', { ['commit'] = 'b1bc53e0da3d26f0003ffb9602115ce258411aa5' })
Plug ('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make', ['commit'] = '65c0ee3d4bb9cb696e262bca1ea5e9af3938fc90' })

-- Projects
Plug ('natecraddock/sessions.nvim', { ['commit'] = '1a5a1a9acc62897cb62af71d5d72c0a08021b2a9' })
Plug ('natecraddock/workspaces.nvim', { ['commit'] = '5a3b96bf86faba123476027d8f9fb442e43dc631' })

-- Visual/UI
Plug ('lukas-reineke/indent-blankline.nvim', { ['commit'] = 'db7cbcb40cc00fc5d6074d7569fb37197705e7f6' })
Plug ('norcalli/nvim-colorizer.lua', { ['commit'] = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6' })
Plug ("ziontee113/color-picker.nvim", { ['commit'] = '2b4a4a408278271909e3eb13fe0715f856c7b4d8' })
Plug ('folke/zen-mode.nvim', { ['commit'] = '6f5702db4fd4a4c9a212f8de3b7b982f3d93b03c' })
Plug 'xiyaowong/nvim-transparent'
-- Plug ('karb94/neoscroll.nvim', { ['commit'] = '54c5c419f6ee2b35557b3a6a7d631724234ba97a' })
Plug ('rcarriga/nvim-notify', { ['commit'] = '142069baf554c3d41c8de4a6f7472c618a58becc' })
Plug ('romgrk/nvim-treesitter-context', { ['commit'] = '8d0759eb798fee2e1201b26c3279713ac67c44c2' })
Plug ('tversteeg/registers.nvim')
Plug ('kevinhwang91/nvim-ufo', { ['commit'] = 'c1c0dd76f2298bd93ebd417360a2bfbeade37ac2' }) Plug ('kevinhwang91/promise-async', { ['commit'] = '70b09063cdf029079b25c7925e4494e7416ee995' })
Plug 'mbbill/undotree'
-- Plug ('folke/noice.nvim' Plug 'MunifTanjim/nui.nvim', { ['commit'] = '' })

vim.fn['plug#end']()
