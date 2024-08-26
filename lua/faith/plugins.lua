local Plug = vim.fn["plug#"]

vim.fn["plug#begin"]()
--[[ Colorschemes ]]
Plug("catppuccin/nvim", {
	["as"] = "catppuccin",
	["tag"] = "v1.*",
})
--[[]]
--
Plug("andweeb/presence.nvim")
Plug(
	"vhyrro/luarocks.nvim",
	{ ["do"] = ":source ./build.lua", ["commit"] = "1db9093915eb16ba2473cfb8d343ace5ee04130a" }
)
Plug("tpope/vim-sleuth", { ["commit"] = "1cc4557420f215d02c4d2645a748a816c220e99b" })
Plug("antoinemadec/FixCursorHold.nvim")
Plug("kevinhwang91/promise-async", { ["commit"] = "28c1d5a295eb5310afa2523d4ae9aa41ec5a9de2" })
Plug("skywind3000/asyncrun.vim", { ["tag"] = "2.12.*" })
Plug("stevearc/overseer.nvim")
Plug("szw/vim-maximizer", { ["commit"] = "2e54952fe91e140a2e69f35f22131219fcd9c5f1" })
Plug("tpope/vim-abolish", { ["commit"] = "dcbfe065297d31823561ba787f51056c147aa682" })
Plug("nvim-treesitter/nvim-treesitter-textobjects", { ["commit"] = "34867c69838078df7d6919b130c0541c0b400c47" })

if not vim.fn.has("win32") then
	Plug("tmux-plugins/vim-tmux", { ["tag"] = "v3.*" }) -- tmux.conf syntax hl n stuff
	Plug("preservim/vimux", { ["tag"] = "1.*" })
	Plug("christoomey/vim-tmux-navigator", { ["tag"] = "v1.*" })
end

--[[]]
Plug("davidgranstrom/scnvim")
Plug("davidgranstrom/telescope-scdoc.nvim")
--[[]]

--[[LSP ]]
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("jose-elias-alvarez/null-ls.nvim")
Plug("stevearc/conform.nvim")
Plug("folke/neodev.nvim")
Plug("mfussenegger/nvim-jdtls", { ["commit"] = "40e8494e04c1bcd5dd6c0d0bc187d2d10965017d" })
Plug("b0o/schemastore.nvim")
Plug("pedro757/emmet", { ["commit"] = "bff967b1d91948a88104987b427842deb78bacf5" })
Plug("DasGandlaf/nvim-autohotkey")
Plug("mrcjkb/rustaceanvim", { ["tag"] = "4.*" })
-- Plug("cdelledonne/vim-cmake", { ["commit"] = "4e155794686811c0fc381a8dc82260a2e388c2a6" })

Plug("ray-x/lsp_signature.nvim", { ["tag"] = "v0.3.*" })
Plug("ThePrimeagen/refactoring.nvim", { ["commit"] = "c9c1a0995b7d9a534f3b9a4df7fd55240127eeb4" })

--[[ Testing ]]
Plug("vim-test/vim-test", { ["commit"] = "34aab77f7a63f20a623df45684156915f6182a55" })
Plug("nvim-neotest/nvim-nio", { ["tag"] = "v1.*" })
Plug("nvim-neotest/neotest", { ["tag"] = "v5.*" })
Plug("nvim-neotest/neotest-vim-test", { ["commit"] = "75c4228882ae4883b11bfce9b8383e637eb44192" })
Plug("nvim-neotest/neotest-python", { ["commit"] = "2e83d2bc00acbcc1fd529dbf0a0e677cabfe6b50" })
Plug("andythigpen/nvim-coverage", { ["commit"] = "aa4b4400588e2259e87e372b1e4e90ae13cf5a39" })
--[[]]

--[[ Debugging ]]
Plug("mfussenegger/nvim-dap", { ["tag"] = "0.8.*" })
Plug("rcarriga/nvim-dap-ui", { ["commit"] = "b7267003ba4dd860350be86f75b9d9ea287cedca" })
Plug("theHamsta/nvim-dap-virtual-text", { ["commit"] = "d7c695ea39542f6da94ee4d66176f5d660ab0a77" })
Plug("LiadOz/nvim-dap-repl-highlights", { ["commit"] = "a7512fc0a0de0c0be8d58983939856dda6f72451" })
Plug("mfussenegger/nvim-dap-python", { ["commit"] = "d777c2b32ed39f61209c09bede28d7491621a631" })
Plug("leoluz/nvim-dap-go", { ["commit"] = "3999f0744e80d2dba5775189fc7c7a5e9846053e" })
Plug("bfredl/nvim-luadev", { ["commit"] = "3ba0c02c378503739f1fdb95cff3ea2aad48db3e" })
Plug("ofirgall/goto-breakpoints.nvim", { ["commit"] = "d14776899eda4023667b246e5c53c14a7c41f88e" })
Plug("Weissle/persistent-breakpoints.nvim", { ["commit"] = "01e43512ef8d137f2b9e5c1c74fd35c37e787b59" })
--[[]]

