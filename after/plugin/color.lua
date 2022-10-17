-- set catppuccin flavour based on time of day
--[[ local hour = tonumber(os.date('%H'))
local bg = (hour > 8 and hour < 19) and 'light' or 'dark'
if vim.o.bg ~= bg then vim.opt.bg = bg end
vim.g.catppuccin_flavour = (vim.o.bg == "light" and "latte" or "macchiato") ]]
vim.g.catppuccin_flavour = 'macchiato'
vim.cmd[[colorscheme catppuccin]]
