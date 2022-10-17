require("faith")


vim.cmd[[source ~/.config/nvim/treesitter-folds.vim]]
vim.cmd [[source ~/.config/nvim/jsonc.vim]]

-- LSP
require("faith.lsp")


vim.notify = require("notify")

require("faith.catppuccin")