--[[ Completion ]]
Plug("hrsh7th/nvim-cmp", { ["commit"] = "a110e12d0b58eefcf5b771f533fc2cf3050680ac" })
Plug("hrsh7th/cmp-nvim-lsp", { ["commit"] = "39e2eda76828d88b773cc27a3f61d2ad782c922d" })
Plug("hrsh7th/cmp-buffer", { ["commit"] = "3022dbc9166796b644a841a02de8dd1cc1d311fa" })
Plug("hrsh7th/cmp-path", { ["commit"] = "91ff86cd9c29299a64f968ebb45846c485725f23" })
-- Plug ('hrsh7th/cmp-nvim-lsp-signature-help', { ['commit'] = '' })
Plug("hrsh7th/cmp-calc", { ["commit"] = "5947b412da67306c5b68698a02a846760059be2e" })
Plug("rcarriga/cmp-dap", { ["commit"] = "ea92773e84c0ad3288c3bc5e452ac91559669087" })
Plug("hrsh7th/cmp-nvim-lua", { ["commit"] = "f12408bdb54c39c23e67cab726264c10db33ada8" })
Plug("hrsh7th/cmp-cmdline", { ["commit"] = "d250c63aa13ead745e3a40f61fdd3470efde3923" })
Plug("saadparwaiz1/cmp_luasnip", { ["commit"] = "05a9ab28b53f71d1aece421ef32fee2cb857a843" })
Plug("petertriho/cmp-git", { ["commit"] = "8dfbc33fb32c33e5c0be9dcc8176a4f4d395f95e" })
Plug("quangnguyen30192/cmp-nvim-tags", { ["commit"] = "e126a09ef49f0611c127dea851fa0052aa223f15" })
Plug("davidsierradz/cmp-conventionalcommits", { ["commit"] = "a4dfacf0601130b7f8afa7c948d735c27802fb7f" })
Plug("justinsgithub/wezterm-types", { ["commit"] = "1518752906ba3fac0060d9efab6e4d3ec15d4b5a" })
Plug("danymat/neogen", { ["commit"] = "6de0add4805165317ab7d3d36b5cef48b1b865f3" })

Plug("rafamadriz/friendly-snippets")

Plug("L3MON4D3/LuaSnip", { ["tag"] = "v2.*" })
Plug("onsails/lspkind.nvim", { ["commit"] = "1735dd5a5054c1fb7feaf8e8658dbab925f4f0cf" })

Plug("Exafunction/codeium.nvim")
--[[]]

Plug("nvim-treesitter/nvim-treesitter", { ["tag"] = "v0.9.*" })

Plug("numToStr/Comment.nvim", { ["commit"] = "e30b7f2008e52442154b66f7c519bfd2f1e32acb" })
Plug("folke/todo-comments.nvim", { ["commit"] = "51e10f838e84b4756c16311d0b1ef0972c6482d2" })
Plug("JoosepAlviste/nvim-ts-context-commentstring", { ["commit"] = "cb064386e667def1d241317deed9fd1b38f0dc2e" })
Plug("kylechui/nvim-surround", { ["tag"] = "v2.3.*" })
Plug("windwp/nvim-autopairs", { ["commit"] = "c15de7e7981f1111642e7e53799e1211d4606cb9" })
Plug("nat-418/boole.nvim", { ["commit"] = "7b4a3dae28e3b2497747aa840439e9493cabdc49" })
Plug("tpope/vim-repeat", { ["commit"] = "24afe922e6a05891756ecf331f39a1f6743d3d5a" })

--[[ Git ]]
Plug("tpope/vim-fugitive")
Plug("lewis6991/gitsigns.nvim", { ["commit"] = "6b1a14eabcebbcca1b9e9163a26b2f8371364cb7" })
Plug("akinsho/git-conflict.nvim", { ["tag"] = "*" })
-- Plug("ThePrimeagen/git-worktree.nvim") -- hasn't had update in months and has a lot of nasty
-- sounding open issues
--[[]]

--[[ Navigation and Finders ]]
Plug("nvim-lua/plenary.nvim", { ["tag"] = "v0.1.4" })
Plug("nvim-telescope/telescope.nvim", { ["commit"] = "7bd2f9b72f8449780b79bcf351534e2cd36ec43a" })
Plug("nvim-telescope/telescope-ui-select.nvim", { ["commit"] = "6e51d7da30bd139a6950adf2a47fda6df9fa06d2" })
Plug("nvim-telescope/telescope-file-browser.nvim", { ["commit"] = "a7ab9a957b17199183388c6f357d614fcaa508e5" })
Plug(
	"nvim-telescope/telescope-fzf-native.nvim",
	{ ["do"] = "make", ["commit"] = "9ef21b2e6bb6ebeaf349a0781745549bbb870d27" }
)

Plug("ThePrimeagen/harpoon", { ["branch"] = "harpoon2" })

Plug("ggandor/leap.nvim", { ["commit"] = "3b1d76ee9cd5a12a8f7a42f0e91124332860205c" })
--[[]]

--[[ Projects ]]
Plug("tpope/vim-obsession")
--[[]]

--[[ Visual/UI ]]
Plug("lukas-reineke/indent-blankline.nvim", { ["as"] = "ibl", ["commit"] = "65e20ab94a26d0e14acac5049b8641336819dfc7" })
Plug("norcalli/nvim-colorizer.lua", { ["commit"] = "a065833f35a3a7cc3ef137ac88b5381da2ba302e" })
Plug("HiPhish/rainbow-delimiters.nvim", { ["commit"] = "5c9660801ce345cd3835e1947c12b54290ab7e71" })
Plug("ziontee113/color-picker.nvim", { ["commit"] = "06cb5f853535dea529a523e9a0e8884cdf9eba4d" })
Plug("folke/zen-mode.nvim", { ["commit"] = "78557d972b4bfbb7488e17b5703d25164ae64e6a" })
Plug("folke/twilight.nvim", { ["commit"] = "8b7b50c0cb2dc781b2f4262a5ddd57571556d1e4" })
Plug("xiyaowong/nvim-transparent", { ["commit"] = "fd35a46f4b7c1b244249266bdcb2da3814f01724" })
Plug("karb94/neoscroll.nvim", { ["commit"] = "a731f66f1d39ec6175fd201c5bf849e54abda99c" })
Plug("romgrk/nvim-treesitter-context", { ["commit"] = "1b9c756c0cad415f0a2661c858448189dd120c15" })
Plug("tversteeg/registers.nvim", { ["tag"] = "v2.3.*" }) -- not actively maintained (just pr's)
Plug("kevinhwang91/nvim-ufo", { ["commit"] = "aa2e676af592b4e99c105d80d6eafd1afc215d99" })
Plug("nvim-tree/nvim-tree.lua", { ["commit"] = "8b2c5c678be4b49dff6a2df794877000113fd77b" })
Plug("antosha417/nvim-lsp-file-operations", { ["commit"] = "92a673de7ecaa157dd230d0128def10beb56d103" })
Plug("mbbill/undotree", { ["commit"] = "56c684a805fe948936cda0d1b19505b84ad7e065" })
Plug("kevinhwang91/nvim-bqf", { ["commit"] = "1b24dc6050c34e8cd377b6b4cd6abe40509e0187" })
Plug("tpope/vim-dadbod", { ["commit"] = "7888cb7164d69783d3dce4e0283decd26b82538b" })
Plug("kristijanhusak/vim-dadbod-ui", { ["commit"] = "2527310098e7458488e61a528614da142aa2dc42" })
Plug("mechatroner/rainbow_csv", { ["commit"] = "9997a58bca39c961c3a1ba5bf1e3a180fb17146f" })
Plug("folke/noice.nvim", { ["commit"] = "03c6a75661e68012e30b0ed81f050358b1e2233c" })
Plug("MunifTanjim/nui.nvim", { ["commit"] = "61574ce6e60c815b0a0c4b5655b8486ba58089a1" })
Plug("nvimdev/lspsaga.nvim", { ["commit"] = "6f920cfabddb9b7de5a3a4d0b7cd4f0774ae23e2" })

Plug("rcarriga/nvim-notify", { ["commit"] = "d333b6f167900f6d9d42a59005d82919830626bf" })

Plug("j-hui/fidget.nvim", { ["commit"] = "ef99df04a1c53a453602421bc0f756997edc8289" })
Plug("luukvbaal/statuscol.nvim", { ["commit"] = "d6f7f5437c5404d958b88bb73e0721b1c0e09223" })
Plug("m4xshen/smartcolumn.nvim")
Plug("mcauley-penney/visual-whitespace.nvim")

Plug("nvim-lualine/lualine.nvim", { ["commit"] = "0a5a66803c7407767b799067986b4dc3036e1983" })
Plug("akinsho/toggleterm.nvim", { ["tag"] = "v2.*" })
Plug("SmiteshP/nvim-navic", { ["commit"] = "8649f694d3e76ee10c19255dece6411c29206a54" })
Plug("utilyre/barbecue.nvim", { ["as"] = "barbecue", ["tag"] = "v1.2.*" })
Plug("kyazdani42/nvim-web-devicons", { ["tag"] = "v0.*" })
Plug("stevearc/oil.nvim", { ["tag"] = "v2.11.*" })
--[[]]
--
--[[ Better Filetype support]]
Plug("chrisbra/csv.vim", { ["commit"] = "4d5255829afe3b6badb0c8a040116704c0d3213c" })
Plug("udalov/kotlin-vim", { ["commit"] = "53fe045906df8eeb07cb77b078fc93acda6c90b8" })
--[[]]

--{{{ Notes
Plug("epwalsh/obsidian.nvim")
-- Plug("lukas-reineke/headlines.nvim")
Plug("3rd/image.nvim")
Plug("jmbuhr/otter.nvim")
Plug("bullets-vim/bullets.vim")
Plug("godlygeek/tabular", { ["commit"] = "339091ac4dd1f17e225fe7d57b48aff55f99b23a" })
Plug("dhruvasagar/vim-table-mode")
Plug("MeanderingProgrammer/markdown.nvim")
--}}}
vim.fn["plug#end"]()
